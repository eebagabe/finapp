import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/money_text.dart';
import '../data/credit_card_repository.dart';
import '../domain/credit_card.dart';

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

class _CreditCardTile extends StatelessWidget {
  const _CreditCardTile({required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    return AppCard(
      onTap: () => context.push(AppRoutes.cardDetail(card.id)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.credit_card,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card.name, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  'Melhor dia ${card.closingDay} · vence dia ${card.dueDay}',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          if (card.limitCents != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Limite',
                  style: textTheme.labelSmall?.copyWith(color: muted),
                ),
                MoneyText(card.limitCents!, style: textTheme.bodyMedium),
              ],
            ),
        ],
      ),
    );
  }
}
