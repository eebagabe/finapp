import 'monthly_summary.dart';

/// Saldo previsto ao fim de um mês, partindo do saldo em conta de hoje.
///
/// O saldo em conta já reflete o que foi pago e recebido, então só os itens
/// pendentes de cada mês (do atual até o mês projetado) entram na conta.
class BalanceProjection {
  const BalanceProjection({
    required this.bankBalanceCents,
    required this.projectedCents,
  });

  final int bankBalanceCents;

  /// Saldo em conta + receitas a receber − despesas a pagar, acumulado.
  final int projectedCents;

  /// Quanto falta conseguir, já contando o saldo em conta (0 se sobra).
  int get shortfallCents => projectedCents < 0 ? -projectedCents : 0;
}

/// Projeta o saldo ao fim do último mês de [months] (do atual em diante).
BalanceProjection projectBalance({
  required int bankBalanceCents,
  required Iterable<MonthlySummary> months,
}) {
  final pending = months.fold(
    0,
    (sum, m) => sum + m.pendingIncomeCents - m.pendingExpenseCents,
  );
  return BalanceProjection(
    bankBalanceCents: bankBalanceCents,
    projectedCents: bankBalanceCents + pending,
  );
}
