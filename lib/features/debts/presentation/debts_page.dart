import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/money_text.dart';
import '../data/debt_repository.dart';
import '../domain/debt.dart';

class DebtsPage extends ConsumerWidget {
  const DebtsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dívidas')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova dívida',
        onPressed: () => context.push(AppRoutes.newDebt),
        child: const Icon(Icons.add),
      ),
      body: ref
          .watch(debtsProvider)
          .when(
            data: (debts) => debts.isEmpty
                ? const EmptyState(
                    icon: Icons.account_balance_outlined,
                    message: 'Nenhuma dívida cadastrada.',
                  )
                : _DebtList(debts: debts),
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(error),
          ),
    );
  }
}

class _DebtList extends StatelessWidget {
  const _DebtList({required this.debts});

  final List<Debt> debts;

  @override
  Widget build(BuildContext context) {
    final open = debts.where((d) => !d.isSettled).toList();
    final settled = debts.where((d) => d.isSettled).toList();
    final totalRemaining = open.fold(0, (sum, d) => sum + d.remainingCents);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        _TotalRemainingCard(cents: totalRemaining),
        for (final debt in open) ...[
          const SizedBox(height: 12),
          _DebtTile(debt: debt),
        ],
        if (settled.isNotEmpty) ...[
          const SectionHeader('Quitadas'),
          for (final debt in settled) ...[
            _DebtTile(debt: debt),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _TotalRemainingCard extends StatelessWidget {
  const _TotalRemainingCard({required this.cents});

  final int cents;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total restante em dívidas',
            style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 4),
          MoneyText(
            cents,
            color: scheme.onPrimary,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({required this.debt});

  final Debt debt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    final total = debt.installments.length;
    final payoff = debt.payoffDate;

    return AppCard(
      onTap: () => context.push(AppRoutes.debtDetail(debt.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(debt.description, style: textTheme.titleMedium),
              ),
              Text(
                '${formatCents(debt.installmentAmountCents)}/mês',
                style: textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : debt.paidCount / total,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${debt.paidCount} de $total pagas · '
                  '${debt.remainingCount} restantes',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
              ),
              if (payoff != null)
                Text(
                  'Quita em ${formatDate(payoff)}',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Restante: ${formatCents(debt.remainingCents)}',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
