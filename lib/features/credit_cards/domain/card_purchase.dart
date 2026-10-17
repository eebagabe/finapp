import '../../../core/domain/year_month.dart';

class CardPurchaseInstallment {
  const CardPurchaseInstallment({
    required this.id,
    required this.purchaseId,
    required this.number,
    required this.invoiceMonth,
    required this.amountCents,
  });

  final int id;
  final int purchaseId;
  final int number;

  /// Mês de vencimento da fatura em que a parcela cai.
  final YearMonth invoiceMonth;
  final int amountCents;
}

/// Compra lançada no cartão, à vista ou parcelada.
class CardPurchase {
  const CardPurchase({
    required this.id,
    required this.cardId,
    required this.description,
    required this.totalCents,
    required this.purchaseDate,
    required this.installmentCount,
    required this.installments,
    this.firstInvoiceMonth,
    this.categoryId,
  });

  final int id;
  final int cardId;
  final String description;
  final int totalCents;
  final DateTime purchaseDate;
  final int installmentCount;
  final List<CardPurchaseInstallment> installments;

  /// Fatura da 1ª parcela escolhida manualmente (nulo = regra do cartão).
  final YearMonth? firstInvoiceMonth;
  final int? categoryId;

  bool get isInstallment => installmentCount > 1;

  /// Parcela que cai na fatura de [invoiceMonth], se houver.
  CardPurchaseInstallment? installmentIn(YearMonth invoiceMonth) {
    for (final installment in installments) {
      if (installment.invoiceMonth == invoiceMonth) return installment;
    }
    return null;
  }
}

/// Dados do formulário de compra no cartão.
class CardPurchaseDraft {
  const CardPurchaseDraft({
    required this.cardId,
    required this.description,
    required this.totalCents,
    required this.purchaseDate,
    required this.installmentCount,
    this.firstInvoiceMonth,
    this.categoryId,
  });

  final int cardId;
  final String description;
  final int totalCents;
  final DateTime purchaseDate;

  /// 1 = à vista.
  final int installmentCount;

  /// Fatura da 1ª parcela, quando diferente da calculada pela regra de
  /// fechamento do cartão.
  final YearMonth? firstInvoiceMonth;
  final int? categoryId;
}
