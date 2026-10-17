import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../data/credit_card_repository.dart';
import '../data/invoice_repository.dart';
import '../domain/credit_card.dart';
import 'widgets/card_limit_bar.dart';

class CreditCardsPage extends ConsumerWidget {
  const CreditCardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartões')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo cartão',
        onPressed: () => context.push(AppRoutes.newCard),
        child: const Icon(Icons.add),
      ),
      body: ref
          .watch(creditCardsProvider)
          .when(
            data: (cards) => cards.isEmpty
                ? const EmptyState(
                    icon: Icons.credit_card_outlined,
                    message: 'Nenhum cartão cadastrado.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: cards.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _CreditCardTile(card: cards[index]),
                  ),
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(error),
          ),
    );
  }
}

class _CreditCardTile extends ConsumerWidget {
  const _CreditCardTile({required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final used = ref.watch(usedLimitsProvider).value?[card.id];
    final limit = card.limitCents;

    return AppCard(
      onTap: () => context.push(AppRoutes.cardDetail(card.id)),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing),
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.name,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Melhor dia ${card.closingDay} · vence dia ${card.dueDay}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.contactless_outlined,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing),
            child: limit == null
                ? Text(
                    'Informe o limite no cartão para ver quanto está disponível',
                    style: textTheme.bodySmall?.copyWith(
                      color: context.appColors.mutedText,
                    ),
                  )
                : used == null
                ? LinearProgressIndicator(color: scheme.primary)
                : CardLimitBar(limitCents: limit, usedCents: used),
          ),
        ],
      ),
    );
  }
}
