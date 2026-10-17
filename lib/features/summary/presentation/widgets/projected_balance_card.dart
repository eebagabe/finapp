import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/year_month.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/form_fields.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/monthly_summary_repository.dart';
import '../../domain/balance_projection.dart';

/// Saldo em conta e saldo previsto ao fim de [month].
///
/// Some em meses passados. Sem saldo informado, convida a informar.
class ProjectedBalanceCard extends ConsumerWidget {
  const ProjectedBalanceCard({required this.month, super.key});

  final YearMonth month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (month.isBefore(YearMonth.now())) return const SizedBox.shrink();
    final projection = ref.watch(balanceProjectionProvider(month));
    if (!projection.hasValue) return const SizedBox.shrink();

    final value = projection.value;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: value == null
          ? _EmptyBalanceCard(onTap: () => _editBalance(context, ref, null))
          : _ProjectionContent(
              projection: value,
              month: month,
              onEdit: () => _editBalance(context, ref, value.bankBalanceCents),
            ),
    );
  }

  Future<void> _editBalance(
    BuildContext context,
    WidgetRef ref,
    int? current,
  ) async {
    final cents = await showDialog<int>(
      context: context,
      builder: (_) => _BankBalanceDialog(initialCents: current),
    );
    if (cents == null) return;
    await ref.read(settingsRepositoryProvider).setBankBalance(cents);
  }
}

class _EmptyBalanceCard extends StatelessWidget {
  const _EmptyBalanceCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = context.appColors.mutedText;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.account_balance_outlined, color: muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Informe seu saldo em conta para ver o saldo previsto',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: muted),
            ),
          ),
          Icon(Icons.chevron_right, color: muted),
        ],
      ),
    );
  }
}

class _ProjectionContent extends StatelessWidget {
  const _ProjectionContent({
    required this.projection,
    required this.month,
    required this.onEdit,
  });

  final BalanceProjection projection;
  final YearMonth month;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.bodySmall?.copyWith(color: colors.mutedText);
    final valueStyle = textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return AppCard(
      onTap: onEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Saldo em conta', style: labelStyle),
                        const SizedBox(width: 4),
                        Icon(Icons.edit, size: 12, color: colors.mutedText),
                      ],
                    ),
                    MoneyText(
                      projection.bankBalanceCents,
                      highlightNegative: true,
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Saldo previsto', style: labelStyle),
                    MoneyText(
                      projection.projectedCents,
                      highlightNegative: true,
                      color: projection.projectedCents >= 0
                          ? colors.positive
                          : null,
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            projection.shortfallCents > 0
                ? 'Falta conseguir ${formatCents(projection.shortfallCents)} '
                      'até o fim de ${formatMonthYear(month)}, '
                      'já contando o saldo em conta'
                : 'Saldo em conta + a receber − a pagar até o fim de '
                      '${formatMonthYear(month)}',
            style: projection.shortfallCents > 0
                ? textTheme.bodySmall?.copyWith(color: colors.deficit)
                : labelStyle,
          ),
        ],
      ),
    );
  }
}

class _BankBalanceDialog extends StatefulWidget {
  const _BankBalanceDialog({required this.initialCents});

  final int? initialCents;

  @override
  State<_BankBalanceDialog> createState() => _BankBalanceDialogState();
}

class _BankBalanceDialogState extends State<_BankBalanceDialog> {
  late final TextEditingController _amount = TextEditingController(
    text: MoneyField.initialText(widget.initialCents?.abs()),
  );
  late bool _negative = (widget.initialCents ?? 0) < 0;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Saldo em conta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MoneyField(
            controller: _amount,
            label: 'Quanto você tem hoje',
            required: false,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Saldo negativo'),
            subtitle: const Text('Ex.: usando o cheque especial'),
            value: _negative,
            onChanged: (value) => setState(() => _negative = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: () {
            final cents = parseCents(_amount.text) ?? 0;
            Navigator.of(context).pop(_negative ? -cents : cents);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
