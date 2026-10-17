import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:finapp/core/database/app_database.dart';
import 'package:finapp/features/debts/domain/debt_schedule.dart';
import 'package:finapp/features/transactions/domain/entry_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('apagar dívida remove as parcelas em cascata', () async {
    final debtId = await db
        .into(db.debts)
        .insert(
          DebtsCompanion.insert(
            description: 'Acordo',
            valueMode: DebtValueMode.installment,
          ),
        );
    await db
        .into(db.debtInstallments)
        .insert(
          DebtInstallmentsCompanion.insert(
            debtId: debtId,
            number: 1,
            dueDate: DateTime(2026, 11, 21),
            amountCents: 10000,
          ),
        );

    await (db.delete(db.debts)..where((t) => t.id.equals(debtId))).go();

    expect(await db.select(db.debtInstallments).get(), isEmpty);
  });

  test('apagar cartão desvincula despesas fixas', () async {
    final cardId = await db
        .into(db.creditCards)
        .insert(
          CreditCardsCompanion.insert(name: 'Nubank', closingDay: 1, dueDay: 8),
        );
    await db
        .into(db.fixedExpenses)
        .insert(
          FixedExpensesCompanion.insert(
            description: 'Streaming',
            defaultAmountCents: 3990,
            dueDay: 10,
            startMonth: 202610,
            creditCardId: Value(cardId),
          ),
        );

    await (db.delete(db.creditCards)..where((t) => t.id.equals(cardId))).go();

    final expense = await db.select(db.fixedExpenses).getSingle();
    expect(expense.creditCardId, isNull);
  });

  test('registro mensal é único por origem e mês', () async {
    MonthlyRecordsCompanion record() => MonthlyRecordsCompanion.insert(
      sourceType: RecordSource.fixedExpense,
      sourceId: 1,
      month: 202611,
    );
    await db.into(db.monthlyRecords).insert(record());
    expect(
      () => db.into(db.monthlyRecords).insert(record()),
      throwsA(isA<SqliteException>()),
    );
  });
}
