import 'package:finapp/features/debts/domain/debt_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DebtSchedule.lastInstallmentDate', () {
    test('21/11/2026 + 9 parcelas termina em 21/07/2027', () {
      expect(
        DebtSchedule.lastInstallmentDate(DateTime(2026, 11, 21), 9),
        DateTime(2027, 7, 21),
      );
    });

    test('uma parcela termina no próprio próximo pagamento', () {
      expect(
        DebtSchedule.lastInstallmentDate(DateTime(2026, 11, 21), 1),
        DateTime(2026, 11, 21),
      );
    });

    test('dia 31 cai no último dia de mês curto', () {
      expect(
        DebtSchedule.lastInstallmentDate(DateTime(2026, 12, 31), 3),
        DateTime(2027, 2, 28),
      );
    });

    test('rejeita menos de uma parcela', () {
      expect(
        () => DebtSchedule.lastInstallmentDate(DateTime(2026, 11, 21), 0),
        throwsArgumentError,
      );
    });
  });

  group('DebtSchedule.remainingInstallments', () {
    test('21/11/2026 até 21/05/2027 são 7 parcelas', () {
      expect(
        DebtSchedule.remainingInstallments(
          DateTime(2026, 11, 21),
          DateTime(2027, 5, 21),
        ),
        7,
      );
    });

    test('mesmo mês é uma parcela', () {
      expect(
        DebtSchedule.remainingInstallments(
          DateTime(2026, 11, 21),
          DateTime(2026, 11, 30),
        ),
        1,
      );
    });

    test('última antes do próximo pagamento retorna null', () {
      expect(
        DebtSchedule.remainingInstallments(
          DateTime(2026, 11, 21),
          DateTime(2026, 10, 21),
        ),
        isNull,
      );
    });

    test('ida e volta são consistentes', () {
      final next = DateTime(2027, 1, 31);
      for (var remaining = 1; remaining <= 36; remaining++) {
        final last = DebtSchedule.lastInstallmentDate(next, remaining);
        expect(DebtSchedule.remainingInstallments(next, last), remaining);
      }
    });
  });

  group('planDebtInstallments', () {
    test('modo valor da parcela repete o valor em cada mês', () {
      final plan = planDebtInstallments(
        mode: DebtValueMode.installment,
        amountCents: 25000,
        count: 3,
        firstDueDate: DateTime(2026, 11, 21),
      );
      expect(plan, [
        PlannedInstallment(
          number: 1,
          dueDate: DateTime(2026, 11, 21),
          amountCents: 25000,
        ),
        PlannedInstallment(
          number: 2,
          dueDate: DateTime(2026, 12, 21),
          amountCents: 25000,
        ),
        PlannedInstallment(
          number: 3,
          dueDate: DateTime(2027, 1, 21),
          amountCents: 25000,
        ),
      ]);
    });

    test('modo total divide e coloca a sobra na última parcela', () {
      final plan = planDebtInstallments(
        mode: DebtValueMode.total,
        amountCents: 100000,
        count: 3,
        firstDueDate: DateTime(2026, 11, 21),
      );
      expect(plan.map((p) => p.amountCents), [33333, 33333, 33334]);
      expect(plan.map((p) => p.amountCents).reduce((a, b) => a + b), 100000);
    });

    test('dia 31 respeita meses curtos', () {
      final plan = planDebtInstallments(
        mode: DebtValueMode.installment,
        amountCents: 1000,
        count: 3,
        firstDueDate: DateTime(2027, 1, 31),
      );
      expect(plan.map((p) => p.dueDate), [
        DateTime(2027, 1, 31),
        DateTime(2027, 2, 28),
        DateTime(2027, 3, 31),
      ]);
    });

    test('numeração pode começar de outro número', () {
      final plan = planDebtInstallments(
        mode: DebtValueMode.installment,
        amountCents: 1000,
        count: 2,
        firstDueDate: DateTime(2026, 11, 21),
        firstNumber: 4,
      );
      expect(plan.map((p) => p.number), [4, 5]);
    });
  });
}
