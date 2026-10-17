import '../../../core/domain/installments.dart';
import '../../../core/domain/year_month.dart';

/// Regras de fatura de cartão de crédito.
///
/// ## Identificação da fatura
/// Cada fatura é identificada pelo **mês em que vence** (o mês em que ela é
/// paga e aparece no resumo mensal).
///
/// ## Regra de fechamento (melhor dia de compra)
/// - Compra feita **antes** do melhor dia → entra na fatura atual.
/// - Compra feita **no melhor dia ou depois** → entra na fatura seguinte,
///   mesmo que seja no mesmo mês.
///
/// Exemplo: melhor dia 1, vencimento dia 8.
/// - Compra em 30/09 → fatura que vence em 08/10.
/// - Compra em 01/10 a 31/10 → fatura que vence em 08/11.
///
/// ## Vencimento antes do fechamento no calendário
/// Se o dia de vencimento for menor ou igual ao melhor dia (ex.: melhor dia 25,
/// vencimento dia 5), a fatura que fecha num mês só vence no mês seguinte.
/// Compra em 20/10 → fecha em 25/10 → vence em 05/11 (fatura de novembro).
///
/// Se o melhor dia não existir no mês (ex.: 31 em fevereiro), considera-se o
/// último dia do mês.
abstract final class InvoiceRules {
  /// Mês de vencimento da fatura em que cai uma compra feita em [purchaseDate].
  static YearMonth invoiceMonthFor(
    DateTime purchaseDate, {
    required int closingDay,
    required int dueDay,
  }) {
    final purchaseMonth = YearMonth.fromDate(purchaseDate);
    final effectiveClosingDay = purchaseMonth.dateAt(closingDay).day;

    var invoiceMonth = purchaseMonth;
    if (purchaseDate.day >= effectiveClosingDay) {
      invoiceMonth = invoiceMonth.next;
    }
    if (dueDay <= closingDay) {
      invoiceMonth = invoiceMonth.next;
    }
    return invoiceMonth;
  }

  /// Data de vencimento da fatura do mês [invoiceMonth].
  static DateTime dueDate(YearMonth invoiceMonth, {required int dueDay}) =>
      invoiceMonth.dateAt(dueDay);

  /// Distribui uma compra parcelada nas faturas: a parcela 1 cai na fatura da
  /// data da compra e cada parcela seguinte na fatura do mês seguinte.
  ///
  /// Centavos restantes da divisão ficam na última parcela.
  static List<InvoiceInstallment> distributePurchase({
    required int totalCents,
    required int installmentCount,
    required DateTime purchaseDate,
    required int closingDay,
    required int dueDay,
  }) {
    final firstInvoice = invoiceMonthFor(
      purchaseDate,
      closingDay: closingDay,
      dueDay: dueDay,
    );
    final amounts = splitInstallments(totalCents, installmentCount);
    return [
      for (var i = 0; i < installmentCount; i++)
        InvoiceInstallment(
          number: i + 1,
          invoiceMonth: firstInvoice.addMonths(i),
          amountCents: amounts[i],
        ),
    ];
  }
}

/// Parcela de uma compra no cartão já atribuída a uma fatura.
class InvoiceInstallment {
  const InvoiceInstallment({
    required this.number,
    required this.invoiceMonth,
    required this.amountCents,
  });

  final int number;
  final YearMonth invoiceMonth;
  final int amountCents;

  @override
  bool operator ==(Object other) =>
      other is InvoiceInstallment &&
      other.number == number &&
      other.invoiceMonth == invoiceMonth &&
      other.amountCents == amountCents;

  @override
  int get hashCode => Object.hash(number, invoiceMonth, amountCents);

  @override
  String toString() =>
      'InvoiceInstallment($number, $invoiceMonth, $amountCents)';
}
