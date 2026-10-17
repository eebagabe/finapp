import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/year_month.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../../categories/presentation/category_field.dart';
import '../data/card_purchase_repository.dart';
import '../data/credit_card_repository.dart';
import '../domain/card_purchase.dart';
import 'widgets/purchase_fields.dart';

/// Lançamento de compra no cartão, à vista ou parcelada.
///
/// Com [cardId] nulo, o cartão é escolhido no formulário.
class CardPurchaseFormPage extends ConsumerStatefulWidget {
  const CardPurchaseFormPage({this.cardId, super.key});

  final int? cardId;

  @override
  ConsumerState<CardPurchaseFormPage> createState() =>
      _CardPurchaseFormPageState();
}

class _CardPurchaseFormPageState extends ConsumerState<CardPurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _installments = TextEditingController(text: '2');

  int? _cardId;
  DateTime _purchaseDate = dateOnly(DateTime.now());
  bool _isInstallment = false;
  YearMonth? _invoiceMonth;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    _cardId = widget.cardId;
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _installments.dispose();
    super.dispose();
  }

  int get _installmentCount =>
      _isInstallment ? (int.tryParse(_installments.text) ?? 0) : 1;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(cardPurchaseRepositoryProvider)
        .create(
          CardPurchaseDraft(
            cardId: _cardId!,
            description: _description.text,
            totalCents: parseCents(_amount.text)!,
            purchaseDate: _purchaseDate,
            installmentCount: _installmentCount,
            firstInvoiceMonth: _invoiceMonth,
            categoryId: _categoryId,
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider).value ?? const [];
    final card = cards.where((c) => c.id == _cardId).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Lançamento no cartão')),
      body: cards.isEmpty
          ? const EmptyState(
              icon: Icons.credit_card_off_outlined,
              message: 'Cadastre um cartão primeiro.',
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.spacing),
                children: [
                  if (widget.cardId == null) ...[
                    DropdownButtonFormField<int>(
                      initialValue: _cardId,
                      decoration: const InputDecoration(labelText: 'Cartão'),
                      items: [
                        for (final c in cards)
                          DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ],
                      validator: (value) =>
                          value == null ? 'Escolha o cartão' : null,
                      onChanged: (value) => setState(() {
                        _cardId = value;
                        _invoiceMonth = null;
                      }),
                    ),
                    const FormGap(),
                  ],
                  TextFormField(
                    controller: _description,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Ex.: Exame',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: requiredText,
                  ),
                  const FormGap(),
                  MoneyField(
                    controller: _amount,
                    label: 'Valor total',
                    onChanged: (_) => setState(() {}),
                  ),
                  const FormGap(),
                  DateField(
                    label: 'Data da compra',
                    value: _purchaseDate,
                    onChanged: (date) => setState(() {
                      _purchaseDate = dateOnly(date);
                      _invoiceMonth = null;
                    }),
                  ),
                  const FormGap(),
                  CategoryField(
                    value: _categoryId,
                    onChanged: (value) => setState(() => _categoryId = value),
                  ),
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
                      purchaseDate: _purchaseDate,
                      totalCents: parseCents(_amount.text),
                      installmentCount: _installmentCount,
                      invoiceMonth: _invoiceMonth,
                      onInvoiceMonthChanged: (value) =>
                          setState(() => _invoiceMonth = value),
                    ),
                  const SizedBox(height: 32),
                  FilledButton(onPressed: _save, child: const Text('Salvar')),
                ],
              ),
            ),
    );
  }
}
