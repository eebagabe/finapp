import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Estrutura com a bottom navigation bar compartilhada pelas abas.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Resumo',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Lançamentos',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_balance_outlined),
      selectedIcon: Icon(Icons.account_balance),
      label: 'Dívidas',
    ),
    NavigationDestination(
      icon: Icon(Icons.credit_card_outlined),
      selectedIcon: Icon(Icons.credit_card),
      label: 'Cartões',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: 'Cadastros',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: _destinations,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
