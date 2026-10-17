import 'package:flutter/material.dart';

import '../../../../core/domain/year_month.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../transactions/presentation/widgets/month_item_tile.dart';
import '../../domain/monthly_summary.dart';

/// Grupo de itens do mês com título e total. Some se não houver itens.
class MonthItemsSection extends StatelessWidget {
  const MonthItemsSection({
    required this.title,
    required this.items,
    required this.month,
    super.key,
  });

  final String title;
  final List<MonthItem> items;
  final YearMonth month;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final total = items
        .where((i) => i.countsInTotals)
        .fold(0, (sum, i) => sum + i.amountCents);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title,
          trailing: Text(
            formatCents(total),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              for (final item in items) MonthItemTile(item: item, month: month),
            ],
          ),
        ),
      ],
    );
  }
}
