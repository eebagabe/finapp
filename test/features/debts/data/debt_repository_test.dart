import 'package:drift/native.dart';
import 'package:finapp/core/database/app_database.dart';
import 'package:finapp/features/debts/data/debt_repository.dart';
import 'package:finapp/features/debts/domain/debt.dart';
import 'package:finapp/features/debts/domain/debt_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DebtRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DebtRepository(db);
  });
  tearDown(() => db.close());

  DebtDraft draft({
    DebtValueMode mode = DebtValueMode.installment,
    int amount = 25000,
    int remaining = 9,
    DateTime? next,
  }) => DebtDraft(
    description: 'Acordo com Carrefour',
    valueMode: mode,
    amountCents: amount,
    nextPaymentDate: next ?? DateTime(2026, 11, 21),
    remainingCount: remaining,
  );

  test('gera uma parcela por mês ao criar', () async {
    final id = await repository.create(draft());
    final debt = (await repository.getById(id))!;

    expect(debt.installments, hasLength(9));
    expect(debt.installments.first.dueDate, DateTime(2026, 11, 21));
    expect(debt.payoffDate, DateTime(2027, 7, 21));
    expect(debt.remainingCents, 9 * 25000);
  });

  test('modo total guarda o total e divide as parcelas', () async {
    final id = await repository.create(
      draft(mode: DebtValueMode.total, amount: 100000, remaining: 3),
    );
    final debt = (await repository.getById(id))!;

    expect(debt.totalCents, 100000);
    expect(debt.installments.map((i) => i.amountCents), [33333, 33333, 33334]);
  });

  test('pagar uma parcela reduz as parcelas restantes', () async {
    final id = await repository.create(draft(remaining: 3));
    final first = (await repository.getById(id))!.installments.first;

    await repository.setInstallmentPaid(first.id, DateTime(2026, 11, 20));
    expect((await repository.getById(id))!.remainingCount, 2);

    await repository.setInstallmentPaid(first.id, null);
    expect((await repository.getById(id))!.remainingCount, 3);
  });

  test('editar regera apenas as parcelas não pagas', () async {
    final id = await repository.create(draft(remaining: 3));
    final first = (await repository.getById(id))!.installments.first;
    await repository.setInstallmentPaid(first.id, DateTime(2026, 11, 20));

    await repository.update(
      id,
      draft(amount: 30000, remaining: 4, next: DateTime(2026, 12, 21)),
    );
    final debt = (await repository.getById(id))!;

    expect(debt.installments, hasLength(5));
    expect(debt.installments.first.isPaid, isTrue);
    expect(debt.installments.first.amountCents, 25000);
    expect(debt.installments.map((i) => i.number), [1, 2, 3, 4, 5]);
    expect(debt.pendingInstallments.map((i) => i.amountCents), [
      30000,
      30000,
      30000,
      30000,
    ]);
    expect(debt.payoffDate, DateTime(2027, 3, 21));
  });

  test('watchAll emite novamente ao pagar uma parcela', () async {
    final id = await repository.create(draft(remaining: 2));
    final installment = (await repository.getById(id))!.installments.first;

    final emissions = repository.watchAll().map(
      (debts) => debts.single.remainingCount,
    );
    final expectation = expectLater(emissions, emitsInOrder([2, 1]));
    await Future<void>.delayed(Duration.zero);
    await repository.setInstallmentPaid(installment.id, DateTime.now());
    await expectation;
  });
}
