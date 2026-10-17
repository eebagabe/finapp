import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_card.dart';
import 'money_text.dart';

/// Linha de item recorrente (receita ou despesa fixa) nas telas de cadastro.
class RecurringItemTile extends StatelessWidget {
  const RecurringItemTile({
    required this.title,
    required this.subtitle,
    required this.amountCents,
    required this.active,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final int amountCents;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    return Opacity(
      opacity: active ? 1 : 0.5,
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    active ? subtitle : '$subtitle · inativa',
                    style: textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
            MoneyText(amountCents, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
