import 'package:flutter/services.dart';

import 'money_formatter.dart';

/// Máscara de moeda para campos de valor.
///
/// O usuário digita só números e eles preenchem a partir dos centavos:
/// `1` → `R$ 0,01`, `150` → `R$ 1,50`, `15000` → `R$ 150,00`.
class CurrencyInputFormatter extends TextInputFormatter {
  const CurrencyInputFormatter({this.maxCents = 99999999999});

  final int maxCents;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cents = parseCents(newValue.text);
    if (cents == null || cents == 0) {
      return const TextEditingValue();
    }
    if (cents > maxCents) return oldValue;

    final text = formatCents(cents);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
