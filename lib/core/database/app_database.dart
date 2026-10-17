import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/debts/domain/debt_schedule.dart';
import '../../features/transactions/domain/entry_types.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CreditCards,
    Incomes,
    FixedExpenses,
    Debts,
    DebtInstallments,
    CardPurchases,
    CardPurchaseInstallments,
    OneOffEntries,
    MonthlyRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'finapp'));

  /// Versão do schema. Ao alterar tabelas:
  /// 1. incremente este número;
  /// 2. rode `dart run drift_dev make-migrations`;
  /// 3. adicione o passo correspondente em [migration].
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Passos de migração versionados entram aqui (from 1 to 2, ...).
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
