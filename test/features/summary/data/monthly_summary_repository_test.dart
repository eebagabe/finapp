import 'package:drift/native.dart';
import 'package:finapp/core/database/app_database.dart';
import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/credit_cards/data/card_purchase_repository.dart';
import 'package:finapp/features/credit_cards/data/credit_card_repository.dart';
import 'package:finapp/features/credit_cards/domain/card_purchase.dart';
import 'package:finapp/features/credit_cards/domain/credit_card.dart';
import 'package:finapp/features/debts/data/debt_repository.dart';
import 'package:finapp/features/debts/domain/debt.dart';
import 'package:finapp/features/debts/domain/debt_schedule.dart';
import 'package:finapp/features/fixed_expenses/data/fixed_expense_repository.dart';
import 'package:finapp/features/fixed_expenses/domain/fixed_expense.dart';
import 'package:finapp/features/incomes/data/income_repository.dart';
import 'package:finapp/features/incomes/domain/income.dart';
import 'package:finapp/features/settings/data/settings_repository.dart';
import 'package:finapp/features/summary/data/monthly_summary_repository.dart';
import 'package:finapp/features/summary/domain/monthly_summary.dart';
import 'package:finapp/features/transactions/data/month_item_actions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late MonthlySummaryRepository summaries;
  late MonthItemActions actions;
  final month = YearMonth.now();

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    summaries = MonthlySummaryRepository(db);
    actions = MonthItemActions(db);

    await IncomeRepository(db).create(
      const IncomeInput(
        description: 'Salário',
        amountCents: 300000,
        dayOfMonth: 5,
        active: true,
      ),
    );
    await FixedExpenseRepository(db).create(
      const FixedExpenseInput(
        description: 'Energia',
        defaultAmountCents: 15000,
        dueDay: 8,
        active: true,
      ),
    );
    await DebtRepository(db).create(
      DebtDraft(
        description: 'Acordo',
        valueMode: DebtValueMode.installment,
        amountCents: 50000,
        nextPaymentDate: month.dateAt(21),
        remainingCount: 3,
      ),
    );
  });
  tearDown(() => db.close());

  test('monta o resumo do mês com dados do banco', () async {
    final summary = await summaries.load(month);
    expect(summary.incomeCents, 300000);
    expect(summary.expenseCents, 15000 + 50000);
  });

  test('ajustar valor do mês não altera o padrão', () async {
    final energy = (await summaries.load(month))
        .ofType(MonthItemType.fixedExpense)
        .single;

    await actions.adjustAmount(energy, month, 16200);

    expect((await summaries.load(month)).expenseCents, 16200 + 50000);
    expect((await summaries.load(month.next)).expenseCents, 15000 + 50000);
  });

  test('pagar parcela pelo resumo atualiza a dívida', () async {
    final installment = (await summaries.load(month))
        .ofType(MonthItemType.debtInstallment)
        .single;

    await actions.setPaid(installment, month, DateTime.now());

    final debt = (await DebtRepository(db).getAll()).single;
    expect(debt.remainingCount, 2);
    expect((await summaries.load(month)).paidExpenseCents, 50000);
  });

  test('despesa fixa no cartão soma só via fatura', () async {
    final cardId = await CreditCardRepository(
      db,
    ).create(const CreditCardInput(name: 'Nubank', closingDay: 1, dueDay: 8));
    await FixedExpenseRepository(db).create(
      FixedExpenseInput(
        description: 'Streaming',
        defaultAmountCents: 3990,
        dueDay: 10,
        active: true,
        creditCardId: cardId,
      ),
    );
    await CardPurchaseRepository(db).create(
      CardPurchaseDraft(
        cardId: cardId,
        description: 'Mercado',
        totalCents: 20000,
        purchaseDate: month.previous.dateAt(15),
        installmentCount: 1,
      ),
    );

    // Streaming cobrado dia 10 deste mês cai na fatura do mês que vem.
    final current = await summaries.load(month);
    expect(current.ofType(MonthItemType.cardInvoice).single.amountCents, 20000);
    expect(current.expenseCents, 15000 + 50000 + 20000);

    final next = await summaries.load(month.next);
    expect(next.ofType(MonthItemType.cardInvoice).single.amountCents, 3990);
  });

  group('saldo previsto', () {
    test('sem saldo em conta informado não projeta', () async {
      expect(await summaries.loadProjection(month, current: month), isNull);
    });

    test('soma o saldo em conta aos pendentes, acumulando os meses', () async {
      final settings = SettingsRepository(db);
      await settings.setBankBalance(100000);

      final now = await summaries.loadProjection(month, current: month);
      expect(now!.bankBalanceCents, 100000);
      expect(now.projectedCents, 100000 + 300000 - 15000 - 50000);

      final next = await summaries.loadProjection(month.next, current: month);
      expect(next!.projectedCents, now.projectedCents + 300000 - 65000);

      expect(
        await summaries.loadProjection(month.previous, current: month),
        isNull,
      );
    });

    test('itens pagos já saíram do saldo em conta', () async {
      await SettingsRepository(db).setBankBalance(-20000);
      final installment = (await summaries.load(month))
          .ofType(MonthItemType.debtInstallment)
          .single;
      await actions.setPaid(installment, month, DateTime.now());

      final projection = await summaries.loadProjection(month, current: month);
      expect(projection!.projectedCents, -20000 + 300000 - 15000);
    });

    test('zerar sistema apaga o saldo em conta', () async {
      final settings = SettingsRepository(db);
      await settings.setBankBalance(100000);
      await settings.resetAllData();
      expect(await settings.getBankBalance(), isNull);
    });
  });
}
