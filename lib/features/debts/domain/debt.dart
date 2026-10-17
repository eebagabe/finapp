import 'debt_schedule.dart';

class DebtInstallment {
  const DebtInstallment({
    required this.id,
    required this.debtId,
    required this.number,
    required this.dueDate,
    required this.amountCents,
    this.paidAt,
  });

  final int id;
  final int debtId;
  final int number;
  final DateTime dueDate;
  final int amountCents;
  final DateTime? paidAt;

  bool get isPaid => paidAt != null;
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

  /// Data da última parcela (data de quitação).
  DateTime? get payoffDate => installments.lastOrNull?.dueDate;
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
