import '../../../core/domain/year_month.dart';

/// Despesa recorrente mensal (ex.: energia ~R$ 150 todo dia 8).
///
/// Quando vinculada a um cartão ([creditCardId]), a despesa entra na fatura
/// desse cartão e não é somada separadamente no resumo.
class FixedExpense {
  const FixedExpense({
    required this.id,
    required this.description,
    required this.defaultAmountCents,
    required this.dueDay,
    required this.active,
    required this.startMonth,
    this.creditCardId,
  });

  final int id;
  final String description;

  /// Valor padrão (pode ser aproximado). O valor real de cada mês pode ser
  /// ajustado sem alterar este valor.
  final int defaultAmountCents;
  final int dueDay;
  final bool active;
  final YearMonth startMonth;
  final int? creditCardId;

  bool get isOnCard => creditCardId != null;

  /// Se a despesa deve aparecer em [month].
  bool appliesTo(YearMonth month) => active && !month.isBefore(startMonth);

  /// Data em que a despesa ocorre em [month].
  DateTime dueDateIn(YearMonth month) => month.dateAt(dueDay);
}

class FixedExpenseInput {
  const FixedExpenseInput({
    required this.description,
    required this.defaultAmountCents,
    required this.dueDay,
    required this.active,
    this.creditCardId,
  });

  final String description;
  final int defaultAmountCents;
  final int dueDay;
  final bool active;
  final int? creditCardId;
}
