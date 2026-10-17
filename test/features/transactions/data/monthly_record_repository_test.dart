import 'package:drift/native.dart';
import 'package:finapp/core/database/app_database.dart';
import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/transactions/data/monthly_record_repository.dart';
import 'package:finapp/features/transactions/domain/entry_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late MonthlyRecordRepository repository;
  const month = YearMonth(2026, 11);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = MonthlyRecordRepository(db);
  });
  tearDown(() => db.close());

  Future<List<dynamic>> rows() => db.select(db.monthlyRecords).get();

  test('ajuste e pagamento ficam no mesmo registro', () async {
    await repository.setAmountOverride(
      RecordSource.fixedExpense,
      1,
      month,
      16200,
    );
    await repository.setPaid(
      RecordSource.fixedExpense,
      1,
      month,
      DateTime(2026, 11, 8),
    );

    final records = await repository.getBetween(month, month);
    expect(records, hasLength(1));
    expect(records.single.amountOverrideCents, 16200);
    expect(records.single.paidAt, DateTime(2026, 11, 8));
  });

  test('desfazer pagamento mantém o ajuste', () async {
    await repository.setAmountOverride(RecordSource.income, 1, month, 310000);
    await repository.setPaid(RecordSource.income, 1, month, DateTime.now());
    await repository.setPaid(RecordSource.income, 1, month, null);

    final record = (await repository.getBetween(month, month)).single;
    expect(record.amountOverrideCents, 310000);
    expect(record.paidAt, isNull);
  });

  test('registro sem ajuste e sem pagamento é removido', () async {
    await repository.setPaid(
      RecordSource.cardInvoice,
      1,
      month,
      DateTime.now(),
    );
    await repository.setPaid(RecordSource.cardInvoice, 1, month, null);

    expect(await rows(), isEmpty);
  });

  test('getBetween filtra pelo intervalo de meses', () async {
    await repository.setPaid(
      RecordSource.income,
      1,
      const YearMonth(2026, 9),
      DateTime.now(),
    );
    await repository.setPaid(RecordSource.income, 1, month, DateTime.now());

    final records = await repository.getBetween(
      const YearMonth(2026, 10),
      const YearMonth(2026, 12),
    );
    expect(records.map((r) => r.month), [month]);
  });
}
