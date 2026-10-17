import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../fixed_expenses/presentation/fixed_expenses_list.dart';
import '../../incomes/presentation/incomes_list.dart';

/// Despesas fixas cadastradas.
class FixedExpensesPage extends StatelessWidget {
  const FixedExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despesas fixas')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova despesa fixa',
        onPressed: () => context.push(AppRoutes.newFixedExpense),
        child: const Icon(Icons.add),
      ),
      body: const FixedExpensesList(),
    );
  }
}

/// Receitas fixas cadastradas.
class IncomesPage extends StatelessWidget {
  const IncomesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas fixas')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova receita fixa',
        onPressed: () => context.push(AppRoutes.newIncome),
        child: const Icon(Icons.add),
      ),
      body: const IncomesList(),
    );
  }
}
