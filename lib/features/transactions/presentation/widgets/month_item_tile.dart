import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/year_month.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../summary/domain/monthly_summary.dart';
import '../../data/month_item_actions.dart';
import 'month_item_sheet.dart';

/// Linha de item do mês com status pago/pendente.
///
/// O círculo à esquerda marca/desmarca como pago (data de hoje). Tocar na
/// linha abre as demais ações.
class MonthItemTile extends ConsumerWidget {
  const MonthItemTile({required this.item, required this.month, super.key});

  final MonthItem item;
  final YearMonth month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final details = [
      formatDayMonth(item.date),
      ?item.subtitle,
      ?item.categoryName,
      if (item.isPaid)
        '${item.isIncome ? 'recebido' : 'pago'} em ${formatDayMonth(item.paidAt!)}',
      if (item.isAdjusted) 'padrão ${formatCents(item.defaultAmountCents!)}',
    ].join(' · ');

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 4, right: 16),
      leading: item.isPayable
          ? _StatusButton(
              item: item,
              onPressed: () => ref
                  .read(monthItemActionsProvider)
                  .setPaid(item, month, item.isPaid ? null : DateTime.now()),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.credit_card, color: colors.mutedText),
            ),
      title: Text(
        item.title,
        style: item.isPaid ? TextStyle(color: colors.mutedText) : null,
      ),
      subtitle: Text(details),
      trailing: Text(
        '${item.isIncome ? '+ ' : ''}${formatCents(item.amountCents)}',
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: !item.countsInTotals || item.isPaid
              ? colors.mutedText
              : item.isIncome
              ? colors.positive
              : null,
        ),
      ),
      onTap: () => showMonthItemSheet(context, item: item, month: month),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({required this.item, required this.onPressed});

  final MonthItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final paid = item.isPaid;
    final label = item.isIncome
        ? (paid ? 'Desfazer recebimento' : 'Marcar como recebido')
        : (paid ? 'Desfazer pagamento' : 'Marcar como pago');
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(
        paid ? Icons.check_circle : Icons.radio_button_unchecked,
        color: paid
            ? context.appColors.positive
            : Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
