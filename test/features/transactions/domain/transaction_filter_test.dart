import 'package:finapp/features/summary/domain/monthly_summary.dart';
import 'package:finapp/features/transactions/domain/transaction_filter.dart';
import 'package:flutter_test/flutter_test.dart';

MonthItem item(
  MonthItemType type, {
  bool paid = false,
  String? cardName,
  String title = '',
}) => MonthItem(
  type: type,
  sourceId: 1,
  title: title,
  amountCents: 100,
  date: DateTime(2026, 11, 1),
  paidAt: paid ? DateTime(2026, 11, 2) : null,
  cardName: cardName,
);

void main() {
  final items = [
    item(MonthItemType.income, paid: true, title: 'salário'),
    item(MonthItemType.oneOffIncome, title: 'freela'),
    item(MonthItemType.fixedExpense, title: 'energia'),
    item(MonthItemType.fixedExpense, cardName: 'Nubank', title: 'streaming'),
    item(MonthItemType.debtInstallment, paid: true, title: 'acordo'),
    item(MonthItemType.cardInvoice, title: 'fatura'),
    item(MonthItemType.oneOffExpense, title: 'exame'),
  ];

  List<String> titles(TransactionFilter filter) =>
      filter.apply(items).map((i) => i.title).toList();

  test('sem filtro retorna tudo', () {
    expect(titles(const TransactionFilter()), hasLength(items.length));
  });

  test('filtra por tipo', () {
    expect(titles(const TransactionFilter(type: TypeFilter.incomes)), [
      'salário',
      'freela',
    ]);
    expect(titles(const TransactionFilter(type: TypeFilter.fixedExpenses)), [
      'energia',
      'streaming',
    ]);
    expect(titles(const TransactionFilter(type: TypeFilter.debts)), ['acordo']);
    expect(titles(const TransactionFilter(type: TypeFilter.invoices)), [
      'fatura',
    ]);
    expect(titles(const TransactionFilter(type: TypeFilter.oneOffExpenses)), [
      'exame',
    ]);
  });

  test('filtra por status; itens no cartão ficam fora de pago/pendente', () {
    expect(titles(const TransactionFilter(status: StatusFilter.paid)), [
      'salário',
      'acordo',
    ]);
    expect(titles(const TransactionFilter(status: StatusFilter.pending)), [
      'freela',
      'energia',
      'fatura',
      'exame',
    ]);
  });

  test('combina tipo e status', () {
    const filter = TransactionFilter(
      type: TypeFilter.incomes,
      status: StatusFilter.pending,
    );
    expect(titles(filter), ['freela']);
  });
}
