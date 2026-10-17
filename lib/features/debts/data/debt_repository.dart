import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/watch_query.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/debt.dart';
import '../domain/debt_schedule.dart';

class DebtRepository {
  DebtRepository(this._db);

  final AppDatabase _db;

  Stream<List<Debt>> watchAll() =>
      _db.watchComputed([_db.debts, _db.debtInstallments], getAll);

  Stream<Debt?> watchById(int id) =>
      _db.watchComputed([_db.debts, _db.debtInstallments], () => getById(id));

  Future<List<Debt>> getAll() async {
    final debts = await (_db.select(
      _db.debts,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    final installments = await _db.select(_db.debtInstallments).get();
    final byDebt = <int, List<DebtInstallmentRow>>{};
    for (final row in installments) {
      byDebt.putIfAbsent(row.debtId, () => []).add(row);
    }
    return [for (final row in debts) _toDomain(row, byDebt[row.id] ?? [])];
  }

  Future<Debt?> getById(int id) async {
    final row = await (_db.select(
      _db.debts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final installments = await (_db.select(
      _db.debtInstallments,
    )..where((t) => t.debtId.equals(id))).get();
    return _toDomain(row, installments);
  }

  /// Cria a dívida e gera uma parcela por mês.
  Future<int> create(DebtDraft draft) {
    return _db.transaction(() async {
      final totalCents = draft.valueMode == DebtValueMode.total
          ? draft.amountCents
          : null;
      final debtId = await _db
          .into(_db.debts)
          .insert(
            DebtsCompanion.insert(
              description: draft.description.trim(),
              valueMode: draft.valueMode,
              totalCents: Value(totalCents),
            ),
          );
      await _insertPlan(debtId, draft.plan());
      return debtId;
    });
  }

  /// Atualiza a dívida e regera apenas as parcelas não pagas.
  Future<void> update(int id, DebtDraft draft) {
    return _db.transaction(() async {
      final current = await getById(id);
      if (current == null) return;

      final paid = current.installments.where((i) => i.isPaid).toList();
      final lastPaidNumber = paid.isEmpty ? 0 : paid.last.number;
      final totalCents = draft.valueMode == DebtValueMode.total
          ? current.paidCents + draft.amountCents
          : null;

      await (_db.update(_db.debts)..where((t) => t.id.equals(id))).write(
        DebtsCompanion(
          description: Value(draft.description.trim()),
          valueMode: Value(draft.valueMode),
          totalCents: Value(totalCents),
        ),
      );
      await (_db.delete(
        _db.debtInstallments,
      )..where((t) => t.debtId.equals(id) & t.paidAt.isNull())).go();
      await _insertPlan(id, draft.plan(firstNumber: lastPaidNumber + 1));
      await _renumber(id);
    });
  }

  /// Renumera as parcelas pela data prevista (antecipadas mantêm a posição
  /// do vencimento original).
  Future<void> _renumber(int debtId) async {
    final debt = await getById(debtId);
    if (debt == null) return;
    final ordered = [...debt.installments]
      ..sort((a, b) {
        final byDate = a.scheduledDate.compareTo(b.scheduledDate);
        return byDate != 0 ? byDate : a.id.compareTo(b.id);
      });
    for (final (index, installment) in ordered.indexed) {
      if (installment.number == index + 1) continue;
      await (_db.update(_db.debtInstallments)
            ..where((t) => t.id.equals(installment.id)))
          .write(DebtInstallmentsCompanion(number: Value(index + 1)));
    }
  }

  /// Antecipa o pagamento das parcelas [installmentIds] em [paidAt], pagando
  /// [paidCents] no total (menos que a soma = desconto).
  ///
  /// Cada parcela passa a valer sua parte do valor pago, com vencimento na
  /// data do pagamento; o valor e o vencimento originais ficam guardados para
  /// desfazer.
  Future<void> prepay({
    required List<int> installmentIds,
    required int paidCents,
    required DateTime paidAt,
  }) {
    return _db.transaction(() async {
      final rows =
          await (_db.select(_db.debtInstallments)
                ..where((t) => t.id.isIn(installmentIds) & t.paidAt.isNull())
                ..orderBy([(t) => OrderingTerm.asc(t.number)]))
              .get();
      final shares = distributePrepayment([
        for (final row in rows) row.amountCents,
      ], paidCents);
      for (final (index, row) in rows.indexed) {
        final discount = row.amountCents - shares[index];
        await (_db.update(
          _db.debtInstallments,
        )..where((t) => t.id.equals(row.id))).write(
          DebtInstallmentsCompanion(
            amountCents: Value(shares[index]),
            discountCents: Value(discount == 0 ? null : discount),
            originalDueDate: Value(row.dueDate),
            dueDate: Value(dateOnly(paidAt)),
            paidAt: Value(paidAt),
          ),
        );
      }
    });
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.debts)..where((t) => t.id.equals(id))).go();
  }

  /// Marca a parcela como paga em [paidAt] ou, se nulo, desfaz o pagamento.
  ///
  /// Desfazer uma antecipação restaura o valor e o vencimento originais.
  Future<void> setInstallmentPaid(int installmentId, DateTime? paidAt) {
    return _db.transaction(() async {
      final query = _db.select(_db.debtInstallments)
        ..where((t) => t.id.equals(installmentId));
      final row = await query.getSingleOrNull();
      if (row == null) return;
      final restore = paidAt == null && row.originalDueDate != null;
      await (_db.update(
        _db.debtInstallments,
      )..where((t) => t.id.equals(installmentId))).write(
        restore
            ? DebtInstallmentsCompanion(
                paidAt: const Value(null),
                amountCents: Value(row.amountCents + (row.discountCents ?? 0)),
                dueDate: Value(row.originalDueDate!),
                discountCents: const Value(null),
                originalDueDate: const Value(null),
              )
            : DebtInstallmentsCompanion(paidAt: Value(paidAt)),
      );
    });
  }

  Future<void> _insertPlan(int debtId, List<PlannedInstallment> plan) async {
    await _db.batch((batch) {
      batch.insertAll(_db.debtInstallments, [
        for (final p in plan)
          DebtInstallmentsCompanion.insert(
            debtId: debtId,
            number: p.number,
            dueDate: p.dueDate,
            amountCents: p.amountCents,
          ),
      ]);
    });
  }

  static Debt _toDomain(DebtRow row, List<DebtInstallmentRow> installments) =>
      Debt(
        id: row.id,
        description: row.description,
        valueMode: row.valueMode,
        totalCents: row.totalCents,
        installments: installments.map(_installmentToDomain).toList(),
      );

  static DebtInstallment _installmentToDomain(DebtInstallmentRow row) =>
      DebtInstallment(
        id: row.id,
        debtId: row.debtId,
        number: row.number,
        dueDate: row.dueDate,
        amountCents: row.amountCents,
        paidAt: row.paidAt,
        discountCents: row.discountCents,
        originalDueDate: row.originalDueDate,
      );
}

final debtRepositoryProvider = Provider<DebtRepository>(
  (ref) => DebtRepository(ref.watch(databaseProvider)),
);

final debtsProvider = StreamProvider<List<Debt>>(
  (ref) => ref.watch(debtRepositoryProvider).watchAll(),
);

final debtProvider = StreamProvider.family<Debt?, int>(
  (ref, id) => ref.watch(debtRepositoryProvider).watchById(id),
);
