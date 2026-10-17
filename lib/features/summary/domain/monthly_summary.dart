import '../../../core/domain/year_month.dart';
import '../../credit_cards/domain/credit_card.dart';
import '../../credit_cards/domain/invoice.dart';
import '../../debts/domain/debt.dart';
import '../../fixed_expenses/domain/fixed_expense.dart';
import '../../incomes/domain/income.dart';
import '../../transactions/domain/entry_types.dart';
import '../../transactions/domain/monthly_record.dart';
import '../../transactions/domain/one_off_entry.dart';

enum MonthItemType {
  income,
  oneOffIncome,
  fixedExpense,
  debtInstallment,
  cardInvoice,
  oneOffExpense;

  bool get isIncome => this == income || this == oneOffIncome;

  /// Itens recorrentes cujo valor pode ser ajustado só para o mês.
  bool get isAdjustable => this == income || this == fixedExpense;
}

/// Um item do mês: receita, despesa fixa, parcela de dívida, fatura ou avulso.
class MonthItem {
  const MonthItem({
    required this.type,
    required this.sourceId,
    required this.title,
    required this.amountCents,
    required this.date,
    this.parentId,
    this.subtitle,
    this.defaultAmountCents,
    this.paidAt,
    this.cardName,
  });

  final MonthItemType type;

  /// Id da receita, despesa fixa, parcela de dívida, cartão ou avulso,
  /// conforme [type].
  final int sourceId;

  /// Id da dívida, quando o item é uma parcela.
  final int? parentId;
  final String title;
  final String? subtitle;
  final int amountCents;

  /// Valor padrão de itens recorrentes (para indicar quando foi ajustado).
  final int? defaultAmountCents;

  /// Vencimento ou data prevista.
  final DateTime date;
  final DateTime? paidAt;

  /// Cartão em que a despesa fixa é cobrada. Nesse caso o valor já está na
  /// fatura e o item não é somado de novo.
  final String? cardName;

  bool get isIncome => type.isIncome;

  bool get isPaid => paidAt != null;

  bool get isOnCard => cardName != null;

  /// Se entra nos totais. Despesas fixas no cartão entram via fatura.
  bool get countsInTotals => !isOnCard;

  /// Se pode ser marcado como pago/recebido individualmente.
  bool get isPayable => countsInTotals;

  bool get isAdjusted =>
      defaultAmountCents != null && defaultAmountCents != amountCents;
}

/// Resumo financeiro de um mês.
class MonthlySummary {
  MonthlySummary({required this.month, required List<MonthItem> items})
    : items = List.unmodifiable(
        <MonthItem>[...items]..sort((a, b) => a.date.compareTo(b.date)),
      );

  final YearMonth month;

  /// Itens ordenados por data.
  final List<MonthItem> items;

  Iterable<MonthItem> get _counted => items.where((i) => i.countsInTotals);

  Iterable<MonthItem> get incomes => _counted.where((i) => i.isIncome);

  Iterable<MonthItem> get expenses => _counted.where((i) => !i.isIncome);

  int get incomeCents => _sum(incomes);

  int get expenseCents => _sum(expenses);

  /// Receitas − despesas.
  int get balanceCents => incomeCents - expenseCents;

  /// Quanto falta conseguir para não fechar no vermelho (0 se sobra).
  int get shortfallCents => balanceCents < 0 ? -balanceCents : 0;

  int get paidExpenseCents => _sum(expenses.where((i) => i.isPaid));

  int get pendingExpenseCents => expenseCents - paidExpenseCents;

  int get receivedIncomeCents => _sum(incomes.where((i) => i.isPaid));

  int get pendingIncomeCents => incomeCents - receivedIncomeCents;

  List<MonthItem> ofType(MonthItemType type) =>
      items.where((i) => i.type == type).toList();

  static int _sum(Iterable<MonthItem> items) =>
      items.fold(0, (sum, i) => sum + i.amountCents);
}

/// Monta o resumo de [month].
///
/// - Receitas: fixas (com ajuste do mês, se houver) + avulsas.
/// - Despesas: fixas fora do cartão + parcelas de dívidas que vencem no mês +
///   faturas que vencem no mês + avulsas.
/// - Despesas fixas no cartão aparecem na lista com o nome do cartão, mas não
///   são somadas: o valor já está na fatura.
MonthlySummary calculateMonthlySummary({
  required YearMonth month,
  required Iterable<Income> incomes,
  required Iterable<FixedExpense> fixedExpenses,
  required Iterable<CreditCard> cards,
  required Iterable<Debt> debts,
  required Iterable<Invoice> invoices,
  required Iterable<OneOffEntry> oneOffEntries,
  required MonthlyRecordIndex records,
}) {
  final cardNames = {for (final card in cards) card.id: card.name};
  final items = <MonthItem>[];

  for (final income in incomes) {
    final record = records.find(RecordSource.income, income.id, month);
    // Mantém no histórico itens desativados que já tinham registro no mês.
    if (!income.appliesTo(month) && record == null) continue;
    items.add(
      MonthItem(
        type: MonthItemType.income,
        sourceId: income.id,
        title: income.description,
        amountCents: record?.amountOverrideCents ?? income.amountCents,
        defaultAmountCents: income.amountCents,
        date: month.dateAt(income.dayOfMonth),
        paidAt: record?.paidAt,
      ),
    );
  }

  for (final expense in fixedExpenses) {
    final record = records.find(RecordSource.fixedExpense, expense.id, month);
    if (!expense.appliesTo(month) && record == null) continue;
    final cardName = cardNames[expense.creditCardId];
    items.add(
      MonthItem(
        type: MonthItemType.fixedExpense,
        sourceId: expense.id,
        title: expense.description,
        subtitle: cardName == null ? null : 'no cartão $cardName',
        amountCents: record?.amountOverrideCents ?? expense.defaultAmountCents,
        defaultAmountCents: expense.defaultAmountCents,
        date: expense.dueDateIn(month),
        paidAt: cardName == null ? record?.paidAt : null,
        cardName: cardName,
      ),
    );
  }

  for (final debt in debts) {
    final total = debt.installments.length;
    for (final installment in debt.installments) {
      if (!month.contains(installment.dueDate)) continue;
      items.add(
        MonthItem(
          type: MonthItemType.debtInstallment,
          sourceId: installment.id,
          parentId: debt.id,
          title: debt.description,
          subtitle: 'parcela ${installment.number} de $total',
          amountCents: installment.amountCents,
          date: installment.dueDate,
          paidAt: installment.paidAt,
        ),
      );
    }
  }

  for (final invoice in invoices) {
    if (invoice.month != month) continue;
    if (invoice.isEmpty && !invoice.isPaid) continue;
    items.add(
      MonthItem(
        type: MonthItemType.cardInvoice,
        sourceId: invoice.card.id,
        title: 'Fatura ${invoice.card.name}',
        subtitle: invoice.hasOverride ? 'valor informado' : null,
        amountCents: invoice.totalCents,
        date: invoice.dueDate,
        paidAt: invoice.paidAt,
      ),
    );
  }

  for (final entry in oneOffEntries) {
    if (!month.contains(entry.date)) continue;
    items.add(
      MonthItem(
        type: entry.kind == EntryKind.income
            ? MonthItemType.oneOffIncome
            : MonthItemType.oneOffExpense,
        sourceId: entry.id,
        title: entry.description,
        amountCents: entry.amountCents,
        date: entry.date,
        paidAt: entry.paidAt,
      ),
    );
  }

  return MonthlySummary(month: month, items: items);
}
