import 'package:finapp/core/domain/year_month.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('daysInMonth', () {
    test('considera ano bissexto', () {
      expect(daysInMonth(2028, 2), 29);
      expect(daysInMonth(2027, 2), 28);
      expect(daysInMonth(2026, 4), 30);
      expect(daysInMonth(2026, 12), 31);
    });
  });

  group('addMonths', () {
    test('mantém o dia quando existe no mês de destino', () {
      expect(addMonths(DateTime(2026, 11, 21), 8), DateTime(2027, 7, 21));
    });

    test('usa o último dia quando o mês é curto', () {
      expect(addMonths(DateTime(2027, 1, 31), 1), DateTime(2027, 2, 28));
      expect(addMonths(DateTime(2028, 1, 31), 1), DateTime(2028, 2, 29));
      expect(addMonths(DateTime(2026, 8, 31), 1), DateTime(2026, 9, 30));
    });

    test('série a partir da data original volta ao dia 31', () {
      final start = DateTime(2027, 1, 31);
      expect(
        [for (var i = 0; i < 3; i++) addMonths(start, i)],
        [DateTime(2027, 1, 31), DateTime(2027, 2, 28), DateTime(2027, 3, 31)],
      );
    });

    test('atravessa a virada do ano nos dois sentidos', () {
      expect(addMonths(DateTime(2026, 12, 10), 1), DateTime(2027, 1, 10));
      expect(addMonths(DateTime(2027, 1, 10), -1), DateTime(2026, 12, 10));
    });

    test('descarta o horário', () {
      expect(addMonths(DateTime(2026, 5, 3, 14, 30), 1), DateTime(2026, 6, 3));
    });
  });

  group('YearMonth', () {
    test('key e fromKey são inversos', () {
      const month = YearMonth(2026, 11);
      expect(month.key, 202611);
      expect(YearMonth.fromKey(202611), month);
    });

    test('addMonths, next e previous atravessam o ano', () {
      const dec = YearMonth(2026, 12);
      expect(dec.next, const YearMonth(2027, 1));
      expect(const YearMonth(2027, 1).previous, dec);
      expect(dec.addMonths(14), const YearMonth(2028, 2));
      expect(dec.addMonths(-12), const YearMonth(2025, 12));
    });

    test('monthsUntil', () {
      expect(
        const YearMonth(2026, 11).monthsUntil(const YearMonth(2027, 7)),
        8,
      );
      expect(
        const YearMonth(2027, 7).monthsUntil(const YearMonth(2026, 11)),
        -8,
      );
    });

    test('dateAt limita ao último dia do mês', () {
      expect(const YearMonth(2027, 2).dateAt(31), DateTime(2027, 2, 28));
      expect(const YearMonth(2026, 10).dateAt(8), DateTime(2026, 10, 8));
    });

    test('comparação e igualdade', () {
      expect(
        const YearMonth(2026, 1).isBefore(const YearMonth(2026, 2)),
        isTrue,
      );
      expect(
        const YearMonth(2027, 1).isAfter(const YearMonth(2026, 12)),
        isTrue,
      );
      expect(const YearMonth(2026, 3), const YearMonth(2026, 3));
      expect(const YearMonth(2026, 3).contains(DateTime(2026, 3, 31)), isTrue);
    });
  });

  group('nextMonthlyDate', () {
    const oct = YearMonth(2026, 10);

    test('dia já passou no mês atual → mês seguinte', () {
      expect(
        nextMonthlyDate(start: oct, day: 7, from: DateTime(2026, 10, 16)),
        DateTime(2026, 11, 7),
      );
    });

    test('dia ainda vai chegar no mês atual (inclusive hoje)', () {
      expect(
        nextMonthlyDate(start: oct, day: 16, from: DateTime(2026, 10, 16, 15)),
        DateTime(2026, 10, 16),
      );
    });

    test('início no futuro → primeira ocorrência no início', () {
      expect(
        nextMonthlyDate(
          start: const YearMonth(2027, 2),
          day: 31,
          from: DateTime(2026, 10, 16),
        ),
        DateTime(2027, 2, 28),
      );
    });
  });
}
