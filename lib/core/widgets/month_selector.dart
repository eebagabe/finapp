import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/year_month.dart';
import '../providers/selected_month_provider.dart';
import '../theme/app_theme.dart';
import '../utils/date_formatter.dart';

/// Seletor de mês (anterior / próximo) ligado ao [selectedMonthProvider].
class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final notifier = ref.read(selectedMonthProvider.notifier);
    final isCurrent = month == YearMonth.now();

    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Mês anterior',
            icon: Icon(Icons.chevron_left, color: scheme.primary),
            onPressed: notifier.previous,
          ),
          Expanded(
            child: GestureDetector(
              onTap: isCurrent ? null : () => notifier.select(YearMonth.now()),
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: scheme.primary),
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Próximo mês',
            icon: Icon(Icons.chevron_right, color: scheme.primary),
            onPressed: notifier.next,
          ),
        ],
      ),
    );
  }
}
