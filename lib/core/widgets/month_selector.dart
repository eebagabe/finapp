import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/year_month.dart';
import '../providers/selected_month_provider.dart';
import '../utils/date_formatter.dart';

/// Seletor de mês (anterior / próximo) ligado ao [selectedMonthProvider].
class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final notifier = ref.read(selectedMonthProvider.notifier);
    final isCurrent = month == YearMonth.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Mês anterior',
          icon: const Icon(Icons.chevron_left),
          onPressed: notifier.previous,
        ),
        GestureDetector(
          onTap: isCurrent ? null : () => notifier.select(YearMonth.now()),
          child: Column(
            children: [
              Text(
                formatMonthYear(month),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (!isCurrent)
                Text(
                  'toque para voltar ao mês atual',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Próximo mês',
          icon: const Icon(Icons.chevron_right),
          onPressed: notifier.next,
        ),
      ],
    );
  }
}
