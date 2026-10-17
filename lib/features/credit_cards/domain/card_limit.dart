import '../../../core/domain/year_month.dart';
import '../../fixed_expenses/domain/fixed_expense.dart';
import '../../transactions/domain/monthly_record.dart';
import 'card_purchase.dart';
import 'credit_card.dart';
import 'invoice.dart';

/// Quanto do limite de [card] está em uso em [today].
///
/// Soma as faturas ainda não pagas: todas as parcelas de compras (inclusive
/// as de faturas futuras, que já comprometem o limite) e as cobranças de
/// despesas fixas que já aconteceram. Fatura com valor total informado usa
/// esse valor. Ao marcar uma fatura como paga, o valor dela volta ao limite.
int usedLimitCents({
  required CreditCard card,
  required Iterable<CardPurchase> purchases,
  required Iterable<FixedExpense> fixedExpenses,
  required MonthlyRecordIndex records,
  required DateTime today,
}) {
  final cardPurchases = purchases.where((p) => p.cardId == card.id).toList();
  final cardExpenses = fixedExpenses
      .where((e) => e.creditCardId == card.id)
      .toList();

  final months = <YearMonth>{
    for (final purchase in cardPurchases)
      for (final installment in purchase.installments) installment.invoiceMonth,
  };
  final currentMonth = YearMonth.fromDate(today);
  for (final expense in cardExpenses) {
    for (
      var month = expense.startMonth;
      !month.isAfter(currentMonth);
      month = month.next
    ) {
      if (!expense.appliesTo(month)) continue;
      final chargeDate = expense.dueDateIn(month);
      if (chargeDate.isAfter(today)) continue;
      months.add(card.invoiceMonthFor(chargeDate));
    }
  }

  var used = 0;
  for (final month in months) {
    final invoice = buildInvoice(
      card: card,
      month: month,
      purchases: cardPurchases,
      fixedExpenses: cardExpenses,
      records: records,
    );
    if (invoice.isPaid) continue;
    used +=
        invoice.overrideCents ??
        invoice.lines
            .where(
              (l) =>
                  l.kind == InvoiceLineKind.purchase || !l.date.isAfter(today),
            )
            .fold(0, (sum, l) => sum + l.amountCents);
  }
  return used;
}
