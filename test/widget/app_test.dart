import 'package:drift/native.dart';
import 'package:finapp/app.dart';
import 'package:finapp/core/database/app_database.dart';
import 'package:finapp/core/providers/database_provider.dart';
import 'package:finapp/core/utils/date_formatter.dart';
import 'package:finapp/features/fixed_expenses/data/fixed_expense_repository.dart';
import 'package:finapp/features/fixed_expenses/domain/fixed_expense.dart';
import 'package:finapp/features/incomes/data/income_repository.dart';
import 'package:finapp/features/incomes/domain/income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Deixa o banco (assíncrono de verdade) responder e reconstrói a tela.
/// Não usa pumpAndSettle porque o indicador de carregamento anima sem parar.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUpAll(initializeDateFormats);

  Future<AppDatabase> pumpApp(WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() async {
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
          description: 'Aluguel',
          defaultAmountCents: 450000,
          dueDay: 10,
          active: true,
        ),
      );
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const FinApp(),
      ),
    );
    await settle(tester);
    return db;
  }

  Future<void> dispose(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
    await tester.runAsync(db.close);
  }

  testWidgets('resumo mostra quanto falta conseguir', (tester) async {
    final db = await pumpApp(tester);

    expect(find.text('Falta conseguir'), findsOneWidget);
    expect(find.text(r'R$ 1.500,00'), findsOneWidget);
    expect(find.text('Aluguel'), findsOneWidget);

    await dispose(tester, db);
  });

  testWidgets('navega pelas abas', (tester) async {
    final db = await pumpApp(tester);

    await tester.tap(find.text('Dívidas'));
    await settle(tester);
    expect(find.text('Nenhuma dívida cadastrada.'), findsOneWidget);

    await tester.tap(find.text('Cartões'));
    await settle(tester);
    expect(find.text('Nenhum cartão cadastrado.'), findsOneWidget);

    await dispose(tester, db);
  });

  testWidgets('lançamento marcado como fixo vira despesa fixa', (tester) async {
    final db = await pumpApp(tester);

    await tester.tap(find.text('Lançamentos'));
    await settle(tester);
    await tester.tap(find.byTooltip('Novo lançamento'));
    await settle(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Descrição'),
      'Internet',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor'), '9990');
    await tester.tap(find.text('Despesa fixa'));
    await settle(tester);
    await tester.ensureVisible(find.text('Salvar'));
    await settle(tester);
    await tester.tap(find.text('Salvar'));
    await settle(tester);

    final expenses = await tester.runAsync(
      () => FixedExpenseRepository(db).getAll(),
    );
    final internet = expenses!.singleWhere((e) => e.description == 'Internet');
    expect(internet.defaultAmountCents, 9990);
    expect(internet.dueDay, DateTime.now().day);

    await dispose(tester, db);
  });
}
