import '../../summary/domain/monthly_summary.dart';

enum TypeFilter {
  all('Todos'),
  incomes('Receitas'),
  fixedExpenses('Despesas fixas'),
  debts('Dívidas'),
  invoices('Faturas'),
  oneOffExpenses('Avulsos');

  const TypeFilter(this.label);

  final String label;

  bool matches(MonthItem item) => switch (this) {
    TypeFilter.all => true,
    TypeFilter.incomes => item.isIncome,
    TypeFilter.fixedExpenses => item.type == MonthItemType.fixedExpense,
    TypeFilter.debts => item.type == MonthItemType.debtInstallment,
    TypeFilter.invoices => item.type == MonthItemType.cardInvoice,
    TypeFilter.oneOffExpenses => item.type == MonthItemType.oneOffExpense,
  };
}

enum StatusFilter {
  all('Todos'),
  pending('Pendentes'),
  paid('Pagos');

  const StatusFilter(this.label);

  final String label;

  /// Itens no cartão não têm status próprio: aparecem só em "Todos".
  bool matches(MonthItem item) => switch (this) {
    StatusFilter.all => true,
    StatusFilter.pending => item.isPayable && !item.isPaid,
    StatusFilter.paid => item.isPayable && item.isPaid,
  };
}

/// Filtro da tela de lançamentos.
class TransactionFilter {
  const TransactionFilter({
    this.type = TypeFilter.all,
    this.status = StatusFilter.all,
  });

  final TypeFilter type;
  final StatusFilter status;

  TransactionFilter copyWith({TypeFilter? type, StatusFilter? status}) =>
      TransactionFilter(type: type ?? this.type, status: status ?? this.status);

  List<MonthItem> apply(Iterable<MonthItem> items) =>
      items.where((i) => type.matches(i) && status.matches(i)).toList();
}
