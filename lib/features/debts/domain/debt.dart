import 'debt_schedule.dart';

class DebtInstallment {
  const DebtInstallment({
    required this.id,
    required this.debtId,
    required this.number,
    required this.dueDate,
    required this.amountCents,
    this.paidAt,
    this.discountCents,
    this.originalDueDate,
  });

  final int id;
  final int debtId;
  final int number;

  /// Vencimento. Em parcelas antecipadas, é a data do pagamento.
  final DateTime dueDate;

  /// Valor da parcela. Em parcelas antecipadas, é o valor efetivamente pago.
  final int amountCents;
  final DateTime? paidAt;

  /// Desconto obtido na antecipação.
  final int? discountCents;

  /// Vencimento original de uma parcela antecipada.
  final DateTime? originalDueDate;

  bool get isPaid => paidAt != null;

  bool get isAnticipated => originalDueDate != null;

  /// Vencimento previsto no plano original da dívida.
  DateTime get scheduledDate => originalDueDate ?? dueDate;
}

/// Dívida parcelada. As parcelas restantes são as parcelas não pagas.
class Debt {
  Debt({
    required this.id,
    required this.description,
    required this.valueMode,
    required List<DebtInstallment> installments,
    this.totalCents,
  }) : installments = List.unmodifiable(
         <DebtInstallment>[...installments]
           ..sort((a, b) => a.number.compareTo(b.number)),
       );

  final int id;
  final String description;
  final DebtValueMode valueMode;
  final int? totalCents;

  /// Parcelas ordenadas pelo número.
  final List<DebtInstallment> installments;

  List<DebtInstallment> get pendingInstallments =>
      installments.where((i) => !i.isPaid).toList();

  int get paidCount => installments.where((i) => i.isPaid).length;

  int get remainingCount => installments.length - paidCount;

  bool get isSettled => installments.isNotEmpty && remainingCount == 0;

  /// Soma das parcelas ainda não pagas.
  int get remainingCents =>
      pendingInstallments.fold(0, (sum, i) => sum + i.amountCents);

  int get paidCents => installments
      .where((i) => i.isPaid)
      .fold(0, (sum, i) => sum + i.amountCents);

  /// Próxima parcela a pagar (a pendente de menor número).
  DebtInstallment? get nextInstallment {
    final pending = pendingInstallments;
    return pending.isEmpty ? null : pending.first;
  }

  /// Valor de referência da parcela: a próxima pendente ou, se quitada, a
  /// primeira.
  int get installmentAmountCents =>
      (nextInstallment ?? installments.firstOrNull)?.amountCents ?? 0;

  /// Total economizado com descontos em antecipações.
  int get discountCents =>
      installments.fold(0, (sum, i) => sum + (i.discountCents ?? 0));

  /// Data da última parcela (data de quitação).
  DateTime? get payoffDate => installments.isEmpty
      ? null
      : installments
            .map((i) => i.dueDate)
            .reduce((a, b) => a.isAfter(b) ? a : b);
}

/// Divide o valor pago numa antecipação entre as parcelas, proporcional ao
/// valor original de cada uma. Centavos restantes vão para a última.
///
/// Parcelas de R$ 100 e R$ 100 pagas por R$ 150 → R$ 75 e R$ 75.
List<int> distributePrepayment(List<int> originalCents, int paidCents) {
  final total = originalCents.fold(0, (a, b) => a + b);
  if (total == 0) return List.filled(originalCents.length, 0);
  final shares = <int>[
    for (final cents in originalCents) cents * paidCents ~/ total,
  ];
  shares.last += paidCents - shares.fold(0, (a, b) => a + b);
  return shares;
}

/// Dados do formulário de dívida.
///
/// Na criação, [amountCents] é o valor da parcela ou o total (conforme
/// [valueMode]). Na edição em modo total, é o total **restante**, dividido
/// entre as parcelas restantes.
class DebtDraft {
  const DebtDraft({
    required this.description,
    required this.valueMode,
    required this.amountCents,
    required this.nextPaymentDate,
    required this.remainingCount,
  });

  final String description;
  final DebtValueMode valueMode;
  final int amountCents;
  final DateTime nextPaymentDate;
  final int remainingCount;

  /// Parcelas pendentes a gerar, numeradas a partir de [firstNumber].
  List<PlannedInstallment> plan({int firstNumber = 1}) => planDebtInstallments(
    mode: valueMode,
    amountCents: amountCents,
    count: remainingCount,
    firstDueDate: nextPaymentDate,
    firstNumber: firstNumber,
  );
}
