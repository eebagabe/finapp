import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/year_month.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../../categories/presentation/category_field.dart';
import '../../credit_cards/data/credit_card_repository.dart';
import '../data/fixed_expense_repository.dart';
import '../domain/fixed_expense.dart';

/// Cadastro e edição de despesa fixa. Com [expenseId] nulo, cria uma nova.
class FixedExpenseFormPage extends ConsumerWidget {
  const FixedExpenseFormPage({this.expenseId, super.key});

  final int? expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Espera os cartões carregarem: o vínculo é o valor inicial do campo.
    final cards = ref.watch(creditCardsProvider);
    final expense = expenseId == null
        ? const AsyncValue<FixedExpense?>.data(null)
        : ref.watch(fixedExpenseProvider(expenseId!));
    if (cards.hasError) return Scaffold(body: ErrorView(cards.error!));
    if (expense.hasError) return Scaffold(body: ErrorView(expense.error!));
    if (!cards.hasValue || !expense.hasValue) {
      return const Scaffold(body: LoadingView());
    }
    return _FixedExpenseForm(initial: expense.value);
  }
}

class _FixedExpenseForm extends ConsumerStatefulWidget {
  const _FixedExpenseForm({this.initial});

  final FixedExpense? initial;

  @override
  ConsumerState<_FixedExpenseForm> createState() => _FixedExpenseFormState();
}

class _FixedExpenseFormState extends ConsumerState<_FixedExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _description;
  late final TextEditingController _amount;
  late DateTime _nextDate;
  bool _dateChanged = false;
  late bool _active;
  int? _creditCardId;
  int? _categoryId;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.initial;
    _description = TextEditingController(text: expense?.description);
    _amount = TextEditingController(
      text: MoneyField.initialText(expense?.defaultAmountCents),
    );
    _nextDate = expense?.nextDate() ?? dateOnly(DateTime.now());
    _active = expense?.active ?? true;
    _creditCardId = expense?.creditCardId;
    _categoryId = expense?.categoryId;
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final input = FixedExpenseInput(
      description: _description.text,
      defaultAmountCents: parseCents(_amount.text)!,
      dueDay: _nextDate.day,
      active: _active,
      creditCardId: _creditCardId,
      // Na edição, só muda o início se a próxima data foi alterada.
      startMonth: !_isEditing || _dateChanged
          ? YearMonth.fromDate(_nextDate)
          : null,
      categoryId: _categoryId,
    );
    final repository = ref.read(fixedExpenseRepositoryProvider);
    if (_isEditing) {
      await repository.update(widget.initial!.id, input);
    } else {
      await repository.create(input);
    }
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmAction(
      context,
      title: 'Excluir despesa?',
      message: 'Para manter o histórico, prefira marcar como inativa.',
    );
    if (!confirmed) return;
    await ref.read(fixedExpenseRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider).requireValue;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar despesa' : 'Nova despesa fixa'),
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
                hintText: 'Ex.: Energia',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: requiredText,
            ),
            const FormGap(),
            MoneyField(controller: _amount, label: 'Valor padrão (aproximado)'),
            const FormGap(),
            DateField(
              label: 'Próxima data de pagamento',
              helperText: 'Repete todo mês neste dia, a partir desta data',
              value: _nextDate,
              onChanged: (date) => setState(() {
                _nextDate = dateOnly(date);
                _dateChanged = true;
              }),
            ),
            const FormGap(),
            CategoryField(
              value: _categoryId,
              onChanged: (value) => setState(() => _categoryId = value),
            ),
            const FormGap(),
            DropdownButtonFormField<int?>(
              initialValue: cards.any((c) => c.id == _creditCardId)
                  ? _creditCardId
                  : null,
              decoration: const InputDecoration(
                labelText: 'Cobrar no cartão',
                helperText: 'Se vinculada, entra na fatura do cartão',
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Não')),
                for (final card in cards)
                  DropdownMenuItem(value: card.id, child: Text(card.name)),
              ],
              onChanged: (value) => setState(() => _creditCardId = value),
            ),
            const FormGap(),
            SwitchListTile(
              title: const Text('Ativa'),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
