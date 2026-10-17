import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Card padrão do app: cantos arredondados, borda sutil e padding interno.
///
/// Com [gradient], o fundo é o degradê (sem borda).
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppTheme.spacing),
    this.color,
    this.gradient,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    );
    return Card(
      color: color,
      shape: gradient == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
      clipBehavior: Clip.antiAlias,
      child: gradient == null
          ? content
          : Ink(
              decoration: BoxDecoration(gradient: gradient),
              child: content,
            ),
    );
  }
}
