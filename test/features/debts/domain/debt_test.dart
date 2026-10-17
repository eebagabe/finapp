import 'package:finapp/features/debts/domain/debt.dart';
import 'package:finapp/features/debts/domain/debt_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

DebtInstallment _installment(int number, int cents, {bool paid = false}) =>
    DebtInstallment(
      id: number,
      debtId: 1,
      number: number,
      dueDate: DateTime(2026, 10 + number, 21),
      amountCents: cents,
      paidAt: paid ? DateTime(2026, 10, 21) : null,
    );

void main() {
  final debt = Debt(
    id: 1,
    description: 'Acordo',
    valueMode: DebtValueMode.total,
    totalCents: 100000,
    installments: [
      _installment(3, 33334),
      _installment(1, 33333, paid: true),
      _installment(2, 33333),
    ],
  );

  test('ordena parcelas pelo número', () {
    expect(debt.installments.map((i) => i.number), [1, 2, 3]);
  });

  test('conta parcelas pagas e restantes', () {
    expect(debt.paidCount, 1);
    expect(debt.remainingCount, 2);
    expect(debt.isSettled, isFalse);
  });

  test('total restante soma apenas as parcelas pendentes', () {
    expect(debt.remainingCents, 66667);
    expect(debt.paidCents, 33333);
  });

  test('próxima parcela e valor de referência', () {
    expect(debt.nextInstallment?.number, 2);
    expect(debt.installmentAmountCents, 33333);
  });

  test('data de quitação é a data da última parcela', () {
    expect(debt.payoffDate, debt.installments.last.dueDate);
  });

  test('dívida com todas as parcelas pagas está quitada', () {
    final settled = Debt(
      id: 2,
      description: 'Quitada',
      valueMode: DebtValueMode.installment,
      installments: [_installment(1, 5000, paid: true)],
    );
    expect(settled.isSettled, isTrue);
    expect(settled.remainingCents, 0);
    expect(settled.nextInstallment, isNull);
    expect(settled.installmentAmountCents, 5000);
  });
}
