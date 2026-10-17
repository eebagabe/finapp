import 'package:drift/native.dart';
import 'package:finapp/core/database/app_database.dart';
import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/credit_cards/data/card_purchase_repository.dart';
import 'package:finapp/features/credit_cards/data/credit_card_repository.dart';
import 'package:finapp/features/credit_cards/data/invoice_repository.dart';
import 'package:finapp/features/credit_cards/domain/card_purchase.dart';
import 'package:finapp/features/credit_cards/domain/credit_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CreditCardRepository cards;
  late CardPurchaseRepository purchases;
  late int cardId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    cards = CreditCardRepository(db);
    purchases = CardPurchaseRepository(db);
    cardId = await cards.create(
      const CreditCardInput(name: 'Nubank', closingDay: 1, dueDay: 8),
    );
  });
  tearDown(() => db.close());

  Future<void> buy(DateTime date, int cents, int count) => purchases.create(
    CardPurchaseDraft(
      cardId: cardId,
      description: 'Exame',
      totalCents: cents,
      purchaseDate: date,
      installmentCount: count,
    ),
  );

  test('distribui parcelas nas faturas pela regra de fechamento', () async {
    await buy(DateTime(2026, 10, 1), 30000, 3);

    final purchase = (await purchases.getAll()).single;
    expect(purchase.installments.map((i) => i.invoiceMonth), const [
      YearMonth(2026, 11),
      YearMonth(2026, 12),
      YearMonth(2027, 1),
    ]);
  });

  test('mudar o melhor dia do cartão redistribui as compras', () async {
    await buy(DateTime(2026, 10, 10), 10000, 1);
    expect(
      (await purchases.getAll()).single.installments.single.invoiceMonth,
      const YearMonth(2026, 11),
    );

    await cards.update(
      cardId,
      const CreditCardInput(name: 'Nubank', closingDay: 15, dueDay: 22),
    );
    expect(
      (await purchases.getAll()).single.installments.single.invoiceMonth,
      const YearMonth(2026, 10),
    );
  });

  test('fatura do mês soma as parcelas do cartão', () async {
    await buy(DateTime(2026, 10, 5), 30000, 3);
    await buy(DateTime(2026, 10, 20), 4590, 1);

    final invoices = await InvoiceRepository(db)
        .getInvoicesDueIn(const YearMonth(2026, 11));
    expect(invoices.single.totalCents, 10000 + 4590);
  });

  test('excluir a compra remove as parcelas', () async {
    await buy(DateTime(2026, 10, 5), 30000, 3);
    await purchases.delete((await purchases.getAll()).single.id);

    expect(await db.select(db.cardPurchaseInstallments).get(), isEmpty);
  });
}
