import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/selected_month_provider.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/month_selector.dart';
import '../data/monthly_summary_repository.dart';
import '../domain/monthly_summary.dart';
import 'widgets/month_items_section.dart';
import 'widgets/projected_balance_card.dart';
import 'widgets/summary_cards.dart';

/// Tela inicial: resumo do mês selecionado.
class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          const MonthSelector(),
          const SizedBox(height: 8),
          ref
              .watch(monthlySummaryProvider(month))
              .when(
                data: (summary) => _SummaryContent(summary: summary),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: LoadingView(),
                ),
                error: (error, _) => ErrorView(error),
              ),
        ],
      ),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final month = summary.month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BalanceCard(summary: summary),
        ProjectedBalanceCard(month: month),
        const SizedBox(height: 12),
        TotalsRow(summary: summary),
        const SizedBox(height: 12),
        PaymentProgressCard(summary: summary),
        MonthItemsSection(
          title: 'Despesas fixas',
          items: summary.ofType(MonthItemType.fixedExpense),
          month: month,
        ),
        MonthItemsSection(
          title: 'Dívidas',
          items: summary.ofType(MonthItemType.debtInstallment),
          month: month,
        ),
        MonthItemsSection(
          title: 'Cartões',
          items: summary.ofType(MonthItemType.cardInvoice),
          month: month,
        ),
        MonthItemsSection(
          title: 'Avulsos',
          items: summary.ofType(MonthItemType.oneOffExpense),
          month: month,
        ),
        MonthItemsSection(
          title: 'Receitas',
          items: [
            ...summary.ofType(MonthItemType.income),
            ...summary.ofType(MonthItemType.oneOffIncome),
          ],
          month: month,
        ),
        if (summary.items.isEmpty)
          const EmptyState(
            icon: Icons.event_note_outlined,
            message:
                'Nada neste mês ainda.\nCadastre receitas, despesas fixas, '
                'dívidas e cartões.',
          ),
      ],
    );
  }
}
