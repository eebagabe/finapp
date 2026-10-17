import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/fixed_expense.dart';

class FixedExpenseRepository {
  FixedExpenseRepository(this._db);

  final AppDatabase _db;

  Stream<List<FixedExpense>> watchAll() {
    final query = _db.select(_db.fixedExpenses)
      ..orderBy([
        (t) => OrderingTerm.desc(t.active),
        (t) => OrderingTerm.asc(t.dueDay),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<FixedExpense>> getAll() async {
    final rows = await _db.select(_db.fixedExpenses).get();
    return rows.map(_toDomain).toList();
  }

  Stream<FixedExpense?> watchById(int id) {
    final query = _db.select(_db.fixedExpenses)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toDomain(row),
    );
  }

  /// Cria a despesa valendo a partir do mês atual.
  Future<int> create(FixedExpenseInput input) => _db
      .into(_db.fixedExpenses)
      .insert(
        _toCompanion(input).copyWith(startMonth: Value(YearMonth.now().key)),
      );

  Future<void> update(int id, FixedExpenseInput input) async {
    await (_db.update(
      _db.fixedExpenses,
    )..where((t) => t.id.equals(id))).write(_toCompanion(input));
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.fixedExpenses)..where((t) => t.id.equals(id))).go();
  }

  FixedExpensesCompanion _toCompanion(FixedExpenseInput input) =>
      FixedExpensesCompanion(
        description: Value(input.description.trim()),
        defaultAmountCents: Value(input.defaultAmountCents),
        dueDay: Value(input.dueDay),
        active: Value(input.active),
        creditCardId: Value(input.creditCardId),
      );

  static FixedExpense _toDomain(FixedExpenseRow row) => FixedExpense(
    id: row.id,
    description: row.description,
    defaultAmountCents: row.defaultAmountCents,
    dueDay: row.dueDay,
    active: row.active,
    startMonth: YearMonth.fromKey(row.startMonth),
    creditCardId: row.creditCardId,
  );
}

final fixedExpenseRepositoryProvider = Provider<FixedExpenseRepository>(
  (ref) => FixedExpenseRepository(ref.watch(databaseProvider)),
);

final fixedExpensesProvider = StreamProvider<List<FixedExpense>>(
  (ref) => ref.watch(fixedExpenseRepositoryProvider).watchAll(),
);

final fixedExpenseProvider = StreamProvider.family<FixedExpense?, int>(
  (ref, id) => ref.watch(fixedExpenseRepositoryProvider).watchById(id),
);
