import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/credit_cards/domain/credit_card.dart';
import 'package:finapp/features/credit_cards/domain/invoice.dart';
import 'package:finapp/features/debts/domain/debt.dart';
import 'package:finapp/features/debts/domain/debt_schedule.dart';
import 'package:finapp/features/fixed_expenses/domain/fixed_expense.dart';
import 'package:finapp/features/incomes/domain/income.dart';
import 'package:finapp/features/summary/domain/monthly_summary.dart';
import 'package:finapp/features/transactions/domain/entry_types.dart';
import 'package:finapp/features/transactions/domain/monthly_record.dart';
import 'package:finapp/features/transactions/domain/one_off_entry.dart';
import 'package:flutter_test/flutter_test.dart';

const nov = YearMonth(2026, 11);
const start = YearMonth(2026, 1);
const nubank = CreditCard(id: 1, name: 'Nubank', closingDay: 1, dueDay: 8);

Income salary({int amount = 300000, bool active = true}) => Income(
  id: 1,
  description: 'Salário',
  amountCents: amount,
  dayOfMonth: 5,
  active: active,
  startMonth: start,
);

FixedExpense fixed({
  int id = 1,
  String description = 'Energia',
  int amount = 15000,
  int dueDay = 8,
  int? cardId,
}) => FixedExpense(
  id: id,
  description: description,
  defaultAmountCents: amount,
  dueDay: dueDay,
  active: true,
  startMonth: start,
  creditCardId: cardId,
);

Debt debt({List<(DateTime, int, bool)> installments = const []}) => Debt(
  id: 1,
  description: 'Acordo com Carrefour',
  valueMode: DebtValueMode.installment,
  installments: [
    for (var i = 0; i < installments.length; i++)
      DebtInstallment(
        id: 10 + i,
        debtId: 1,
        number: i + 1,
        dueDate: installments[i].$1,
        amountCents: installments[i].$2,
        paidAt: installments[i].$3 ? DateTime(2026, 11, 1) : null,
      ),
  ],
);

Invoice invoice({
  int? overrideCents,
  DateTime? paidAt,
  YearMonth month = nov,
}) => Invoice(
  card: nubank,
  month: month,
  lines: [
    InvoiceLine(
      kind: InvoiceLineKind.purchase,
      sourceId: 1,
      description: 'Mercado',
      amountCents: 50000,
      date: DateTime(2026, 10, 15),
    ),
  ],
  overrideCents: overrideCents,
  paidAt: paidAt,
);

MonthlySummary summarize({
  List<Income> incomes = const [],
  List<FixedExpense> fixedExpenses = const [],
  List<Debt> debts = const [],
  List<Invoice> invoices = const [],
  List<OneOffEntry> oneOffEntries = const [],
  List<MonthlyRecord> records = const [],
}) => calculateMonthlySummary(
  month: nov,
  incomes: incomes,
  fixedExpenses: fixedExpenses,
  cards: const [nubank],
  debts: debts,
  invoices: invoices,
  oneOffEntries: oneOffEntries,
  records: MonthlyRecordIndex(records),
);

