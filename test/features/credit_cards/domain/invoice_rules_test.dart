import 'package:finapp/core/domain/year_month.dart';
import 'package:finapp/features/credit_cards/domain/invoice_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceRules.invoiceMonthFor — melhor dia 1, vencimento 8', () {
    YearMonth invoice(DateTime date) =>
        InvoiceRules.invoiceMonthFor(date, closingDay: 1, dueDay: 8);

    test('compra antes do melhor dia entra na fatura atual', () {
      expect(invoice(DateTime(2026, 9, 30)), const YearMonth(2026, 10));
    });

    test('compra no melhor dia entra na próxima fatura', () {
      expect(invoice(DateTime(2026, 10, 1)), const YearMonth(2026, 11));
    });

    test(
      'compra depois do melhor dia no mesmo mês entra na próxima fatura',
      () {
        expect(invoice(DateTime(2026, 10, 7)), const YearMonth(2026, 11));
        expect(invoice(DateTime(2026, 10, 31)), const YearMonth(2026, 11));
      },
    );

    test('vira o ano', () {
      expect(invoice(DateTime(2026, 12, 15)), const YearMonth(2027, 1));
    });
  });

  group('InvoiceRules.invoiceMonthFor — melhor dia 15, vencimento 22', () {
    YearMonth invoice(DateTime date) =>
        InvoiceRules.invoiceMonthFor(date, closingDay: 15, dueDay: 22);

    test('dia 14 entra na fatura do mês', () {
      expect(invoice(DateTime(2026, 10, 14)), const YearMonth(2026, 10));
    });

    test('dia 15 em diante entra na fatura do mês seguinte', () {
      expect(invoice(DateTime(2026, 10, 15)), const YearMonth(2026, 11));
      expect(invoice(DateTime(2026, 10, 16)), const YearMonth(2026, 11));
    });
  });

  group('InvoiceRules.invoiceMonthFor — vencimento antes do melhor dia', () {
    YearMonth invoice(DateTime date) =>
        InvoiceRules.invoiceMonthFor(date, closingDay: 25, dueDay: 5);

    test('compra antes do fechamento vence no mês seguinte', () {
      expect(invoice(DateTime(2026, 10, 20)), const YearMonth(2026, 11));
    });

    test('compra no fechamento ou depois vence dois meses à frente', () {
      expect(invoice(DateTime(2026, 10, 25)), const YearMonth(2026, 12));
    });
  });

  group('InvoiceRules.invoiceMonthFor — melhor dia maior que o mês', () {
    test('fechamento 31 em fevereiro vale como último dia', () {
      YearMonth invoice(DateTime date) =>
          InvoiceRules.invoiceMonthFor(date, closingDay: 31, dueDay: 10);
      // 31 > 10, então a fatura vence no mês seguinte ao fechamento.
      expect(invoice(DateTime(2027, 2, 27)), const YearMonth(2027, 3));
      expect(invoice(DateTime(2027, 2, 28)), const YearMonth(2027, 4));
    });
  });

  test('dueDate limita ao último dia do mês', () {
    expect(
      InvoiceRules.dueDate(const YearMonth(2027, 2), dueDay: 30),
      DateTime(2027, 2, 28),
    );
    expect(
      InvoiceRules.dueDate(const YearMonth(2026, 11), dueDay: 8),
      DateTime(2026, 11, 8),
    );
  });

  group('InvoiceRules.distributePurchase', () {
    test('compra parcelada cai em faturas consecutivas', () {
      final parts = InvoiceRules.distributePurchase(
        totalCents: 30000,
        installmentCount: 3,
        purchaseDate: DateTime(2026, 10, 1),
        closingDay: 1,
        dueDay: 8,
      );
      expect(parts, const [
        InvoiceInstallment(
          number: 1,
          invoiceMonth: YearMonth(2026, 11),
          amountCents: 10000,
        ),
        InvoiceInstallment(
          number: 2,
          invoiceMonth: YearMonth(2026, 12),
          amountCents: 10000,
        ),
        InvoiceInstallment(
          number: 3,
          invoiceMonth: YearMonth(2027, 1),
          amountCents: 10000,
        ),
      ]);
    });

    test('à vista gera uma única parcela', () {
      final parts = InvoiceRules.distributePurchase(
        totalCents: 4590,
        installmentCount: 1,
        purchaseDate: DateTime(2026, 9, 30),
        closingDay: 1,
        dueDay: 8,
      );
      expect(parts, const [
        InvoiceInstallment(
          number: 1,
          invoiceMonth: YearMonth(2026, 10),
          amountCents: 4590,
        ),
      ]);
    });

    test('centavos restantes ficam na última parcela', () {
      final parts = InvoiceRules.distributePurchase(
        totalCents: 10000,
        installmentCount: 3,
        purchaseDate: DateTime(2026, 9, 30),
        closingDay: 1,
        dueDay: 8,
      );
      expect(parts.map((p) => p.amountCents), [3333, 3333, 3334]);
    });
  });

  test('distributePurchase respeita a fatura escolhida manualmente', () {
    final parts = InvoiceRules.distributePurchase(
      totalCents: 30000,
      installmentCount: 3,
      purchaseDate: DateTime(2026, 9, 30),
      closingDay: 1,
      dueDay: 8,
      firstInvoiceMonth: const YearMonth(2026, 12),
    );
    expect(parts.map((p) => p.invoiceMonth), const [
      YearMonth(2026, 12),
      YearMonth(2027, 1),
      YearMonth(2027, 2),
    ]);
  });
}
