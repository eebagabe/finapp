import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../incomes/presentation/incomes_list.dart';

/// Cadastros de itens recorrentes: receitas fixas e despesas fixas.
class RegistrationsPage extends StatelessWidget {
  const RegistrationsPage({super.key});

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