void main() {
  test('receita 3.000 e despesas 4.500: falta conseguir 1.500', () {
    final summary = summarize(
      incomes: [salary()],
      fixedExpenses: [fixed(amount: 250000)],
      debts: [
        debt(installments: [(DateTime(2026, 11, 21), 150000, false)]),
      ],
      invoices: [invoice(overrideCents: 50000)],
    );

    expect(summary.incomeCents, 300000);
    expect(summary.expenseCents, 450000);
    expect(summary.balanceCents, -150000);
    expect(summary.shortfallCents, 150000);
  });

  test('sem déficit, falta conseguir é zero', () {
    final summary = summarize(incomes: [salary()], fixedExpenses: [fixed()]);
    expect(summary.balanceCents, 285000);
    expect(summary.shortfallCents, 0);
  });

  test('despesa fixa no cartão aparece mas não soma duas vezes', () {
    final summary = summarize(
      fixedExpenses: [fixed(description: 'Streaming', amount: 3990, cardId: 1)],
      invoices: [invoice()],
    );

    final streaming = summary.ofType(MonthItemType.fixedExpense).single;
    expect(streaming.isOnCard, isTrue);
    expect(streaming.subtitle, 'no cartão Nubank');
    expect(streaming.countsInTotals, isFalse);
    expect(summary.expenseCents, 50000);
  });

  test('valor ajustado do mês substitui o valor padrão', () {
    final summary = summarize(
      fixedExpenses: [fixed()],
      records: [
        const MonthlyRecord(
          source: RecordSource.fixedExpense,
          sourceId: 1,
          month: nov,
          amountOverrideCents: 16200,
        ),
      ],
    );
    final energy = summary.items.single;
    expect(energy.amountCents, 16200);
    expect(energy.defaultAmountCents, 15000);
    expect(energy.isAdjusted, isTrue);
    expect(summary.expenseCents, 16200);
  });

  test('apenas parcelas de dívida que vencem no mês entram', () {
    final summary = summarize(
      debts: [
        debt(
          installments: [
            (DateTime(2026, 10, 21), 25000, true),
            (DateTime(2026, 11, 21), 25000, false),
            (DateTime(2026, 12, 21), 25000, false),
          ],
        ),
      ],
    );
    final item = summary.items.single;
    expect(item.type, MonthItemType.debtInstallment);
    expect(item.subtitle, 'parcela 2 de 3');
    expect(summary.expenseCents, 25000);
  });

  test('fatura entra na data de vencimento do cartão', () {
    final summary = summarize(invoices: [invoice()]);
    final item = summary.items.single;
    expect(item.type, MonthItemType.cardInvoice);
    expect(item.date, DateTime(2026, 11, 8));
    expect(item.amountCents, 50000);
  });

  test('fatura vazia e não paga não aparece', () {
    const empty = Invoice(card: nubank, month: nov, lines: []);
    expect(summarize(invoices: [empty]).items, isEmpty);
  });

  test('avulsos entram como receita ou despesa', () {
    final summary = summarize(
      oneOffEntries: [
        OneOffEntry(
          id: 1,
          kind: EntryKind.expense,
          description: 'Exame',
          amountCents: 30000,
          date: DateTime(2026, 11, 12),
        ),
        OneOffEntry(
          id: 2,
          kind: EntryKind.income,
          description: 'Freela',
          amountCents: 80000,
          date: DateTime(2026, 11, 20),
        ),
        OneOffEntry(
          id: 3,
          kind: EntryKind.expense,
          description: 'Outro mês',
          amountCents: 99999,
          date: DateTime(2026, 12, 1),
        ),
      ],
    );
    expect(summary.expenseCents, 30000);
    expect(summary.incomeCents, 80000);
  });

  test('separa pago e pendente', () {
    final summary = summarize(
      incomes: [salary()],
      fixedExpenses: [
        fixed(),
        fixed(id: 2, description: 'Faculdade', amount: 13900),
      ],
      records: [
        MonthlyRecord(
          source: RecordSource.fixedExpense,
          sourceId: 1,
          month: nov,
          paidAt: DateTime(2026, 11, 8),
        ),
        MonthlyRecord(
          source: RecordSource.income,
          sourceId: 1,
          month: nov,
          paidAt: DateTime(2026, 11, 5),
        ),
      ],
    );
    expect(summary.paidExpenseCents, 15000);
    expect(summary.pendingExpenseCents, 13900);
    expect(summary.receivedIncomeCents, 300000);
    expect(summary.pendingIncomeCents, 0);
  });

  test('receita inativa some, mas mantém histórico se já foi recebida', () {
    expect(summarize(incomes: [salary(active: false)]).items, isEmpty);

    final withHistory = summarize(
      incomes: [salary(active: false)],
      records: [
        MonthlyRecord(
          source: RecordSource.income,
          sourceId: 1,
          month: nov,
          paidAt: DateTime(2026, 11, 5),
        ),
      ],
    );
    expect(withHistory.incomeCents, 300000);
  });

  test('itens ordenados por data', () {
    final summary = summarize(
      incomes: [salary()],
      fixedExpenses: [fixed(dueDay: 31)],
      invoices: [invoice()],
    );
    expect(summary.items.map((i) => i.date.day), [5, 8, 30]);
  });
}
