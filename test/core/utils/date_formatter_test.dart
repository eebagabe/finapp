import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/core/utils/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initializeDateFormats);

  test('formatDate usa dd/MM/yyyy', () {
    expect(formatDate(DateTime(2026, 11, 21)), '21/11/2026');
    expect(formatDayMonth(DateTime(2026, 1, 5)), '05/01');
  });

  test('formatMonthYear em português com inicial maiúscula', () {
    expect(formatMonthYear(const YearMonth(2026, 11)), 'Novembro de 2026');
    expect(formatMonthYear(const YearMonth(2027, 3)), 'Março de 2027');
  });

  test('formatShortMonthYear', () {
    expect(formatShortMonthYear(const YearMonth(2026, 11)), 'nov/26');
  });
}
