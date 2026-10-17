import 'package:intl/intl.dart';

final NumberFormat _currency = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 2,
);

/// Formata centavos como moeda brasileira: `R$ 1.234,56`.
///
/// Valores negativos ficam como `-R$ 1.234,56`.
String formatCents(int cents) {
  // O intl usa espaço não separável (U+00A0); normalizamos para espaço comum.
  return _currency.format(cents / 100).replaceAll(' ', ' ');
}

/// Converte um texto digitado (com ou sem `R$`, pontos e vírgula) em centavos.
///
/// Considera apenas os dígitos: `"R$ 1.234,56"` → `123456`.
/// Retorna `null` se não houver dígitos.
int? parseCents(String text) {
  final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return int.parse(digits);
}
