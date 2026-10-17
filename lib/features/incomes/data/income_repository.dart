import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/income.dart';

class IncomeRepository {
  IncomeRepository(this._db);

  final AppDatabase _db;

  Stream<List<Income>> watchAll() {
    final query = _db.select(_db.incomes)
      ..orderBy([
        (t) => OrderingTerm.desc(t.active),
        (t) => OrderingTerm.asc(t.dayOfMonth),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<Income>> getAll() async {
    final rows = await _db.select(_db.incomes).get();
    return rows.map(_toDomain).toList();
  }

  Stream<Income?> watchById(int id) {
    final query = _db.select(_db.incomes)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toDomain(row),
    );
  }

  /// Cria a receita valendo a partir de [IncomeInput.startMonth] ou, sem ele,
  /// do mês atual.
  Future<int> create(IncomeInput input) => _db
      .into(_db.incomes)
      .insert(
        _toCompanion(input).copyWith(
          startMonth: Value((input.startMonth ?? YearMonth.now()).key),
        ),
      );

  Future<void> update(int id, IncomeInput input) async {
    await (_db.update(
      _db.incomes,
    )..where((t) => t.id.equals(id))).write(_toCompanion(input));
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.incomes)..where((t) => t.id.equals(id))).go();
  }

  IncomesCompanion _toCompanion(IncomeInput input) => IncomesCompanion(
    description: Value(input.description.trim()),
    amountCents: Value(input.amountCents),
    dayOfMonth: Value(input.dayOfMonth),
    active: Value(input.active),
    categoryId: Value(input.categoryId),
    startMonth: input.startMonth == null
        ? const Value.absent()
        : Value(input.startMonth!.key),
  );

  static Income _toDomain(IncomeRow row) => Income(
    id: row.id,
    description: row.description,
    amountCents: row.amountCents,
    dayOfMonth: row.dayOfMonth,
    active: row.active,
    startMonth: YearMonth.fromKey(row.startMonth),
    categoryId: row.categoryId,
  );
}

final incomeRepositoryProvider = Provider<IncomeRepository>(
  (ref) => IncomeRepository(ref.watch(databaseProvider)),
);

final incomesProvider = StreamProvider<List<Income>>(
  (ref) => ref.watch(incomeRepositoryProvider).watchAll(),
);

final incomeProvider = StreamProvider.family<Income?, int>(
  (ref, id) => ref.watch(incomeRepositoryProvider).watchById(id),
);
