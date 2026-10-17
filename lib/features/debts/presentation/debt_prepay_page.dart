import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/year_month.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';

/// Antecipação de parcelas, com desconto opcional.
class DebtPrepayPage extends ConsumerWidget {
  const DebtPrepayPage({required this.debtId, super.key});

  final int debtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(debtProvider(debtId))
        .when(
          data: (debt) => debt == null || debt.pendingInstallments.isEmpty
              ? const Scaffold(
                  body: EmptyState(
                    icon: Icons.check_circle_outline,
                    message: 'Nenhuma parcela pendente.',
                  ),
                )
              : _PrepayForm(debt: debt),
          loading: () => const Scaffold(body: LoadingView()),
          error: (error, _) => Scaffold(body: ErrorView(error)),
        );
  }
}

class _PrepayForm extends ConsumerStatefulWidget {
  const _PrepayForm({required this.debt});

  final Debt debt;

  @override
  ConsumerState<_PrepayForm> createState() => _PrepayFormState();
}

class _PrepayFormState extends ConsumerState<_PrepayForm> {
  final _formKey = GlobalKey<FormState>();
  final _paid = TextEditingController();
  final _selected = <int>{};
  DateTime _paidAt = dateOnly(DateTime.now());

  List<DebtInstallment> get _pending => widget.debt.pendingInstallments;

  int get _originalCents => _pending
      .where((i) => _selected.contains(i.id))
      .fold(0, (sum, i) => sum + i.amountCents);

  /// Vazio = pagou o valor cheio (sem desconto).
  int get _paidCents => parseCents(_paid.text) ?? _originalCents;

  @override
  void dispose() {
    _paid.dispose();
    super.dispose();
  }

  /// Seleciona as [count] últimas parcelas pendentes.
  void _selectLast(int count) {
    setState(() {
      _selected
        ..clear()
        ..addAll(_pending.reversed.take(count).map((i) => i.id));
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selected.isEmpty) {
      showMessage(context, 'Escolha ao menos uma parcela');
      return;
    }
    await ref
        .read(debtRepositoryProvider)
        .prepay(
          installmentIds: _selected.toList(),
          paidCents: _paidCents,
          paidAt: _paidAt,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    final original = _originalCents;
    final discount = original - _paidCents;

    return Scaffold(
      appBar: AppBar(title: const Text('Antecipar parcelas')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          children: [
            Text(widget.debt.description, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Escolha as parcelas que você pagou antes do vencimento.',
              style: textTheme.bodySmall?.copyWith(color: muted),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final count in const [1, 2, 3, 6])
                  if (count <= _pending.length)
                    ActionChip(
                      label: Text(count == 1 ? 'Última' : 'Últimas $count'),
                      onPressed: () => _selectLast(count),
                    ),
                ActionChip(
                  label: const Text('Todas'),
                  onPressed: () => _selectLast(_pending.length),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final installment in _pending)
                    CheckboxListTile(
                      value: _selected.contains(installment.id),
                      onChanged: (checked) => setState(() {
                        checked == true
                            ? _selected.add(installment.id)
                            : _selected.remove(installment.id);
                      }),
                      title: Text(
                        '${installment.number}ª · '
                        '${formatDate(installment.dueDate)}',
                      ),
                      secondary: Text(formatCents(installment.amountCents)),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                ],
              ),
            ),
            const FormGap(),
            DateField(
              label: 'Data do pagamento',
              value: _paidAt,
              onChanged: (date) => setState(() => _paidAt = dateOnly(date)),
            ),
            const FormGap(),
            TextFormField(
              controller: _paid,
              decoration: InputDecoration(
                labelText: 'Quanto você pagou (opcional)',
                hintText: formatCents(original),
                helperText: 'Deixe vazio se não teve desconto',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: MoneyField.formatters,
              onChanged: (_) => setState(() {}),
              validator: (_) => _paidCents > original
                  ? 'Maior que o valor das parcelas'
                  : null,
            ),
            const FormGap(),
            if (_selected.isNotEmpty)
              AppCard(
                color: Theme.of(context).colorScheme.primaryContainer
                    .withValues(alpha: 0.45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selected.length} parcela(s) · '
                      'valor original ${formatCents(original)}',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pago: ${formatCents(_paidCents)}',
                      style: textTheme.titleMedium,
                    ),
                    if (discount > 0)
                      Text(
                        'Desconto: ${formatCents(discount)}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.appColors.positive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _save,
              child: const Text('Confirmar antecipação'),
            ),
          ],
        ),
      ),
    );
  }
}
