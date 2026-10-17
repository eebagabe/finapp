import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/credit_cards/presentation/credit_cards_page.dart';
import '../../features/debts/presentation/debts_page.dart';
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
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
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
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.registrations,
                builder: (context, state) => const RegistrationsPage(),
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
