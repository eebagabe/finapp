import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../../credit_cards/data/credit_card_repository.dart';
import '../data/fixed_expense_repository.dart';
import '../domain/fixed_expense.dart';

/// Cadastro e edição de despesa fixa. Com [expenseId] nulo, cria uma nova.
class FixedExpenseFormPage extends ConsumerWidget {
  const FixedExpenseFormPage({this.expenseId, super.key});

  final int? expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (expenseId == null) return const _FixedExpenseForm();
    return ref
        .watch(fixedExpenseProvider(expenseId!))
        .when(
          data: (expense) => _FixedExpenseForm(initial: expense),
          loading: () => const Scaffold(body: LoadingView()),
          error: (error, _) => Scaffold(body: ErrorView(error)),
        );
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
  late final TextEditingController _day;
  late bool _active;
  int? _creditCardId;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.initial;
    _description = TextEditingController(text: expense?.description);
    _amount = TextEditingController(
      text: MoneyField.initialText(expense?.defaultAmountCents),
    );
    _day = TextEditingController(text: expense?.dueDay.toString());
    _active = expense?.active ?? true;
    _creditCardId = expense?.creditCardId;
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _day.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final input = FixedExpenseInput(
      description: _description.text,
      defaultAmountCents: parseCents(_amount.text)!,
      dueDay: int.parse(_day.text),
      active: _active,
      creditCardId: _creditCardId,
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
    final cards = ref.watch(creditCardsProvider).value ?? const [];
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
            IntField(
              controller: _day,
              label: 'Dia do vencimento',
              min: 1,
              max: 31,
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
