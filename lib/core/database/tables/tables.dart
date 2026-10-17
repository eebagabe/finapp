import 'package:drift/drift.dart';

import '../../../features/debts/domain/debt_schedule.dart';
import '../../../features/transactions/domain/entry_types.dart';

/// Valores monetários são sempre armazenados em centavos (`int`).
/// Meses de referência são armazenados como `yyyymm` (ver `YearMonth.key`).

@DataClassName('CreditCardRow')
class CreditCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// Melhor dia de compra (dia de fechamento).
  IntColumn get closingDay => integer()();
  IntColumn get dueDay => integer()();
  IntColumn get limitCents => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Receitas fixas (mensais). Receitas avulsas ficam em [OneOffEntries].
@DataClassName('IncomeRow')
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 1, max: 120)();
  IntColumn get amountCents => integer()();
  IntColumn get dayOfMonth => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  /// Primeiro mês (`yyyymm`) em que a receita vale.
  IntColumn get startMonth => integer()();
}

@DataClassName('FixedExpenseRow')
class FixedExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 1, max: 120)();
  IntColumn get defaultAmountCents => integer()();
  IntColumn get dueDay => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  /// Quando preenchido, a despesa entra na fatura deste cartão.
  IntColumn get creditCardId => integer().nullable().references(
    CreditCards,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// Primeiro mês (`yyyymm`) em que a despesa vale.
  IntColumn get startMonth => integer()();
}

@DataClassName('DebtRow')
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 1, max: 120)();
  TextColumn get valueMode => textEnum<DebtValueMode>()();

  /// Total informado no modo [DebtValueMode.total].
  IntColumn get totalCents => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@TableIndex(name: 'idx_debt_installments_due_date', columns: {#dueDate})
@DataClassName('DebtInstallmentRow')
class DebtInstallments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get debtId =>
      integer().references(Debts, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get paidAt => dateTime().nullable()();
}

@DataClassName('CardPurchaseRow')
class CardPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId =>
      integer().references(CreditCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get description => text().withLength(min: 1, max: 120)();
  IntColumn get totalCents => integer()();
  DateTimeColumn get purchaseDate => dateTime()();

  /// 1 = à vista.
  IntColumn get installmentCount => integer()();
}

@TableIndex(
  name: 'idx_card_purchase_installments_invoice_month',
  columns: {#invoiceMonth},
)
@DataClassName('CardPurchaseInstallmentRow')
class CardPurchaseInstallments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId =>
      integer().references(CardPurchases, #id, onDelete: KeyAction.cascade)();
  IntColumn get number => integer()();

  /// Mês de vencimento da fatura (`yyyymm`).
  IntColumn get invoiceMonth => integer()();
  IntColumn get amountCents => integer()();
}

/// Receitas e despesas avulsas, fora do cartão.
@TableIndex(name: 'idx_one_off_entries_date', columns: {#date})
@DataClassName('OneOffEntryRow')
class OneOffEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<EntryKind>()();
  TextColumn get description => text().withLength(min: 1, max: 120)();
  IntColumn get amountCents => integer()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get paidAt => dateTime().nullable()();
}

/// Ajustes e status mensais de itens recorrentes (receitas fixas, despesas
/// fixas e faturas). Os itens recorrentes não são gerados mês a mês; só o que
/// muda em um mês é registrado aqui.
@TableIndex(name: 'idx_monthly_records_month', columns: {#month})
@DataClassName('MonthlyRecordRow')
class MonthlyRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceType => textEnum<RecordSource>()();

  /// Id da receita, despesa fixa ou cartão, conforme [sourceType].
  IntColumn get sourceId => integer()();
  IntColumn get month => integer()();

  /// Valor real do mês. Para faturas, é o "valor total da fatura".
  IntColumn get amountOverrideCents => integer().nullable()();
  DateTimeColumn get paidAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sourceType, sourceId, month},
  ];
}
