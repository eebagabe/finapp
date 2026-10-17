import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/recurring_item_tile.dart';
import '../../credit_cards/data/credit_card_repository.dart';
import '../data/fixed_expense_repository.dart';

/// Lista de despesas fixas.
class FixedExpensesList extends ConsumerWidget {
  const FixedExpensesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(creditCardsProvider).value ?? const [];
    final cardNames = {for (final card in cards) card.id: card.name};

    return ref
        .watch(fixedExpensesProvider)
        .when(
          data: (expenses) => expenses.isEmpty
              ? const EmptyState(
                  icon: Icons.event_repeat_outlined,
                  message: 'Nenhuma despesa fixa.\nEx.: energia, faculdade, internet.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: expenses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final cardName = cardNames[expense.creditCardId];
                    return RecurringItemTile(
                      title: expense.description,
                      subtitle: cardName == null
                          ? 'Todo dia ${expense.dueDay}'
                          : 'Todo dia ${expense.dueDay} · no cartão $cardName',
                      amountCents: expense.defaultAmountCents,
                      active: expense.active,
                      onTap: () =>
                          context.push(AppRoutes.editFixedExpense(expense.id)),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(error),
        );
  }
}
