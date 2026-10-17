import 'package:drift/drift.dart' show Table, TableInfo;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/watch_query.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../../fixed_expenses/data/fixed_expense_repository.dart';
import '../../transactions/data/monthly_record_repository.dart';
import '../../transactions/domain/monthly_record.dart';
import '../domain/card_limit.dart';
import '../domain/invoice.dart';
import 'card_purchase_repository.dart';
import 'credit_card_repository.dart';

/// Monta faturas a partir das compras, despesas fixas vinculadas e registros
/// mensais.
class InvoiceRepository {
  InvoiceRepository(this._db)
    : _cards = CreditCardRepository(_db),
      _purchases = CardPurchaseRepository(_db),
      _fixedExpenses = FixedExpenseRepository(_db),
      _records = MonthlyRecordRepository(_db);

  final AppDatabase _db;
  final CreditCardRepository _cards;
  final CardPurchaseRepository _purchases;
  final FixedExpenseRepository _fixedExpenses;
  final MonthlyRecordRepository _records;

  /// Faturas de todos os cartões com vencimento em [month].
  Future<List<Invoice>> getInvoicesDueIn(YearMonth month) async {
    final cards = await _cards.getAll();
    final purchases = await _purchases.getAll();
    final fixedExpenses = await _fixedExpenses.getAll();
    // Despesas fixas cobradas até dois meses antes podem cair nesta fatura.
    final records = MonthlyRecordIndex(
      await _records.getBetween(month.addMonths(-2), month),
    );
    return [
      for (final card in cards)
        buildInvoice(
          card: card,
          month: month,
          purchases: purchases,
          fixedExpenses: fixedExpenses,
          records: records,
        ),
    ];
  }

  /// Limite em uso de cada cartão (id → centavos). Ver [usedLimitCents].
  Future<Map<int, int>> getUsedLimits() async {
    final cards = await _cards.getAll();
    final purchases = await _purchases.getAll();
    final fixedExpenses = await _fixedExpenses.getAll();
    final records = MonthlyRecordIndex(await _records.getAll());
    final today = DateTime.now();
    return {
      for (final card in cards)
        card.id: usedLimitCents(
          card: card,
          purchases: purchases,
          fixedExpenses: fixedExpenses,
          records: records,
          today: today,
        ),
    };
  }

  Stream<Map<int, int>> watchUsedLimits() =>
      _db.watchComputed(_watchedTables, getUsedLimits);

  Stream<List<Invoice>> watchInvoicesDueIn(YearMonth month) =>
      _db.watchComputed(_watchedTables, () => getInvoicesDueIn(month));

  Stream<Invoice?> watchInvoice(int cardId, YearMonth month) =>
      watchInvoicesDueIn(month).map((invoices) {
        for (final invoice in invoices) {
          if (invoice.card.id == cardId) return invoice;
        }
        return null;
      });

  List<TableInfo<Table, dynamic>> get _watchedTables => [
    _db.creditCards,
    _db.cardPurchases,
    _db.cardPurchaseInstallments,
    _db.fixedExpenses,
    _db.monthlyRecords,
  ];
}

final invoiceRepositoryProvider = Provider<InvoiceRepository>(
  (ref) => InvoiceRepository(ref.watch(databaseProvider)),
);

final usedLimitsProvider = StreamProvider<Map<int, int>>(
  (ref) => ref.watch(invoiceRepositoryProvider).watchUsedLimits(),
);

final invoiceProvider = StreamProvider.family<Invoice?, (int, YearMonth)>(
  (ref, args) =>
      ref.watch(invoiceRepositoryProvider).watchInvoice(args.$1, args.$2),
);
