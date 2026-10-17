import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/presentation/categories_page.dart';
import '../../features/credit_cards/presentation/card_purchase_form_page.dart';
import '../../features/credit_cards/presentation/credit_card_detail_page.dart';
import '../../features/credit_cards/presentation/credit_card_form_page.dart';
import '../../features/credit_cards/presentation/credit_cards_page.dart';
import '../../features/debts/presentation/debt_detail_page.dart';
import '../../features/debts/presentation/debt_form_page.dart';
import '../../features/debts/presentation/debt_prepay_page.dart';
import '../../features/debts/presentation/debts_page.dart';
import '../../features/fixed_expenses/presentation/fixed_expense_form_page.dart';
import '../../features/incomes/presentation/income_form_page.dart';
import '../../features/settings/presentation/recurring_pages.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/summary/presentation/summary_page.dart';
import '../../features/transactions/presentation/one_off_entry_form_page.dart';
import '../../features/transactions/presentation/transactions_page.dart';
import '../widgets/app_shell.dart';

abstract final class AppRoutes {
  static const summary = '/resumo';
  static const transactions = '/lancamentos';
  static const debts = '/dividas';
  static const cards = '/cartoes';
  static const settings = '/configuracoes';

  static const newOneOffEntry = '$transactions/novo';

  static const newDebt = '$debts/nova';
  static String debtDetail(int id) => '$debts/$id';
  static String editDebt(int id) => '$debts/$id/editar';
  static String prepayDebt(int id) => '$debts/$id/antecipar';

  static const newCard = '$cards/novo';
  static String cardDetail(int id) => '$cards/$id';
  static String editCard(int id) => '$cards/$id/editar';
  static String newCardPurchase(int id) => '$cards/$id/lancamento';

  static const incomes = '$settings/receitas';
  static const newIncome = '$incomes/nova';
  static String editIncome(int id) => '$incomes/$id';

  static const fixedExpenses = '$settings/despesas';
  static const newFixedExpense = '$fixedExpenses/nova';
  static String editFixedExpense(int id) => '$fixedExpenses/$id';

  static const categories = '$settings/categorias';
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
                routes: [
                  GoRoute(
                    path: 'novo',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const OneOffEntryFormPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.debts,
                builder: (context, state) => const DebtsPage(),
                routes: [
                  GoRoute(
                    path: 'nova',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const DebtFormPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        DebtDetailPage(debtId: _id(state)),
                    routes: [
                      GoRoute(
                        path: 'editar',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            DebtFormPage(debtId: _id(state)),
                      ),
                      GoRoute(
                        path: 'antecipar',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            DebtPrepayPage(debtId: _id(state)),
                      ),
                    ],
                  ),
                ],
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
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) =>
                        CreditCardDetailPage(cardId: _id(state)),
                    routes: [
                      GoRoute(
                        path: 'editar',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            CreditCardFormPage(cardId: _id(state)),
                      ),
                      GoRoute(
                        path: 'lancamento',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            CardPurchaseFormPage(cardId: _id(state)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'despesas',
                    builder: (context, state) => const FixedExpensesPage(),
                    routes: [
                      GoRoute(
                        path: 'nova',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            const FixedExpenseFormPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            FixedExpenseFormPage(expenseId: _id(state)),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'receitas',
                    builder: (context, state) => const IncomesPage(),
                    routes: [
                      GoRoute(
                        path: 'nova',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => const IncomeFormPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) =>
                            IncomeFormPage(incomeId: _id(state)),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'categorias',
                    builder: (context, state) => const CategoriesPage(),
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
