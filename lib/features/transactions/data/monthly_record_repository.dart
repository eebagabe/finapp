import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/entry_types.dart';
import '../domain/monthly_record.dart';

class MonthlyRecordRepository {
  MonthlyRecordRepository(this._db);

  final AppDatabase _db;

  /// Registros entre [from] e [to] (inclusive).
  Future<List<MonthlyRecord>> getBetween(YearMonth from, YearMonth to) async {
    final rows = await (_db.select(
      _db.monthlyRecords,
    )..where((t) => t.month.isBetweenValues(from.key, to.key))).get();
    return rows.map(_toDomain).toList();
  }

  /// Define (ou remove, com `null`) o valor real do item no mês.
  Future<void> setAmountOverride(
    RecordSource source,
    int sourceId,
    YearMonth month,
    int? amountCents,
  ) => _upsert(
    source,
    sourceId,
    month,
    MonthlyRecordsCompanion(amountOverrideCents: Value(amountCents)),
  );

  /// Marca como pago/recebido em [paidAt] ou, com `null`, desfaz.
  Future<void> setPaid(
    RecordSource source,
    int sourceId,
    YearMonth month,
    DateTime? paidAt,
  ) => _upsert(
    source,
    sourceId,
    month,
    MonthlyRecordsCompanion(paidAt: Value(paidAt)),
  );

  Future<void> _upsert(
    RecordSource source,
    int sourceId,
    YearMonth month,
    MonthlyRecordsCompanion changes,
  ) {
    return _db.transaction(() async {
      final filter = _db.select(_db.monthlyRecords)
        ..where(
          (t) =>
              t.sourceType.equalsValue(source) &
              t.sourceId.equals(sourceId) &
              t.month.equals(month.key),
        );
      final existing = await filter.getSingleOrNull();
      if (existing == null) {
        await _db
            .into(_db.monthlyRecords)
            .insert(
              changes.copyWith(
                sourceType: Value(source),
                sourceId: Value(sourceId),
                month: Value(month.key),
              ),
            );
        return;
      }
      await (_db.update(
        _db.monthlyRecords,
      )..where((t) => t.id.equals(existing.id))).write(changes);
      await _deleteIfEmpty(existing.id);
    });
  }

  /// Remove registros sem ajuste e sem pagamento.
  Future<void> _deleteIfEmpty(int id) async {
    await (_db.delete(_db.monthlyRecords)..where(
          (t) =>
              t.id.equals(id) &
              t.amountOverrideCents.isNull() &
              t.paidAt.isNull(),
        ))
        .go();
  }

  static MonthlyRecord _toDomain(MonthlyRecordRow row) => MonthlyRecord(
    source: row.sourceType,
    sourceId: row.sourceId,
    month: YearMonth.fromKey(row.month),
    amountOverrideCents: row.amountOverrideCents,
    paidAt: row.paidAt,
  );
}

final monthlyRecordRepositoryProvider = Provider<MonthlyRecordRepository>(
  (ref) => MonthlyRecordRepository(ref.watch(databaseProvider)),
);
