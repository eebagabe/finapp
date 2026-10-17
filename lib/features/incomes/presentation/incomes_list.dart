import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/recurring_item_tile.dart';
import '../data/income_repository.dart';

/// Lista de receitas fixas.
class IncomesList extends ConsumerWidget {
  const IncomesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(incomesProvider)
        .when(
          data: (incomes) => incomes.isEmpty
              ? const EmptyState(
                  icon: Icons.payments_outlined,
                  message: 'Nenhuma receita fixa.\nEx.: salário todo dia 5.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: incomes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final income = incomes[index];
                    return RecurringItemTile(
                      title: income.description,
                      subtitle:
                          'Próxima: ${formatDayMonthName(income.nextDate())} · '
                          'todo dia ${income.dayOfMonth}',
                      amountCents: income.amountCents,
                      active: income.active,
                      onTap: () =>
                          context.push(AppRoutes.editIncome(income.id)),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(error),
        );
  }
}
