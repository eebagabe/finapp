import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/credit_cards/domain/card_purchase.dart';
import 'package:finapp/features/credit_cards/domain/credit_card.dart';
import 'package:finapp/features/credit_cards/domain/invoice.dart';
import 'package:finapp/features/fixed_expenses/domain/fixed_expense.dart';
import 'package:finapp/features/transactions/domain/entry_types.dart';
import 'package:finapp/features/transactions/domain/monthly_record.dart';
import 'package:flutter_test/flutter_test.dart';

const nubank = CreditCard(id: 1, name: 'Nubank', closingDay: 1, dueDay: 8);
const nov = YearMonth(2026, 11);

CardPurchase purchase({
  required int id,
  int cardId = 1,
  required List<(YearMonth, int)> installments,
}) => CardPurchase(
  id: id,
  cardId: cardId,
  description: 'Compra $id',
  totalCents: installments.fold(0, (sum, i) => sum + i.$2),
  purchaseDate: DateTime(2026, 10, 10),
  installmentCount: installments.length,
  installments: [
    for (var i = 0; i < installments.length; i++)
      CardPurchaseInstallment(
        id: id * 100 + i,
        purchaseId: id,
        number: i + 1,
        invoiceMonth: installments[i].$1,
        amountCents: installments[i].$2,
      ),
  ],
);

FixedExpense expense({
  int id = 1,
  int? cardId = 1,
  int dueDay = 10,
  int amount = 3990,
  bool active = true,
  YearMonth start = const YearMonth(2026, 1),
}) => FixedExpense(
  id: id,
  description: 'Streaming',
  defaultAmountCents: amount,
  dueDay: dueDay,
  active: active,
  startMonth: start,
  creditCardId: cardId,
);

Invoice build({
  List<CardPurchase> purchases = const [],
  List<FixedExpense> fixedExpenses = const [],
  List<MonthlyRecord> records = const [],
  YearMonth month = nov,
}) => buildInvoice(
  card: nubank,
  month: month,
  purchases: purchases,
  fixedExpenses: fixedExpenses,
  records: MonthlyRecordIndex(records),
);

void main() {
  test('soma as parcelas que caem na fatura do mês', () {
    final invoice = build(
      purchases: [
        purchase(id: 1, installments: [(nov, 10000), (nov.next, 10000)]),
        purchase(id: 2, installments: [(nov, 4590)]),
        purchase(id: 3, installments: [(nov.next, 9999)]),
      ],
    );
    expect(invoice.lines, hasLength(2));
    expect(invoice.totalCents, 14590);
    expect(invoice.lines.first.installmentLabel, '1/2');
  });

  test('ignora compras de outros cartões', () {
    final invoice = build(
      purchases: [
        purchase(id: 1, cardId: 2, installments: [(nov, 10000)]),
      ],
    );
    expect(invoice.totalCents, 0);
    expect(invoice.isEmpty, isTrue);
  });

  test('despesa fixa vinculada entra na fatura pela regra de fechamento', () {
    // Cobrança em 10/10 (depois do melhor dia 1) → fatura de novembro.
    final invoice = build(fixedExpenses: [expense()]);
    expect(invoice.lines, hasLength(1));
    expect(invoice.lines.single.kind, InvoiceLineKind.fixedExpense);
    expect(invoice.lines.single.date, DateTime(2026, 10, 10));
    expect(invoice.totalCents, 3990);
  });

  test('despesa fixa usa o valor ajustado do mês da cobrança', () {
    final invoice = build(
      fixedExpenses: [expense()],
      records: [
        const MonthlyRecord(
          source: RecordSource.fixedExpense,
          sourceId: 1,
          month: YearMonth(2026, 10),
          amountOverrideCents: 4590,
        ),
      ],
    );
    expect(invoice.totalCents, 4590);
  });

  test('despesa fixa não vinculada, inativa ou futura não entra', () {
    final invoice = build(
      fixedExpenses: [
        expense(id: 1, cardId: null),
        expense(id: 2, active: false),
        expense(id: 3, start: nov),
      ],
    );
    expect(invoice.lines, isEmpty);
  });

  test('valor total informado substitui a soma dos lançamentos', () {
    final invoice = build(
      purchases: [
        purchase(id: 1, installments: [(nov, 10000)]),
      ],
      records: [
        const MonthlyRecord(
          source: RecordSource.cardInvoice,
          sourceId: 1,
          month: nov,
          amountOverrideCents: 85000,
          paidAt: null,
        ),
      ],
    );
    expect(invoice.hasOverride, isTrue);
    expect(invoice.computedCents, 10000);
    expect(invoice.totalCents, 85000);
  });

  test('vencimento no dia do cartão e status de pagamento', () {
    final invoice = build(
      records: [
        MonthlyRecord(
          source: RecordSource.cardInvoice,
          sourceId: 1,
          month: nov,
          paidAt: DateTime(2026, 11, 7),
        ),
      ],
    );
    expect(invoice.dueDate, DateTime(2026, 11, 8));
    expect(invoice.isPaid, isTrue);
  });
}
