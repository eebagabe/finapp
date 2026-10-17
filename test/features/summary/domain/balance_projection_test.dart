import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/summary/domain/balance_projection.dart';
import 'package:finapp/features/summary/domain/monthly_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const month = YearMonth(2026, 10);

  MonthItem item(MonthItemType type, int cents, {DateTime? paidAt}) =>
      MonthItem(
        type: type,
        sourceId: 1,
        title: 'x',
        amountCents: cents,
        date: month.dateAt(10),
        paidAt: paidAt,
      );

  test('considera só os pendentes, somando ao saldo em conta', () {
    final summary = MonthlySummary(
      month: month,
      items: [
        item(MonthItemType.income, 300000, paidAt: month.dateAt(5)),
        item(MonthItemType.oneOffIncome, 20000),
        item(MonthItemType.fixedExpense, 50000, paidAt: month.dateAt(6)),
        item(MonthItemType.debtInstallment, 120000),
      ],
    );

    final projection = projectBalance(
      bankBalanceCents: 10000,
      months: [summary],
    );

    expect(projection.projectedCents, 10000 + 20000 - 120000);
    expect(projection.shortfallCents, 90000);
  });

  test('sobra não gera falta', () {
    final projection = projectBalance(bankBalanceCents: 5000, months: const []);
    expect(projection.projectedCents, 5000);
    expect(projection.shortfallCents, 0);
  });
}
