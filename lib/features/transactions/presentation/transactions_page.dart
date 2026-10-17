import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/selected_month_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/month_selector.dart';
import '../../summary/data/monthly_summary_repository.dart';
import '../domain/transaction_filter.dart';
import 'widgets/month_item_tile.dart';

/// Filtro atual da tela de lançamentos.
class TransactionFilterNotifier extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() => const TransactionFilter();

  void setType(TypeFilter type) => state = state.copyWith(type: type);

  void setStatus(StatusFilter status) => state = state.copyWith(status: status);
}

final transactionFilterProvider =
    NotifierProvider<TransactionFilterNotifier, TransactionFilter>(
      TransactionFilterNotifier.new,
    );

/// Tudo do mês selecionado, com filtro por tipo e por status.
class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final filter = ref.watch(transactionFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lançamentos')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo lançamento',
        onPressed: () => context.push(AppRoutes.newOneOffEntry),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        children: [
          const MonthSelector(),
          const _FilterBar(),
          const SizedBox(height: 12),
          ref
              .watch(monthlySummaryProvider(month))
              .when(
                data: (summary) {
                  final items = filter.apply(summary.items);
                  if (items.isEmpty) {
                    return const EmptyState(
                      icon: Icons.filter_list_off,
                      message: 'Nenhum lançamento para este filtro.',
                    );
                  }
                  return AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        for (final item in items)
                          MonthItemTile(item: item, month: month),
                      ],
                    ),
                  );
                },
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

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(transactionFilterProvider);
    final notifier = ref.read(transactionFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final type in TypeFilter.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type.label),
                    selected: filter.type == type,
                    onSelected: (_) => notifier.setType(type),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<StatusFilter>(
          segments: [
            for (final status in StatusFilter.values)
              ButtonSegment(value: status, label: Text(status.label)),
          ],
          selected: {filter.status},
          showSelectedIcon: false,
          onSelectionChanged: (selection) =>
              notifier.setStatus(selection.single),
        ),
      ],
    );
  }
}
