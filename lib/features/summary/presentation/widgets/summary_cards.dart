import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/money_text.dart';
import '../../domain/monthly_summary.dart';

/// Saldo do mês e, se negativo, quanto falta conseguir.
class BalanceCard extends StatelessWidget {
  const BalanceCard({required this.summary, super.key});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final inDeficit = summary.shortfallCents > 0;

    return AppCard(
      color: inDeficit ? colors.deficitContainer : null,
      gradient: inDeficit ? null : AppTheme.brandGradient(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (inDeficit) ...[
            Text(
              'Falta conseguir',
              style: textTheme.titleSmall?.copyWith(color: colors.deficit),
            ),
            const SizedBox(height: 4),
            MoneyText(
              summary.shortfallCents,
              color: colors.deficit,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'para não fechar o mês no vermelho',
              style: textTheme.bodySmall?.copyWith(color: colors.deficit),
            ),
          ] else ...[
            Text(
              'Saldo do mês',
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 4),
            MoneyText(
              summary.balanceCents,
              color: Colors.white,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'você fecha o mês no azul',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Total de receitas e de despesas lado a lado.
class TotalsRow extends StatelessWidget {
  const TotalsRow({required this.summary, super.key});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TotalTile(
            label: 'Receitas',
            cents: summary.incomeCents,
            icon: Icons.arrow_downward,
            color: context.appColors.positive,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TotalTile(
            label: 'Despesas',
            cents: summary.expenseCents,
            icon: Icons.arrow_upward,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.cents,
    required this.icon,
    required this.color,
  });

  final String label;
  final int cents;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: context.appColors.mutedText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: MoneyText(
              cents,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quanto das despesas já foi pago e quanto ainda falta pagar.
class PaymentProgressCard extends StatelessWidget {
  const PaymentProgressCard({required this.summary, super.key});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    final total = summary.expenseCents;
    final progress = total == 0 ? 0.0 : summary.paidExpenseCents / total;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledValue(
                  label: 'Já pago',
                  cents: summary.paidExpenseCents,
                ),
              ),
              Expanded(
                child: _LabeledValue(
                  label: 'Falta pagar',
                  cents: summary.pendingExpenseCents,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: progress, minHeight: 6),
          ),
          if (summary.pendingIncomeCents > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: muted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'A receber: ${formatCents(summary.pendingIncomeCents)}',
                    style: textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({
    required this.label,
    required this.cents,
    this.alignEnd = false,
  });

  final String label;
  final int cents;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: context.appColors.mutedText,
          ),
        ),
        MoneyText(
          cents,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
