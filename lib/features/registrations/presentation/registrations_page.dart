import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../fixed_expenses/presentation/fixed_expenses_list.dart';
import '../../incomes/presentation/incomes_list.dart';

/// Cadastros de itens recorrentes: receitas fixas e despesas fixas.
class RegistrationsPage extends StatelessWidget {
  const RegistrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cadastros'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Despesas fixas'),
                  Tab(text: 'Receitas fixas'),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Adicionar',
              onPressed: () => context.push(
                tabController.index == 0
                    ? AppRoutes.newFixedExpense
                    : AppRoutes.newIncome,
              ),
              child: const Icon(Icons.add),
            ),
            body: const TabBarView(
              children: [FixedExpensesList(), IncomesList()],
            ),
          );
        },
      ),
    );
  }
}
