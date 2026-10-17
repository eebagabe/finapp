import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/installments.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';
import '../domain/debt_schedule.dart';

/// Cadastro e edição de dívida. Com [debtId] nulo, cria uma nova.
class DebtFormPage extends ConsumerWidget {
  const DebtFormPage({this.debtId, super.key});

  final int? debtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (debtId == null) return const _DebtForm();
    return ref
        .watch(debtProvider(debtId!))
        .when(
          data: (debt) => _DebtForm(initial: debt),
          loading: () => const Scaffold(body: LoadingView()),
          error: (error, _) => Scaffold(body: ErrorView(error)),
        );
  }
}

class _DebtForm extends ConsumerStatefulWidget {
  const _DebtForm({this.initial});

  final Debt? initial;

  @override
  ConsumerState<_DebtForm> createState() => _DebtFormState();
}

class _DebtFormState extends ConsumerState<_DebtForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _description;
  late final TextEditingController _amount;
  late final TextEditingController _remaining;

  late DebtValueMode _mode;
  late DateTime _nextPayment;
  DateTime? _lastPayment;
  String? _lastPaymentError;

  bool get _isEditing => widget.initial != null;

  int? get _remainingCount => int.tryParse(_remaining.text);

  @override
  void initState() {
    super.initState();
    final debt = widget.initial;
    final pending = debt?.pendingInstallments ?? const <DebtInstallment>[];

    _mode = debt?.valueMode ?? DebtValueMode.installment;
    _description = TextEditingController(text: debt?.description);
    _amount = TextEditingController(
      text: MoneyField.initialText(switch (_mode) {
        _ when debt == null => null,
        DebtValueMode.installment => debt.installmentAmountCents,
        DebtValueMode.total => debt.remainingCents,
      }),
    );
    _nextPayment = pending.firstOrNull?.dueDate ?? dateOnly(DateTime.now());
    _remaining = TextEditingController(
      text: pending.isEmpty ? '' : pending.length.toString(),
    );
    _lastPayment = pending.lastOrNull?.dueDate;
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _remaining.dispose();
    super.dispose();
  }

  /// Parcelas restantes alteradas → recalcula a data da última parcela.
  void _onRemainingChanged(int? remaining) {
    setState(() {
      _lastPaymentError = null;
      _lastPayment = remaining == null || remaining < 1
          ? null
          : DebtSchedule.lastInstallmentDate(_nextPayment, remaining);
    });
  }

  /// Data da última parcela alterada → recalcula as parcelas restantes.
  void _onLastPaymentChanged(DateTime last) {
    final remaining = DebtSchedule.remainingInstallments(_nextPayment, last);
    setState(() {
      _lastPayment = last;
      if (remaining == null) {
        _lastPaymentError = 'Deve ser igual ou depois do próximo pagamento';
      } else {
        _lastPaymentError = null;
        _remaining.text = remaining.toString();
        // Alinha o dia com o próximo pagamento (as parcelas são mensais).
        _lastPayment = DebtSchedule.lastInstallmentDate(
          _nextPayment,
          remaining,
        );
      }
    });
  }

  /// Próximo pagamento alterado → mantém as parcelas e move a data final.
  void _onNextPaymentChanged(DateTime next) {
    setState(() => _nextPayment = dateOnly(next));
    _onRemainingChanged(_remainingCount);
  }

  Future<void> _save() async {
    final formValid = _formKey.currentState!.validate();
    if (!formValid || _lastPaymentError != null) return;

    final draft = DebtDraft(
      description: _description.text,
      valueMode: _mode,
      amountCents: parseCents(_amount.text)!,
      nextPaymentDate: _nextPayment,
      remainingCount: _remainingCount!,
    );
    final repository = ref.read(debtRepositoryProvider);
    if (_isEditing) {
      await repository.update(widget.initial!.id, draft);
    } else {
      await repository.create(draft);
    }
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmAction(
      context,
      title: 'Excluir dívida?',
      message: 'Todas as parcelas, inclusive as pagas, serão excluídas.',
    );
    if (!confirmed) return;
    await ref.read(debtRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.go(AppRoutes.debts);
  }

  String get _amountLabel => switch (_mode) {
    DebtValueMode.installment => 'Valor da parcela',
    DebtValueMode.total when _isEditing => 'Valor total restante',
    DebtValueMode.total => 'Valor total',
  };

  @override
  Widget build(BuildContext context) {
    final paidCount = widget.initial?.paidCount ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar dívida' : 'Nova dívida'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Excluir',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          children: [
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex.: Acordo com Carrefour',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: requiredText,
            ),
            const FormGap(),
            SegmentedButton<DebtValueMode>(
              segments: const [
                ButtonSegment(
                  value: DebtValueMode.installment,
                  label: Text('Valor da parcela'),
                ),
                ButtonSegment(
                  value: DebtValueMode.total,
                  label: Text('Valor total'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) =>
                  setState(() => _mode = selection.single),
            ),
            const FormGap(),
            MoneyField(
              controller: _amount,
              label: _amountLabel,
              onChanged: (_) => setState(() {}),
            ),
            const FormGap(),
            DateField(
              label: 'Próxima data de pagamento',
              value: _nextPayment,
              onChanged: _onNextPaymentChanged,
            ),
            const FormGap(),
            IntField(
              controller: _remaining,
              label: _mode == DebtValueMode.total && !_isEditing
                  ? 'Quantidade de parcelas'
                  : 'Parcelas restantes',
              helperText: paidCount > 0 ? '$paidCount já pagas' : null,
              min: 1,
              max: 480,
              onChanged: _onRemainingChanged,
            ),
            const FormGap(),
            DateField(
              label: 'Data da última parcela',
              value: _lastPayment,
              firstDate: _nextPayment,
              errorText: _lastPaymentError,
              onChanged: _onLastPaymentChanged,
            ),
            const FormGap(),
            _InstallmentPreview(
              mode: _mode,
              amountCents: parseCents(_amount.text),
              count: _remainingCount,
              lastPayment: _lastPayment,
            ),
            const SizedBox(height: 32),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}

/// Resumo do parcelamento que será gerado.
class _InstallmentPreview extends StatelessWidget {
  const _InstallmentPreview({
    required this.mode,
    required this.amountCents,
    required this.count,
    required this.lastPayment,
  });

  final DebtValueMode mode;
  final int? amountCents;
  final int? count;
  final DateTime? lastPayment;

  @override
  Widget build(BuildContext context) {
    final amount = amountCents;
    final total = count;
    if (amount == null || total == null || total < 1) {
      return const SizedBox.shrink();
    }

    final parts = switch (mode) {
      DebtValueMode.installment => List.filled(total, amount),
      DebtValueMode.total => splitInstallments(amount, total),
    };
    final sum = parts.fold(0, (a, b) => a + b);
    final first = parts.first;
    final last = parts.last;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      color: Theme.of(context).colorScheme.primaryContainer
          .withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            last == first
                ? '${total}x de ${formatCents(first)}'
                : '${total}x de ${formatCents(first)} '
                      '(última ${formatCents(last)})',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Total restante: ${formatCents(sum)}',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
