import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/money_formatter.dart';

/// Exibe um valor em centavos como `R$ 1.234,56`.
///
/// Com [highlightNegative], valores negativos usam o vermelho discreto.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.cents, {
    this.style,
    this.highlightNegative = false,
    this.color,
    super.key,
  });

  final int cents;
  final TextStyle? style;
  final bool highlightNegative;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = highlightNegative && cents < 0
        ? context.appColors.deficit
        : color;
    return Text(
      formatCents(cents),
      style: (style ?? const TextStyle()).copyWith(
        color: resolvedColor,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
