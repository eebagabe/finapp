import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/credit_cards/domain/card_limit.dart';
import 'package:finapp/features/credit_cards/domain/card_purchase.dart';
import 'package:finapp/features/credit_cards/domain/credit_card.dart';
import 'package:finapp/features/fixed_expenses/domain/fixed_expense.dart';
import 'package:finapp/features/transactions/domain/entry_types.dart';
import 'package:finapp/features/transactions/domain/monthly_record.dart';
import 'package:flutter_test/flutter_test.dart';

const card = CreditCard(
  id: 1,
  name: 'Nubank',
  closingDay: 1,
  dueDay: 8,
  limitCents: 500000,
);

/// Compra de R$ 300 em 3x: faturas de nov, dez e jan.
final purchase = CardPurchase(
  id: 1,
  cardId: 1,
  description: 'Celular',
  totalCents: 30000,
  purchaseDate: DateTime(2026, 10, 10),
  installmentCount: 3,
  installments: [
    for (var i = 0; i < 3; i++)
      CardPurchaseInstallment(
        id: i,
        purchaseId: 1,
        number: i + 1,
        invoiceMonth: const YearMonth(2026, 11).addMonths(i),
        amountCents: 10000,
      ),
  ],
);

/// Streaming de R$ 40 todo dia 10 no cartão, desde outubro.
const streaming = FixedExpense(
  id: 1,
  description: 'Streaming',
  defaultAmountCents: 4000,
  dueDay: 10,
  active: true,
  startMonth: YearMonth(2026, 10),
  creditCardId: 1,
);

void main() {
  int used({List<MonthlyRecord> records = const [], DateTime? today}) =>
      usedLimitCents(
        card: card,
        purchases: [purchase],
        fixedExpenses: [streaming],
        records: MonthlyRecordIndex(records),
        today: today ?? DateTime(2026, 10, 16),
      );

  test('parcelas futuras comprometem o limite; despesas fixas só cobradas', () {
    // 3 parcelas + streaming de 10/10 (cobrança de 10/11 ainda não aconteceu).
    expect(used(), 30000 + 4000);
  });

  test('fatura paga devolve o limite', () {
    final paidNov = MonthlyRecord(
      source: RecordSource.cardInvoice,
      sourceId: 1,
      month: const YearMonth(2026, 11),
      paidAt: DateTime(2026, 11, 8),
    );
    // Fatura de nov: parcela 1 + streaming de outubro.
    expect(used(records: [paidNov]), 20000);
  });

  test('valor total informado substitui a soma da fatura', () {
    const informed = MonthlyRecord(
      source: RecordSource.cardInvoice,
      sourceId: 1,
      month: YearMonth(2026, 11),
      amountOverrideCents: 50000,
    );
    expect(used(records: [informed]), 50000 + 20000);
  });
}
