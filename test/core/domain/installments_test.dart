import 'package:finapp/core/domain/installments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('splitInstallments', () {
    test('divisão exata gera parcelas iguais', () {
      expect(splitInstallments(90000, 3), [30000, 30000, 30000]);
    });

    test('centavos restantes vão para a última parcela', () {
      expect(splitInstallments(10000, 3), [3333, 3333, 3334]);
      expect(splitInstallments(10001, 3), [3333, 3333, 3335]);
    });

    test('soma das parcelas sempre bate com o total', () {
      for (final total in [1, 99, 10000, 123457, 999999]) {
        for (var count = 1; count <= 24; count++) {
          final parts = splitInstallments(total, count);
          expect(parts, hasLength(count));
          expect(parts.reduce((a, b) => a + b), total);
        }
      }
    });

    test('total menor que a quantidade de parcelas', () {
      expect(splitInstallments(2, 3), [0, 0, 2]);
    });

    test('parcela única recebe o total', () {
      expect(splitInstallments(15000, 1), [15000]);
    });

    test('rejeita quantidade inválida ou total negativo', () {
      expect(() => splitInstallments(100, 0), throwsArgumentError);
      expect(() => splitInstallments(-1, 2), throwsArgumentError);
    });
  });

  group('monthlyDates', () {
    test('uma data por mês', () {
      expect(monthlyDates(DateTime(2026, 11, 21), 3), [
        DateTime(2026, 11, 21),
        DateTime(2026, 12, 21),
        DateTime(2027, 1, 21),
      ]);
    });

    test('dia 31 usa o último dia em meses curtos', () {
      expect(monthlyDates(DateTime(2026, 12, 31), 4), [
        DateTime(2026, 12, 31),
        DateTime(2027, 1, 31),
        DateTime(2027, 2, 28),
        DateTime(2027, 3, 31),
      ]);
    });
  });
}
