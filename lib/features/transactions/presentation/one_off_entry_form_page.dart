import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/year_month.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../../categories/presentation/category_field.dart';
import '../../credit_cards/data/card_purchase_repository.dart';
import '../../credit_cards/data/credit_card_repository.dart';
import '../../credit_cards/domain/card_purchase.dart';
import '../../credit_cards/presentation/widgets/purchase_fields.dart';
import '../../fixed_expenses/data/fixed_expense_repository.dart';
import '../../fixed_expenses/domain/fixed_expense.dart';
import '../../incomes/data/income_repository.dart';
import '../../incomes/domain/income.dart';
import '../data/one_off_entry_repository.dart';
import '../domain/entry_types.dart';
import '../domain/one_off_entry.dart';

/// Novo lançamento: receita ou despesa.
///
/// - Avulso: vale só para a data informada.
/// - Fixo ("repetir todo mês"): vira uma receita ou despesa fixa nas
///   configurações, a partir da data informada.
/// - Despesas avulsas podem ser no cartão, parceladas ou não, e viram uma
///   compra na fatura (cujo mês pode ser ajustado).
class OneOffEntryFormPage extends ConsumerStatefulWidget {
  const OneOffEntryFormPage({this.initialKind = EntryKind.expense, super.key});

  final EntryKind initialKind;

  @override
  ConsumerState<OneOffEntryFormPage> createState() =>
      _OneOffEntryFormPageState();
}

class _OneOffEntryFormPageState extends ConsumerState<OneOffEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _installments = TextEditingController(text: '2');

  late EntryKind _kind = widget.initialKind;
  DateTime _date = dateOnly(DateTime.now());

  /// Cartão escolhido; `null` = fora do cartão.
  int? _cardId;
  bool _isInstallment = false;
  bool _isRecurring = false;
  YearMonth? _invoiceMonth;
  int? _categoryId;

  bool get _isExpense => _kind == EntryKind.expense;

  /// Compra no cartão (só despesas avulsas; fixas no cartão entram na fatura
  /// pela regra da despesa fixa).
  bool get _isCardPurchase => _isExpense && _cardId != null && !_isRecurring;

  int get _installmentCount =>
      _isInstallment ? (int.tryParse(_installments.text) ?? 0) : 1;

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _installments.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseCents(_amount.text)!;
    final description = _description.text;
    if (_isRecurring && _isExpense) {
      await ref
          .read(fixedExpenseRepositoryProvider)
          .create(
            FixedExpenseInput(
              description: description,
              defaultAmountCents: amount,
              dueDay: _date.day,
              active: true,
              creditCardId: _cardId,
              startMonth: YearMonth.fromDate(_date),
              categoryId: _categoryId,
            ),
          );
    } else if (_isRecurring) {
      await ref
          .read(incomeRepositoryProvider)
          .create(
            IncomeInput(
              description: description,
              amountCents: amount,
              dayOfMonth: _date.day,
              active: true,
              startMonth: YearMonth.fromDate(_date),
              categoryId: _categoryId,
            ),
          );
    } else if (_isCardPurchase) {
      await ref
          .read(cardPurchaseRepositoryProvider)
          .create(
            CardPurchaseDraft(
              cardId: _cardId!,
              description: description,
              totalCents: amount,
              purchaseDate: _date,
              installmentCount: _installmentCount,
              firstInvoiceMonth: _invoiceMonth,
              categoryId: _categoryId,
            ),
          );
    } else {
      await ref
          .read(oneOffEntryRepositoryProvider)
          .create(
            OneOffEntryDraft(
              kind: _kind,
              description: description,
              amountCents: amount,
              date: _date,
              categoryId: _categoryId,
            ),
          );
    }
    if (!mounted) return;
    if (_isRecurring) {
      showMessage(
        context,
        '${_isExpense ? 'Despesa fixa salva' : 'Receita fixa salva'} '
        'em Configurações',
      );
    }
    context.pop();
  }

  String get _dateLabel {
    if (_isRecurring) {
      return _isExpense
          ? 'Próxima data de pagamento'
          : 'Próxima data de recebimento';
    }
    return _isCardPurchase ? 'Data da compra' : 'Data';
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider).value ?? const [];
    final card = cards.where((c) => c.id == _cardId).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Novo lançamento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          children: [
            SegmentedButton<EntryKind>(
              segments: const [
                ButtonSegment(
                  value: EntryKind.expense,
                  label: Text('Despesa'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: EntryKind.income,
                  label: Text('Receita'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (selection) =>
                  setState(() => _kind = selection.single),
            ),
            const FormGap(),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: switch ((_isExpense, _isRecurring)) {
                  (true, true) => 'Ex.: Internet',
                  (true, false) => 'Ex.: Exame',
                  (false, true) => 'Ex.: Salário',
                  (false, false) => 'Ex.: Freela',
                },
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: requiredText,
            ),
            const FormGap(),
            MoneyField(
              controller: _amount,
              label: _isCardPurchase ? 'Valor total' : 'Valor',
              onChanged: (_) => setState(() {}),
            ),
            const FormGap(),
            SwitchListTile(
              title: Text(_isExpense ? 'Despesa fixa' : 'Receita fixa'),
              subtitle: const Text('Repete todo mês a partir da data'),
              value: _isRecurring,
              onChanged: (value) => setState(() => _isRecurring = value),
              contentPadding: EdgeInsets.zero,
            ),
            const FormGap(),
            DateField(
              label: _dateLabel,
              helperText: _isRecurring
                  ? 'Todo dia ${_date.day}, a partir de '
                        '${formatDayMonthName(_date)}'
                  : null,
              value: _date,
              onChanged: (date) => setState(() {
                _date = dateOnly(date);
                _invoiceMonth = null;
              }),
            ),
            const FormGap(),
            CategoryField(
              value: _categoryId,
              onChanged: (value) => setState(() => _categoryId = value),
            ),
            if (_isExpense) ...[
              const FormGap(),
              DropdownButtonFormField<int?>(
                initialValue: _cardId,
                decoration: const InputDecoration(labelText: 'Pagamento'),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      _isRecurring
                          ? 'Fora do cartão'
                          : 'À vista, fora do cartão',
                    ),
                  ),
                  for (final c in cards)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text('Cartão ${c.name}'),
                    ),
                ],
                onChanged: (value) => setState(() {
                  _cardId = value;
                  _invoiceMonth = null;
                }),
              ),
            ],
            if (_isCardPurchase) ...[
              const FormGap(),
              InstallmentSelector(
                enabled: _isInstallment,
                controller: _installments,
                onEnabledChanged: (value) =>
                    setState(() => _isInstallment = value),
                onCountChanged: () => setState(() {}),
              ),
              const FormGap(),
              if (card != null)
                PurchasePreview(
                  card: card,
                  purchaseDate: _date,
                  totalCents: parseCents(_amount.text),
                  installmentCount: _installmentCount,
                  invoiceMonth: _invoiceMonth,
                  onInvoiceMonthChanged: (value) =>
                      setState(() => _invoiceMonth = value),
                ),
            ],
            const SizedBox(height: 32),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
