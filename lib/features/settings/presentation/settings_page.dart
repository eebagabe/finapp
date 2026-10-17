import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../categories/data/category_repository.dart';
import '../../fixed_expenses/data/fixed_expense_repository.dart';
import '../../incomes/data/income_repository.dart';
import '../data/settings_repository.dart';

/// Configurações: itens fixos, categorias, aparência e dados.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = (ref.watch(fixedExpensesProvider).value ?? const []).where(
      (e) => e.active,
    );
    final incomes = (ref.watch(incomesProvider).value ?? const []).where(
      (i) => i.active,
    );
    final categories = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          const SectionHeader('Cadastros fixos'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _NavTile(
                  icon: Icons.event_repeat,
                  title: 'Despesas fixas',
                  subtitle:
                      '${expenses.length} ativas · '
                      '${formatCents(expenses.fold(0, (s, e) => s + e.defaultAmountCents))}/mês',
                  onTap: () => context.push(AppRoutes.fixedExpenses),
                ),
                _NavTile(
                  icon: Icons.payments_outlined,
                  title: 'Receitas fixas',
                  subtitle:
                      '${incomes.length} ativas · '
                      '${formatCents(incomes.fold(0, (s, i) => s + i.amountCents))}/mês',
                  onTap: () => context.push(AppRoutes.incomes),
                ),
                _NavTile(
                  icon: Icons.label_outline,
                  title: 'Categorias',
                  subtitle: '${categories.length} categorias',
                  onTap: () => context.push(AppRoutes.categories),
                ),
              ],
            ),
          ),
          const SectionHeader('Aparência'),
          const AppCard(child: _ThemeSelector()),
          const SectionHeader('Dados'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: context.appColors.deficit,
              ),
              title: Text(
                'Zerar sistema',
                style: TextStyle(color: context.appColors.deficit),
              ),
              subtitle: const Text('Apaga todas as informações cadastradas'),
              onTap: () => _confirmReset(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _ResetDialog(),
    );
    if (confirmed != true) return;
    await ref.read(settingsRepositoryProvider).resetAllData();
    if (context.mounted) showMessage(context, 'Sistema zerado');
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: scheme.primary, size: 22),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Tema', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text('Sistema'),
              icon: Icon(Icons.brightness_auto_outlined),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text('Claro'),
              icon: Icon(Icons.light_mode_outlined),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text('Escuro'),
              icon: Icon(Icons.dark_mode_outlined),
            ),
          ],
          selected: {mode},
          showSelectedIcon: false,
          onSelectionChanged: (selection) => ref
              .read(settingsRepositoryProvider)
              .setThemeMode(selection.single),
        ),
      ],
    );
  }
}

/// Confirmação em duas etapas: é preciso digitar ZERAR.
class _ResetDialog extends StatefulWidget {
  const _ResetDialog();

  @override
  State<_ResetDialog> createState() => _ResetDialogState();
}

class _ResetDialogState extends State<_ResetDialog> {
  static const _word = 'ZERAR';
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = _text.text.trim().toUpperCase() == _word;
    return AlertDialog(
      title: const Text('Zerar sistema?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Receitas, despesas, dívidas, cartões, lançamentos e categorias '
            'serão apagados. Esta ação não pode ser desfeita.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _text,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Digite $_word para confirmar',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 40),
            backgroundColor: context.appColors.deficit,
          ),
          onPressed: ok ? () => Navigator.of(context).pop(true) : null,
          child: const Text('Zerar'),
        ),
      ],
    );
  }
}
