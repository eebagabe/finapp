import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/year_month.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/money_text.dart';
import '../../transactions/data/monthly_record_repository.dart';
import '../../transactions/domain/entry_types.dart';
import '../data/card_purchase_repository.dart';
import '../data/credit_card_repository.dart';
import '../data/invoice_repository.dart';
import '../domain/invoice.dart';

/// Fatura do cartão mês a mês, com os lançamentos que a compõem.
class CreditCardDetailPage extends ConsumerStatefulWidget {
  const CreditCardDetailPage({required this.cardId, super.key});

  final int cardId;

  @override
  ConsumerState<CreditCardDetailPage> createState() =>
      _CreditCardDetailPageState();
}

class _CreditCardDetailPageState extends ConsumerState<CreditCardDetailPage> {
  YearMonth? _month;

  @override
  Widget build(BuildContext context) {
    final card = ref.watch(creditCardProvider(widget.cardId)).value;
    // Começa na fatura em que cairia uma compra feita hoje.
    final month = _month ??= card?.invoiceMonthFor(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(card?.name ?? 'Cartão'),
        actions: [
          IconButton(
            tooltip: 'Editar cartão',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editCard(widget.cardId)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.newCardPurchase(widget.cardId)),
        icon: const Icon(Icons.add),
        label: const Text('Lançamento'),
      ),
      body: month == null
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _InvoiceMonthSelector(
                  month: month,
                  onChanged: (value) => setState(() => _month = value),
                ),
                const SizedBox(height: 8),
                ref
                    .watch(invoiceProvider((widget.cardId, month)))
                    .when(
                      data: (invoice) => invoice == null
                          ? const SizedBox.shrink()
                          : _InvoiceContent(invoice: invoice),
                      loading: () => const LoadingView(),
                      error: (error, _) => ErrorView(error),
                    ),
              ],
            ),
    );
  }
}

class _InvoiceMonthSelector extends StatelessWidget {
  const _InvoiceMonthSelector({required this.month, required this.onChanged});

  final YearMonth month;
  final ValueChanged<YearMonth> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Fatura anterior',
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onChanged(month.previous),
        ),
        Text(
          'Fatura de ${formatMonthYear(month)}',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        IconButton(
          tooltip: 'Próxima fatura',
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onChanged(month.next),
        ),
      ],
    );
  }
}

class _InvoiceContent extends ConsumerWidget {
  const _InvoiceContent({required this.invoice});

  final Invoice invoice;

  Future<void> _editTotal(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<_TotalDialogResult>(
      context: context,
      builder: (_) => _InvoiceTotalDialog(initialCents: invoice.overrideCents),
    );
    if (result == null) return;
    await ref
        .read(monthlyRecordRepositoryProvider)
        .setAmountOverride(
          RecordSource.cardInvoice,
          invoice.card.id,
          invoice.month,
          result.cents,
        );
  }

  Future<void> _deletePurchase(
    BuildContext context,
    WidgetRef ref,
    InvoiceLine line,
  ) async {
    final confirmed = await confirmAction(
      context,
      title: 'Excluir lançamento?',
      message: line.installmentLabel == null
          ? '"${line.description}" será excluído.'
          : '"${line.description}" e todas as suas parcelas serão excluídos.',
    );
    if (!confirmed) return;
    await ref.read(cardPurchaseRepositoryProvider).delete(line.sourceId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vence em ${formatDate(invoice.dueDate)}',
                      style: TextStyle(color: muted),
                    ),
                  ),
                  if (invoice.isPaid)
                    Chip(
                      label: const Text('Paga'),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide.none,
                      backgroundColor: context.appColors.positive.withValues(
                        alpha: 0.12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              MoneyText(
                invoice.totalCents,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (invoice.hasOverride)
                Text(
                  'Valor informado manualmente · '
                  'soma dos lançamentos: ${formatCents(invoice.computedCents)}',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _editTotal(context, ref),
                icon: const Icon(Icons.edit_note, size: 20),
                label: Text(
                  invoice.hasOverride
                      ? 'Alterar valor total'
                      : 'Informar valor total da fatura',
                ),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),
            ],
          ),
        ),
        const SectionHeader('Lançamentos'),
        if (invoice.lines.isEmpty)
          const EmptyState(
            icon: Icons.receipt_outlined,
            message: 'Nenhum lançamento nesta fatura.',
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final line in invoice.lines)
                  ListTile(
                    title: Text(line.description),
                    subtitle: Text(
                      [
                        formatDate(line.date),
                        ?line.installmentLabel,
                        if (line.kind == InvoiceLineKind.fixedExpense)
                          'despesa fixa',
                      ].join(' · '),
                    ),
                    trailing: Text(
                      formatCents(line.amountCents),
                      style: textTheme.bodyLarge,
                    ),
                    onLongPress: line.kind == InvoiceLineKind.purchase
                        ? () => _deletePurchase(context, ref, line)
                        : null,
                  ),
              ],
            ),
          ),
        if (invoice.lines.any((l) => l.kind == InvoiceLineKind.purchase))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Toque e segure um lançamento para excluir.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: muted),
            ),
          ),
      ],
    );
  }
}

class _TotalDialogResult {
  const _TotalDialogResult(this.cents);

  /// `null` remove o valor informado e volta a somar os lançamentos.
  final int? cents;
}

class _InvoiceTotalDialog extends StatefulWidget {
  const _InvoiceTotalDialog({this.initialCents});

  final int? initialCents;

  @override
  State<_InvoiceTotalDialog> createState() => _InvoiceTotalDialogState();
}

class _InvoiceTotalDialogState extends State<_InvoiceTotalDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount = TextEditingController(
    text: MoneyField.initialText(widget.initialCents),
  );

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Valor total da fatura'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Use quando não quiser lançar item por item. '
              'Este valor substitui a soma dos lançamentos.',
            ),
            const SizedBox(height: 16),
            MoneyField(controller: _amount, label: 'Valor total'),
          ],
        ),
      ),
      actions: [
        if (widget.initialCents != null)
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(const _TotalDialogResult(null)),
            child: const Text('Remover'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context)
                .pop(_TotalDialogResult(parseCents(_amount.text)));
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
