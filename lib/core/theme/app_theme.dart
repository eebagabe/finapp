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

/// Temas claro e escuro do app: Material 3, azul como cor de destaque.
abstract final class AppTheme {
  static const Color _seedBlue = Color(0xFF1E63E9);

  static const double radius = 20;
  static const double spacing = 16;

  /// Degradê azul usado nos destaques (saldo, cartões).
  static LinearGradient brandGradient(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: dark
          ? const [Color(0xFF2A5BD7), Color(0xFF1A3A8F)]
          : const [Color(0xFF2F74FF), Color(0xFF1449C9)],
    );
  }

  static ThemeData light() => _build(
    brightness: Brightness.light,
    primary: _seedBlue,
    background: const Color(0xFFF1F5FC),
    surface: Colors.white,
    softSurface: const Color(0xFFEAF0FC),
    border: const Color(0xFFDCE5F5),
    text: const Color(0xFF14213D),
    colors: const AppColors(
      deficit: Color(0xFFD14343),
      deficitContainer: Color(0xFFFDECEC),
      positive: Color(0xFF1F9D63),
      mutedText: Color(0xFF66728A),
    ),
  );

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    primary: const Color(0xFF6E9BFF),
    background: const Color(0xFF0B1220),
    surface: const Color(0xFF141D30),
    softSurface: const Color(0xFF1B2640),
    border: const Color(0xFF243250),
    text: const Color(0xFFE6ECF7),
    colors: const AppColors(
      deficit: Color(0xFFFF8A8A),
      deficitContainer: Color(0xFF3A1D24),
      positive: Color(0xFF4ED69A),
      mutedText: Color(0xFF8E9AB3),
    ),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color background,
    required Color surface,
    required Color softSurface,
    required Color border,
    required Color text,
    required AppColors colors,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedBlue,
      brightness: brightness,
      primary: primary,
      surface: surface,
      outlineVariant: border,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
    );

    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    final fieldRadius = BorderRadius.circular(14);

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: text,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: roundedShape.copyWith(side: BorderSide(color: border)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softSurface,
        border: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: fieldRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primary.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: fieldRadius),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: primary,
          selectedForegroundColor: colorScheme.onPrimary,
          side: BorderSide(color: border),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: border),
        selectedColor: primary.withValues(alpha: 0.16),
        showCheckmark: false,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        indicatorColor: primary,
        dividerColor: border,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: border, space: 1),
      extensions: [colors],
    );
  }
}
