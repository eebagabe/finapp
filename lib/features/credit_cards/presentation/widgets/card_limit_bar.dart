import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/money_text.dart';

/// Limite disponível do cartão com barra de uso.
class CardLimitBar extends StatelessWidget {
  const CardLimitBar({
    required this.limitCents,
    required this.usedCents,
    super.key,
  });

  final int limitCents;
  final int usedCents;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final available = limitCents - usedCents;
    final usage = limitCents == 0 ? 1.0 : usedCents / limitCents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Limite disponível',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.mutedText,
                    ),
                  ),
                  MoneyText(
                    available,
                    highlightNegative: true,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'de ${formatCents(limitCents)}',
              style: textTheme.bodySmall?.copyWith(color: colors.mutedText),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: usage.clamp(0, 1).toDouble(),
            minHeight: 6,
            color: usage > 0.9 ? colors.deficit : null,
          ),
        ),
      ],
    );
  }
}
