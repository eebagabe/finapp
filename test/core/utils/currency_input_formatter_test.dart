import 'package:finapp/core/utils/currency_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = CurrencyInputFormatter();

  String type(String oldText, String newText) => formatter
      .formatEditUpdate(
        TextEditingValue(text: oldText),
        TextEditingValue(text: newText),
      )
      .text;

  test('preenche a partir dos centavos', () {
    expect(type('', '1'), r'R$ 0,01');
    expect(type(r'R$ 0,01', r'R$ 0,015'), r'R$ 0,15');
    expect(type(r'R$ 1,50', r'R$ 1,500'), r'R$ 15,00');
    expect(type(r'R$ 150,00', r'R$ 150,000'), r'R$ 1.500,00');
  });

  test('apagar remove o último dígito', () {
    expect(type(r'R$ 1.500,00', r'R$ 1.500,0'), r'R$ 150,00');
  });

  test('zero ou vazio limpa o campo', () {
    expect(type(r'R$ 0,01', r'R$ 0,0'), '');
    expect(type('', ''), '');
  });

  test('ignora entrada acima do limite', () {
    const small = CurrencyInputFormatter(maxCents: 999);
    final result = small.formatEditUpdate(
      const TextEditingValue(text: r'R$ 9,99'),
      const TextEditingValue(text: r'R$ 9,990'),
    );
    expect(result.text, r'R$ 9,99');
  });
}
