import 'package:flutter/material.dart';

/// Cores semânticas do app que não existem no [ColorScheme] do Material.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.deficit,
    required this.deficitContainer,
    required this.positive,
    required this.mutedText,
  });

  /// Vermelho discreto usado apenas para destacar saldo negativo/déficit.
  final Color deficit;
  final Color deficitContainer;

  /// Verde discreto para itens pagos/recebidos.
  final Color positive;

  /// Texto secundário (legendas, datas).
  final Color mutedText;

  @override
  AppColors copyWith({
    Color? deficit,
    Color? deficitContainer,
    Color? positive,
    Color? mutedText,
  }) {
    return AppColors(
      deficit: deficit ?? this.deficit,
      deficitContainer: deficitContainer ?? this.deficitContainer,
      positive: positive ?? this.positive,
      mutedText: mutedText ?? this.mutedText,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      deficit: Color.lerp(deficit, other.deficit, t)!,
      deficitContainer: Color.lerp(
        deficitContainer,
        other.deficitContainer,
        t,
      )!,
      positive: Color.lerp(positive, other.positive, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

/// Tema único do app: Material 3, azul sobre fundo branco.
abstract final class AppTheme {
  static const Color _seedBlue = Color(0xFF1E63E9);
  static const Color _background = Color(0xFFFFFFFF);
  static const Color _softSurface = Color(0xFFF5F8FF);

  static const double radius = 16;
  static const double spacing = 16;

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedBlue,
      primary: _seedBlue,
      surface: _background,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
    );

    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF1B1F2A),
        displayColor: const Color(0xFF1B1F2A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: _background,
        surfaceTintColor: Colors.transparent,
        elevation: 1.5,
        shadowColor: _seedBlue.withValues(alpha: 0.12),
        shape: roundedShape,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 3,
        shadowColor: _seedBlue.withValues(alpha: 0.15),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _softSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius / 1.5),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius / 1.5),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius / 1.5),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: roundedShape,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE8ECF4), space: 1),
      extensions: const [
        AppColors(
          deficit: Color(0xFFC94A4A),
          deficitContainer: Color(0xFFFDF1F1),
          positive: Color(0xFF2E8B57),
          mutedText: Color(0xFF6B7385),
        ),
      ],
    );
  }
}
