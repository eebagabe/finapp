import '../../../core/domain/year_month.dart';
import '../../fixed_expenses/domain/fixed_expense.dart';
import '../../transactions/domain/entry_types.dart';
import '../../transactions/domain/monthly_record.dart';
import 'card_purchase.dart';
import 'credit_card.dart';

enum InvoiceLineKind { purchase, fixedExpense }

/// Item que compõe uma fatura.
class InvoiceLine {
  const InvoiceLine({
    required this.kind,
    required this.sourceId,
    required this.description,
    required this.amountCents,
    required this.date,
    this.installmentNumber,
    this.installmentCount,
  });

  final InvoiceLineKind kind;

  /// Id da compra ou da despesa fixa.
  final int sourceId;
  final String description;
  final int amountCents;

  /// Data da compra ou da cobrança da despesa fixa.
  final DateTime date;
  final int? installmentNumber;
  final int? installmentCount;

  /// `2/3` para compras parceladas.
  String? get installmentLabel =>
      installmentCount != null && installmentCount! > 1
      ? '$installmentNumber/$installmentCount'
      : null;
}

/// Fatura de um cartão em um mês (identificada pelo mês de vencimento).
class Invoice {
  const Invoice({
    required this.card,
    required this.month,
    required this.lines,
    this.overrideCents,
    this.paidAt,
  });

  final CreditCard card;
  final YearMonth month;
  final List<InvoiceLine> lines;

  /// "Valor total da fatura" informado manualmente. Quando existe, substitui
  /// a soma dos lançamentos.
  final int? overrideCents;
  final DateTime? paidAt;

  int get computedCents => lines.fold(0, (sum, l) => sum + l.amountCents);

  int get totalCents => overrideCents ?? computedCents;

  bool get hasOverride => overrideCents != null;

  bool get isPaid => paidAt != null;

  bool get isEmpty => totalCents == 0;

  DateTime get dueDate => card.invoiceDueDate(month);
}

/// Monta a fatura de [card] com vencimento em [month].
///
/// - Parcelas de compras cuja fatura é [month].
/// - Despesas fixas vinculadas ao cartão cuja cobrança (no dia de vencimento
///   da despesa) cai na fatura de [month] pela regra de fechamento. Usa o
///   valor ajustado do mês da cobrança, se houver.
/// - Se houver "valor total da fatura" informado, ele vira o total.
Invoice buildInvoice({
  required CreditCard card,
  required YearMonth month,
  required Iterable<CardPurchase> purchases,
  required Iterable<FixedExpense> fixedExpenses,
  required MonthlyRecordIndex records,
}) {
  final lines = <InvoiceLine>[];

  for (final purchase in purchases) {
    if (purchase.cardId != card.id) continue;
    final installment = purchase.installmentIn(month);
    if (installment == null) continue;
    lines.add(
      InvoiceLine(
        kind: InvoiceLineKind.purchase,
        sourceId: purchase.id,
        description: purchase.description,
        amountCents: installment.amountCents,
        date: purchase.purchaseDate,
        installmentNumber: installment.number,
        installmentCount: purchase.installmentCount,
      ),
    );
  }

  for (final expense in fixedExpenses) {
    if (expense.creditCardId != card.id) continue;
    // A cobrança de um mês cai, no máximo, duas faturas à frente.
    for (var offset = 0; offset <= 2; offset++) {
      final chargeMonth = month.addMonths(-offset);
      if (!expense.appliesTo(chargeMonth)) continue;
      final chargeDate = expense.dueDateIn(chargeMonth);
      if (card.invoiceMonthFor(chargeDate) != month) continue;

      final record = records.find(
        RecordSource.fixedExpense,
        expense.id,
        chargeMonth,
      );
      lines.add(
        InvoiceLine(
          kind: InvoiceLineKind.fixedExpense,
          sourceId: expense.id,
          description: expense.description,
          amountCents:
              record?.amountOverrideCents ?? expense.defaultAmountCents,
          date: chargeDate,
        ),
      );
    }
  }

  lines.sort((a, b) => a.date.compareTo(b.date));
  final invoiceRecord = records.find(RecordSource.cardInvoice, card.id, month);
  return Invoice(
    card: card,
    month: month,
    lines: lines,
    overrideCents: invoiceRecord?.amountOverrideCents,
    paidAt: invoiceRecord?.paidAt,
  );
}
