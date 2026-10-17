import '../../../core/domain/year_month.dart';
import 'invoice_rules.dart';

class CreditCard {
  const CreditCard({
    required this.id,
    required this.name,
    required this.closingDay,
    required this.dueDay,
    this.limitCents,
  });

  final int id;
  final String name;

  /// Melhor dia de compra (dia de fechamento).
  final int closingDay;
  final int dueDay;
  final int? limitCents;

  YearMonth invoiceMonthFor(DateTime purchaseDate) =>
      InvoiceRules.invoiceMonthFor(
        purchaseDate,
        closingDay: closingDay,
        dueDay: dueDay,
      );

  DateTime invoiceDueDate(YearMonth invoiceMonth) =>
      InvoiceRules.dueDate(invoiceMonth, dueDay: dueDay);
}

/// Dados do formulário de cartão (sem id).
class CreditCardInput {
  const CreditCardInput({
    required this.name,
    required this.closingDay,
    required this.dueDay,
    this.limitCents,
  });

  final String name;
  final int closingDay;
  final int dueDay;
  final int? limitCents;
}
