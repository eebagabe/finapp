import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/installments.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../data/card_purchase_repository.dart';
import '../data/credit_card_repository.dart';
import '../domain/card_purchase.dart';
import '../domain/credit_card.dart';

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
  static const _quickInstallments = [2, 3, 4, 5, 6, 10, 12];

  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _installments = TextEditingController(text: '2');

  int? _cardId;
  DateTime _purchaseDate = dateOnly(DateTime.now());
  bool _isInstallment = false;

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
                      onChanged: (value) => setState(() => _cardId = value),
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
                    onChanged: (date) =>
                        setState(() => _purchaseDate = dateOnly(date)),
                  ),
                  const FormGap(),
                  SwitchListTile(
                    title: const Text('Parcelado'),
                    value: _isInstallment,
                    onChanged: (value) =>
                        setState(() => _isInstallment = value),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_isInstallment) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final count in _quickInstallments)
                          ChoiceChip(
                            label: Text('${count}x'),
                            selected: _installmentCount == count,
                            onSelected: (_) => setState(
                              () => _installments.text = count.toString(),
                            ),
                          ),
                      ],
                    ),
                    const FormGap(),
                    IntField(
                      controller: _installments,
                      label: 'Quantidade de parcelas',
                      min: 2,
                      max: 48,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                  const FormGap(),
                  if (card != null)
                    _PurchasePreview(
                      card: card,
                      purchaseDate: _purchaseDate,
                      totalCents: parseCents(_amount.text),
                      installmentCount: _installmentCount,
                    ),
                  const SizedBox(height: 32),
                  FilledButton(onPressed: _save, child: const Text('Salvar')),
                ],
              ),
            ),
    );
  }
}

/// Mostra em qual fatura a compra vai cair e o valor das parcelas.
class _PurchasePreview extends StatelessWidget {
  const _PurchasePreview({
    required this.card,
    required this.purchaseDate,
    required this.totalCents,
    required this.installmentCount,
  });

  final CreditCard card;
  final DateTime purchaseDate;
  final int? totalCents;
  final int installmentCount;

  @override
  Widget build(BuildContext context) {
    final invoiceMonth = card.invoiceMonthFor(purchaseDate);
    final dueDate = card.invoiceDueDate(invoiceMonth);
    final total = totalCents;
    final textTheme = Theme.of(context).textTheme;

    String? installmentsText;
    if (total != null && installmentCount >= 1) {
      final parts = splitInstallments(total, installmentCount);
      installmentsText = installmentCount == 1
          ? 'À vista: ${formatCents(total)}'
          : parts.first == parts.last
          ? '${installmentCount}x de ${formatCents(parts.first)}'
          : '${installmentCount}x de ${formatCents(parts.first)} '
                '(última ${formatCents(parts.last)})';
    }

    return AppCard(
      color: Theme.of(context).colorScheme.primaryContainer
          .withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            installmentCount > 1
                ? '1ª parcela na fatura de ${formatMonthYear(invoiceMonth)}'
                : 'Entra na fatura de ${formatMonthYear(invoiceMonth)}',
            style: textTheme.titleSmall,
          ),
          Text(
            'Vencimento em ${formatDate(dueDate)}',
            style: textTheme.bodySmall,
          ),
          if (installmentsText != null) ...[
            const SizedBox(height: 6),
            Text(installmentsText, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
