import 'year_month.dart';

/// Divide [totalCents] em [count] parcelas inteiras cuja soma é exatamente
/// [totalCents].
///
/// Os centavos que sobram da divisão vão para a **última** parcela.
/// Ex.: R$ 100,00 em 3x → 33,33 + 33,33 + 33,34.
List<int> splitInstallments(int totalCents, int count) {
  if (count < 1) {
    throw ArgumentError.value(count, 'count', 'must be at least 1');
  }
  if (totalCents < 0) {
    throw ArgumentError.value(totalCents, 'totalCents', 'must not be negative');
  }
  final base = totalCents ~/ count;
  final remainder = totalCents - base * count;
  return [
    for (var i = 0; i < count; i++) i == count - 1 ? base + remainder : base,
  ];
}

/// Datas mensais a partir de [first], uma por parcela.
///
/// Sempre calcula a partir de [first] para preservar o dia original quando o
/// mês é curto (31/01 → 28/02 → 31/03).
List<DateTime> monthlyDates(DateTime first, int count) => [
  for (var i = 0; i < count; i++) addMonths(first, i),
];
