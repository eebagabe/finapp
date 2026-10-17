import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/one_off_entry.dart';

class OneOffEntryRepository {
  OneOffEntryRepository(this._db);

  final AppDatabase _db;

  Future<List<OneOffEntry>> getIn(YearMonth month) async {
    final rows =
        await (_db.select(_db.oneOffEntries)..where(
              (t) => t.date.isBetweenValues(
                month.firstDay,
                month.next.firstDay.subtract(const Duration(microseconds: 1)),
              ),
            ))
            .get();
    return rows.map(_toDomain).toList();
  }

  Future<int> create(OneOffEntryDraft draft) => _db
      .into(_db.oneOffEntries)
      .insert(
        OneOffEntriesCompanion.insert(
          kind: draft.kind,
          description: draft.description.trim(),
          amountCents: draft.amountCents,
          date: draft.date,
          categoryId: Value(draft.categoryId),
        ),
      );

  Future<void> delete(int id) async {
    await (_db.delete(_db.oneOffEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Marca como pago/recebido em [paidAt] ou, com `null`, desfaz.
  Future<void> setPaid(int id, DateTime? paidAt) async {
    await (_db.update(_db.oneOffEntries)..where((t) => t.id.equals(id))).write(
      OneOffEntriesCompanion(paidAt: Value(paidAt)),
    );
  }

  static OneOffEntry _toDomain(OneOffEntryRow row) => OneOffEntry(
    id: row.id,
    kind: row.kind,
    description: row.description,
    amountCents: row.amountCents,
    date: row.date,
    paidAt: row.paidAt,
    categoryId: row.categoryId,
  );
}

final oneOffEntryRepositoryProvider = Provider<OneOffEntryRepository>(
  (ref) => OneOffEntryRepository(ref.watch(databaseProvider)),
);
