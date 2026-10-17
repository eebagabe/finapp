import 'package:finapp/core/utils/money_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCents', () {
    test('formata no padrão R\$ 1.234,56', () {
      expect(formatCents(123456), r'R$ 1.234,56');
      expect(formatCents(150000), r'R$ 1.500,00');
      expect(formatCents(5), r'R$ 0,05');
      expect(formatCents(0), r'R$ 0,00');
    });

    test('formata valores negativos', () {
      expect(formatCents(-150000), r'-R$ 1.500,00');
    });
  });

  group('parseCents', () {
    test('considera apenas dígitos', () {
      expect(parseCents(r'R$ 1.234,56'), 123456);
      expect(parseCents('150'), 150);
    });

    test('retorna null sem dígitos', () {
      expect(parseCents(''), isNull);
      expect(parseCents(r'R$ '), isNull);
    });
  });
}
