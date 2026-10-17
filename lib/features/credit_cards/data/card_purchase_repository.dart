import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/watch_query.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/card_purchase.dart';
import '../domain/invoice_rules.dart';

class CardPurchaseRepository {
  CardPurchaseRepository(this._db);

  final AppDatabase _db;

  Stream<List<CardPurchase>> watchAll() => _db.watchComputed([
    _db.cardPurchases,
    _db.cardPurchaseInstallments,
  ], getAll);

  Future<List<CardPurchase>> getAll() async {
    final purchases = await (_db.select(
      _db.cardPurchases,
    )..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)])).get();
    final installments = await _db.select(_db.cardPurchaseInstallments).get();
    final byPurchase = <int, List<CardPurchaseInstallment>>{};
    for (final row in installments) {
      byPurchase
          .putIfAbsent(row.purchaseId, () => [])
          .add(_installmentToDomain(row));
    }
    return [
      for (final row in purchases)
        CardPurchase(
          id: row.id,
          cardId: row.cardId,
          description: row.description,
          totalCents: row.totalCents,
          purchaseDate: row.purchaseDate,
          installmentCount: row.installmentCount,
          installments: byPurchase[row.id] ?? const [],
        ),
    ];
  }

  /// Lança a compra e distribui as parcelas nas faturas pela regra de
  /// fechamento do cartão.
  Future<int> create(CardPurchaseDraft draft) {
    return _db.transaction(() async {
      final purchaseId = await _db
          .into(_db.cardPurchases)
          .insert(
            CardPurchasesCompanion.insert(
              cardId: draft.cardId,
              description: draft.description.trim(),
              totalCents: draft.totalCents,
              purchaseDate: draft.purchaseDate,
              installmentCount: draft.installmentCount,
            ),
          );
      await _distribute(
        purchaseId: purchaseId,
        cardId: draft.cardId,
        totalCents: draft.totalCents,
        installmentCount: draft.installmentCount,
        purchaseDate: draft.purchaseDate,
      );
      return purchaseId;
    });
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.cardPurchases)..where((t) => t.id.equals(id))).go();
  }

  /// Recalcula as faturas de todas as compras do cartão. Usado quando o
  /// melhor dia ou o vencimento do cartão mudam.
  Future<void> redistributeCard(int cardId) {
    return _db.transaction(() async {
      final purchases = await (_db.select(
        _db.cardPurchases,
      )..where((t) => t.cardId.equals(cardId))).get();
      for (final purchase in purchases) {
        await (_db.delete(
          _db.cardPurchaseInstallments,
        )..where((t) => t.purchaseId.equals(purchase.id))).go();
        await _distribute(
          purchaseId: purchase.id,
          cardId: cardId,
          totalCents: purchase.totalCents,
          installmentCount: purchase.installmentCount,
          purchaseDate: purchase.purchaseDate,
        );
      }
    });
  }

  Future<void> _distribute({
    required int purchaseId,
    required int cardId,
    required int totalCents,
    required int installmentCount,
    required DateTime purchaseDate,
  }) async {
    final card = await (_db.select(
      _db.creditCards,
    )..where((t) => t.id.equals(cardId))).getSingle();
    final parts = InvoiceRules.distributePurchase(
      totalCents: totalCents,
      installmentCount: installmentCount,
      purchaseDate: purchaseDate,
      closingDay: card.closingDay,
      dueDay: card.dueDay,
    );
    await _db.batch((batch) {
      batch.insertAll(_db.cardPurchaseInstallments, [
        for (final part in parts)
          CardPurchaseInstallmentsCompanion.insert(
            purchaseId: purchaseId,
            number: part.number,
            invoiceMonth: part.invoiceMonth.key,
            amountCents: part.amountCents,
          ),
      ]);
    });
  }

  static CardPurchaseInstallment _installmentToDomain(
    CardPurchaseInstallmentRow row,
  ) => CardPurchaseInstallment(
    id: row.id,
    purchaseId: row.purchaseId,
    number: row.number,
    invoiceMonth: YearMonth.fromKey(row.invoiceMonth),
    amountCents: row.amountCents,
  );
}

final cardPurchaseRepositoryProvider = Provider<CardPurchaseRepository>(
  (ref) => CardPurchaseRepository(ref.watch(databaseProvider)),
);
