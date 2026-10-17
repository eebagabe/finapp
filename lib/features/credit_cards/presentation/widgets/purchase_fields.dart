import 'package:flutter/material.dart';

import '../../../../core/domain/installments.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/form_fields.dart';
import '../../domain/credit_card.dart';

/// Opção "Parcelado" com atalhos de quantidade (2x, 3x, ...) e campo livre.
class InstallmentSelector extends StatelessWidget {
  const InstallmentSelector({
    required this.enabled,
    required this.controller,
    required this.onEnabledChanged,
    required this.onCountChanged,
    super.key,
  });

  static const quickCounts = [2, 3, 4, 5, 6, 10, 12];

  final bool enabled;
  final TextEditingController controller;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onCountChanged;

  @override
  Widget build(BuildContext context) {
    final selected = int.tryParse(controller.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          title: const Text('Parcelado'),
          value: enabled,
          onChanged: onEnabledChanged,
          contentPadding: EdgeInsets.zero,
        ),
        if (enabled) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final count in quickCounts)
                ChoiceChip(
                  label: Text('${count}x'),
                  selected: selected == count,
                  onSelected: (_) {
                    controller.text = count.toString();
                    onCountChanged();
                  },
                ),
            ],
          ),
          const FormGap(),
          IntField(
            controller: controller,
            label: 'Quantidade de parcelas',
            min: 2,
            max: 48,
            onChanged: (_) => onCountChanged(),
          ),
        ],
      ],
    );
  }
}

/// Mostra em qual fatura a compra vai cair e o valor das parcelas.
class PurchasePreview extends StatelessWidget {
  const PurchasePreview({
    super.key,
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
