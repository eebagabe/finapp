import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/year_month.dart';

/// Mês selecionado no resumo e nos lançamentos. Começa no mês atual.
class SelectedMonth extends Notifier<YearMonth> {
  @override
  YearMonth build() => YearMonth.now();

  void next() => state = state.next;

  void previous() => state = state.previous;

  void select(YearMonth month) => state = month;
}

final selectedMonthProvider = NotifierProvider<SelectedMonth, YearMonth>(
  SelectedMonth.new,
);
