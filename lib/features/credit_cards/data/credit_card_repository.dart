import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/credit_card.dart';

class CreditCardRepository {
  CreditCardRepository(this._db);

  final AppDatabase _db;

  Stream<List<CreditCard>> watchAll() {
    final query = _db.select(_db.creditCards)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<CreditCard>> getAll() async {
    final rows = await _db.select(_db.creditCards).get();
    return rows.map(_toDomain).toList();
  }

  Stream<CreditCard?> watchById(int id) {
    final query = _db.select(_db.creditCards)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toDomain(row),
    );
  }

  Future<int> create(CreditCardInput input) =>
      _db.into(_db.creditCards).insert(_toCompanion(input));

  Future<void> update(int id, CreditCardInput input) async {
    await (_db.update(
      _db.creditCards,
    )..where((t) => t.id.equals(id))).write(_toCompanion(input));
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.creditCards)..where((t) => t.id.equals(id))).go();
  }

  CreditCardsCompanion _toCompanion(CreditCardInput input) =>
      CreditCardsCompanion(
        name: Value(input.name.trim()),
        closingDay: Value(input.closingDay),
        dueDay: Value(input.dueDay),
        limitCents: Value(input.limitCents),
      );

  static CreditCard _toDomain(CreditCardRow row) => CreditCard(
    id: row.id,
    name: row.name,
    closingDay: row.closingDay,
    dueDay: row.dueDay,
    limitCents: row.limitCents,
  );
}

final creditCardRepositoryProvider = Provider<CreditCardRepository>(
  (ref) => CreditCardRepository(ref.watch(databaseProvider)),
);

final creditCardsProvider = StreamProvider<List<CreditCard>>(
  (ref) => ref.watch(creditCardRepositoryProvider).watchAll(),
);

final creditCardProvider = StreamProvider.family<CreditCard?, int>(
  (ref, id) => ref.watch(creditCardRepositoryProvider).watchById(id),
);
