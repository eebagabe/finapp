import '../../../core/domain/installments.dart';
import '../../../core/domain/year_month.dart';

/// Sincronização entre "parcelas restantes" e "data da última parcela" do
/// formulário de dívidas. Alterar um campo recalcula o outro.
abstract final class DebtSchedule {
  /// Data da última parcela, dado o próximo pagamento e quantas restam.
  ///
  /// 21/11/2026 + 9 parcelas → 21/07/2027.
  static DateTime lastInstallmentDate(DateTime nextPayment, int remaining) {
    if (remaining < 1) {
      throw ArgumentError.value(remaining, 'remaining', 'must be at least 1');
    }
    return addMonths(nextPayment, remaining - 1);
  }

  /// Quantidade de parcelas restantes entre o próximo pagamento e a última
  /// parcela (ambos inclusos). Considera apenas mês/ano.
  ///
  /// 21/11/2026 até 21/05/2027 → 7 parcelas.
  /// Retorna `null` se a última parcela for antes do próximo pagamento.
  static int? remainingInstallments(
    DateTime nextPayment,
    DateTime lastPayment,
  ) {
    final months = YearMonth.fromDate(nextPayment)
        .monthsUntil(YearMonth.fromDate(lastPayment));
    return months < 0 ? null : months + 1;
  }
}

/// Como o valor da dívida foi informado.
enum DebtValueMode {
  /// Valor de cada parcela informado diretamente.
  installment,

  /// Valor total informado; o app divide pelas parcelas.
  total,
}

/// Parcela planejada, antes de ser persistida.
class PlannedInstallment {
  const PlannedInstallment({
    required this.number,
    required this.dueDate,
    required this.amountCents,
  });

  /// Número da parcela, começando em 1.
  final int number;
  final DateTime dueDate;
  final int amountCents;

  @override
  bool operator ==(Object other) =>
      other is PlannedInstallment &&
      other.number == number &&
      other.dueDate == dueDate &&
      other.amountCents == amountCents;

  @override
  int get hashCode => Object.hash(number, dueDate, amountCents);

  @override
  String toString() => 'PlannedInstallment($number, $dueDate, $amountCents)';
}

/// Gera uma parcela por mês a partir de [firstDueDate].
///
/// Em [DebtValueMode.installment], [amountCents] é o valor de cada parcela.
/// Em [DebtValueMode.total], [amountCents] é o total, dividido com
/// [splitInstallments] (centavos restantes na última parcela).
List<PlannedInstallment> planDebtInstallments({
  required DebtValueMode mode,
  required int amountCents,
  required int count,
  required DateTime firstDueDate,
  int firstNumber = 1,
}) {
  final amounts = switch (mode) {
    DebtValueMode.installment => List.filled(count, amountCents),
    DebtValueMode.total => splitInstallments(amountCents, count),
  };
  final dates = monthlyDates(dateOnly(firstDueDate), count);
  return [
    for (var i = 0; i < count; i++)
      PlannedInstallment(
        number: firstNumber + i,
        dueDate: dates[i],
        amountCents: amounts[i],
      ),
  ];
}
