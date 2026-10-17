import '../../../core/domain/year_month.dart';

/// Receita fixa mensal (ex.: salário todo dia 5).
class Income {
  const Income({
    required this.id,
    required this.description,
    required this.amountCents,
    required this.dayOfMonth,
    required this.active,
    required this.startMonth,
    this.categoryId,
  });

  final int id;
  final String description;
  final int amountCents;
  final int dayOfMonth;
  final bool active;

  /// Primeiro mês em que a receita vale.
  final YearMonth startMonth;
  final int? categoryId;

  /// Próximo recebimento a partir de [from] (hoje, por padrão).
  DateTime nextDate([DateTime? from]) => nextMonthlyDate(
    start: startMonth,
    day: dayOfMonth,
    from: from ?? DateTime.now(),
  );

  /// Se a receita deve aparecer em [month].
  bool appliesTo(YearMonth month) => active && !month.isBefore(startMonth);
}

class IncomeInput {
  const IncomeInput({
    required this.description,
    required this.amountCents,
    required this.dayOfMonth,
    required this.active,
    this.startMonth,
    this.categoryId,
  });

  final String description;
  final int amountCents;
  final int dayOfMonth;
  final bool active;

  /// Primeiro mês em que vale. Na criação, nulo = mês atual; na edição, nulo
  /// mantém o mês já salvo.
  final YearMonth? startMonth;
  final int? categoryId;
}
