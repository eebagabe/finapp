import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/watch_query.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../../categories/data/category_repository.dart';
import '../../credit_cards/data/credit_card_repository.dart';
import '../../credit_cards/data/invoice_repository.dart';
import '../../debts/data/debt_repository.dart';
import '../../fixed_expenses/data/fixed_expense_repository.dart';
import '../../incomes/data/income_repository.dart';
import '../../transactions/data/monthly_record_repository.dart';
import '../../transactions/data/one_off_entry_repository.dart';
import '../../transactions/domain/monthly_record.dart';
import '../domain/monthly_summary.dart';

/// Carrega os dados do mês e monta o [MonthlySummary].
class MonthlySummaryRepository {
  MonthlySummaryRepository(this._db);

  final AppDatabase _db;

  Future<MonthlySummary> load(YearMonth month) async {
    return calculateMonthlySummary(
      month: month,
      incomes: await IncomeRepository(_db).getAll(),
      fixedExpenses: await FixedExpenseRepository(_db).getAll(),
      cards: await CreditCardRepository(_db).getAll(),
      debts: await DebtRepository(_db).getAll(),
      invoices: await InvoiceRepository(_db).getInvoicesDueIn(month),
      oneOffEntries: await OneOffEntryRepository(_db).getIn(month),
      records: MonthlyRecordIndex(
        await MonthlyRecordRepository(_db).getBetween(month, month),
      ),
      categories: await CategoryRepository(_db).getAll(),
    );
  }

  /// Recalcula sempre que qualquer tabela mudar.
  Stream<MonthlySummary> watch(YearMonth month) =>
      _db.watchComputed(_db.allTables, () => load(month));
}

final monthlySummaryRepositoryProvider = Provider<MonthlySummaryRepository>(
  (ref) => MonthlySummaryRepository(ref.watch(databaseProvider)),
);

final monthlySummaryProvider = StreamProvider.family<MonthlySummary, YearMonth>(
  (ref, month) => ref.watch(monthlySummaryRepositoryProvider).watch(month),
);
