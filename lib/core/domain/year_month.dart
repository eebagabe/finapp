import 'package:flutter/foundation.dart';

/// Quantidade de dias do mês [month] (1-12) no ano [year].
int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Remove a parte de horário, mantendo apenas a data.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Soma [months] meses a [date], mantendo o dia sempre que possível.
///
/// Se o mês de destino não tiver o dia (ex.: 31 em fevereiro), usa o último
/// dia desse mês. Para gerar uma série mensal, sempre some a partir da data
/// original (`addMonths(inicio, i)`), assim 31/01 vira 28/02 e depois 31/03.
DateTime addMonths(DateTime date, int months) {
  final target = YearMonth.fromDate(date).addMonths(months);
  return target.dateAt(date.day);
}

/// Um mês de um ano específico, sem dia. Usado como referência de competência
/// (resumo mensal, fatura, ajustes do mês).
///
/// Persistido como inteiro `yyyymm` via [key].
@immutable
class YearMonth implements Comparable<YearMonth> {
  const YearMonth(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'month must be between 1 and 12');

  factory YearMonth.fromDate(DateTime date) => YearMonth(date.year, date.month);

  factory YearMonth.fromKey(int key) => YearMonth(key ~/ 100, key % 100);

  factory YearMonth.now() => YearMonth.fromDate(DateTime.now());

  final int year;
  final int month;

  /// Representação `yyyymm`, ex.: 202611.
  int get key => year * 100 + month;

  int get daysCount => daysInMonth(year, month);

  DateTime get firstDay => DateTime(year, month);

  DateTime get lastDay => DateTime(year, month, daysCount);

  YearMonth addMonths(int months) {
    final zeroBased = year * 12 + (month - 1) + months;
    return YearMonth(zeroBased ~/ 12, zeroBased % 12 + 1);
  }

  YearMonth get next => addMonths(1);

  YearMonth get previous => addMonths(-1);

  /// Quantidade de meses de `this` até [other] (negativo se [other] for antes).
  int monthsUntil(YearMonth other) =>
      (other.year * 12 + other.month) - (year * 12 + month);

  /// Data neste mês no dia [day], limitada ao último dia do mês.
  DateTime dateAt(int day) => DateTime(year, month, day.clamp(1, daysCount));

  bool contains(DateTime date) => date.year == year && date.month == month;

  bool isBefore(YearMonth other) => compareTo(other) < 0;

  bool isAfter(YearMonth other) => compareTo(other) > 0;

  @override
  int compareTo(YearMonth other) => key.compareTo(other.key);

  @override
  bool operator ==(Object other) =>
      other is YearMonth && other.year == year && other.month == month;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => '${month.toString().padLeft(2, '0')}/$year';
}
