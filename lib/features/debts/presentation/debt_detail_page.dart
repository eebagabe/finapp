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

/// Detalhe da dívida com a lista de parcelas e marcação de pagamento.
class DebtDetailPage extends ConsumerWidget {
  const DebtDetailPage({required this.debtId, super.key});

  final int debtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(debtProvider(debtId))
        .when(
          data: (debt) => debt == null
              ? const Scaffold(
                  body: EmptyState(
                    icon: Icons.search_off,
                    message: 'Dívida não encontrada.',
                  ),
                )
              : _DebtDetail(debt: debt),
          loading: () => const Scaffold(body: LoadingView()),
          error: (error, _) => Scaffold(body: ErrorView(error)),
        );
  }
}

class _DebtDetail extends ConsumerWidget {
  const _DebtDetail({required this.debt});

  final Debt debt;

  Future<void> _togglePaid(WidgetRef ref, DebtInstallment installment) {
    return ref
        .read(debtRepositoryProvider)
        .setInstallmentPaid(
          installment.id,
          installment.isPaid ? null : DateTime.now(),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    final payoff = debt.payoffDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(debt.description),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editDebt(debt.id)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacing),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Restante', style: TextStyle(color: muted)),
                MoneyText(
                  debt.remainingCents,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${debt.paidCount} de ${debt.installments.length} pagas'
                  '${payoff == null ? '' : ' · quita em ${formatDate(payoff)}'}',
                  style: textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          const SectionHeader('Parcelas'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final installment in debt.installments)
                  CheckboxListTile(
                    value: installment.isPaid,
                    onChanged: (_) => _togglePaid(ref, installment),
                    title: Text(
                      '${installment.number}ª · ${formatDate(installment.dueDate)}',
                    ),
                    subtitle: installment.isPaid
                        ? Text('Paga em ${formatDate(installment.paidAt!)}')
                        : null,
                    secondary: Text(
                      formatCents(installment.amountCents),
                      style: textTheme.bodyLarge,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
