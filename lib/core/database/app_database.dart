import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/debts/domain/debt_schedule.dart';
import '../../features/transactions/domain/entry_types.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    AppSettings,
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
  int get schemaVersion => 2;

  /// Categorias criadas na instalação e ao zerar o sistema.
  static const defaultCategories = [
    'Moradia',
    'Alimentação',
    'Transporte',
    'Saúde',
    'Educação',
    'Lazer',
    'Assinaturas',
    'Salário',
    'Outros',
  ];

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedCategories();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(categories);
        await m.createTable(appSettings);
        await m.addColumn(incomes, incomes.categoryId);
        await m.addColumn(fixedExpenses, fixedExpenses.categoryId);
        await m.addColumn(oneOffEntries, oneOffEntries.categoryId);
        await m.addColumn(cardPurchases, cardPurchases.categoryId);
        await m.addColumn(cardPurchases, cardPurchases.firstInvoiceMonth);
        await m.addColumn(debtInstallments, debtInstallments.discountCents);
        await m.addColumn(debtInstallments, debtInstallments.originalDueDate);
        await _seedCategories();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedCategories() => batch(
    (b) => b.insertAll(categories, [
      for (final name in defaultCategories)
        CategoriesCompanion.insert(name: name),
    ]),
  );

  /// Apaga todos os dados cadastrados e recria as categorias padrão.
  /// Preferências ([appSettings]) são mantidas.
  Future<void> resetAllData() => transaction(() async {
    for (final table in allTables) {
      if (table == appSettings) continue;
      await delete(table).go();
    }
    await _seedCategories();
  });
}
