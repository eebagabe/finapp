import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/credit_cards/presentation/credit_card_form_page.dart';
import '../../features/credit_cards/presentation/credit_cards_page.dart';
import '../../features/debts/presentation/debts_page.dart';
import '../../features/fixed_expenses/presentation/fixed_expense_form_page.dart';
import '../../features/incomes/presentation/income_form_page.dart';
import '../../features/registrations/presentation/registrations_page.dart';
import '../../features/summary/presentation/summary_page.dart';
import '../../features/transactions/presentation/transactions_page.dart';
import '../widgets/app_shell.dart';

abstract final class AppRoutes {
  static const summary = '/resumo';
  static const transactions = '/lancamentos';
  static const debts = '/dividas';
  static const cards = '/cartoes';
  static const registrations = '/cadastros';

  static const newCard = '$cards/novo';
  static String editCard(int id) => '$cards/$id/editar';

  static const newIncome = '$registrations/receitas/nova';
  static String editIncome(int id) => '$registrations/receitas/$id';

  static const newFixedExpense = '$registrations/despesas/nova';
  static String editFixedExpense(int id) => '$registrations/despesas/$id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Id numérico de um parâmetro de rota.
int _id(GoRouterState state, [String name = 'id']) =>
    int.parse(state.pathParameters[name]!);

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.summary,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.summary,
                builder: (context, state) => const SummaryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.debts,
                builder: (context, state) => const DebtsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cards,
                builder: (context, state) => const CreditCardsPage(),
                routes: [
                  GoRoute(
                    path: 'novo',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CreditCardFormPage(),
                  ),
                  GoRoute(
                    path: ':id/editar',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        CreditCardFormPage(cardId: _id(state)),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.registrations,
                builder: (context, state) => const RegistrationsPage(),
                routes: [
                  GoRoute(
                    path: 'receitas/nova',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const IncomeFormPage(),
                  ),
                  GoRoute(
                    path: 'receitas/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        IncomeFormPage(incomeId: _id(state)),
                  ),
                  GoRoute(
                    path: 'despesas/nova',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const FixedExpenseFormPage(),
                  ),
                  GoRoute(
                    path: 'despesas/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        FixedExpenseFormPage(expenseId: _id(state)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
