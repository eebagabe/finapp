import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Estrutura com a barra de navegação inferior compartilhada pelas abas.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _Destination(
      Icons.space_dashboard_outlined,
      Icons.space_dashboard,
      'Resumo',
    ),
    _Destination(
      Icons.receipt_long_outlined,
      Icons.receipt_long,
      'Lançamentos',
    ),
    _Destination(
      Icons.account_balance_outlined,
      Icons.account_balance,
      'Dívidas',
    ),
    _Destination(Icons.credit_card_outlined, Icons.credit_card, 'Cartões'),
    _Destination(Icons.tune_outlined, Icons.tune, 'Cadastros'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomBar(
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Barra inferior compacta: rótulos pequenos em uma linha, que encolhem em
/// telas estreitas em vez de quebrar.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      // Limita a escala de fonte do sistema para a barra não estourar.
      child: SafeArea(
        top: false,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.2,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                for (final (index, destination)
                    in AppShell._destinations.indexed)
                  Expanded(
                    child: _BottomBarItem(
                      destination: destination,
                      selected: index == selectedIndex,
                      onTap: () => onSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : context.appColors.mutedText;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? scheme.primary.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: 22,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  destination.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 0,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
