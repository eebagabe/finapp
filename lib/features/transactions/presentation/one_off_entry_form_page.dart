import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/year_month.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/form_fields.dart';
import '../../credit_cards/data/card_purchase_repository.dart';
import '../../credit_cards/data/credit_card_repository.dart';
import '../../credit_cards/domain/card_purchase.dart';
import '../../credit_cards/presentation/widgets/purchase_fields.dart';
import '../data/one_off_entry_repository.dart';
import '../domain/entry_types.dart';
import '../domain/one_off_entry.dart';

/// Lançamento avulso: receita ou despesa de um mês específico.
///
/// Despesas podem ser à vista (fora do cartão) ou no cartão, parceladas ou
/// não. No cartão, viram uma compra na fatura correspondente.
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
  YearMonth? _invoiceMonth;

  bool get _onCard => _kind == EntryKind.expense && _cardId != null;

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
    if (_onCard) {
      await ref
          .read(cardPurchaseRepositoryProvider)
          .create(
            CardPurchaseDraft(
              cardId: _cardId!,
              description: _description.text,
              totalCents: amount,
              purchaseDate: _date,
              installmentCount: _installmentCount,
              firstInvoiceMonth: _invoiceMonth,
            ),
          );
    } else {
      await ref
          .read(oneOffEntryRepositoryProvider)
          .create(
            OneOffEntryDraft(
              kind: _kind,
              description: _description.text,
              amountCents: amount,
              date: _date,
            ),
          );
    }
    if (mounted) context.pop();
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
                hintText: _kind == EntryKind.expense
                    ? 'Ex.: Exame'
                    : 'Ex.: Freela',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: requiredText,
            ),
            const FormGap(),
            MoneyField(
              controller: _amount,
              label: _onCard ? 'Valor total' : 'Valor',
              onChanged: (_) => setState(() {}),
            ),
            const FormGap(),
            DateField(
              label: _onCard ? 'Data da compra' : 'Data',
              value: _date,
              onChanged: (date) => setState(() {
                _date = dateOnly(date);
                _invoiceMonth = null;
              }),
            ),
            if (_kind == EntryKind.expense) ...[
              const FormGap(),
              DropdownButtonFormField<int?>(
                initialValue: _cardId,
                decoration: const InputDecoration(labelText: 'Pagamento'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('À vista, fora do cartão'),
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
            if (_onCard) ...[
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
