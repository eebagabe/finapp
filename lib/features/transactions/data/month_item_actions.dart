import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/domain/year_month.dart';
import '../../../core/providers/database_provider.dart';
import '../../debts/data/debt_repository.dart';
import '../../summary/domain/monthly_summary.dart';
import '../domain/entry_types.dart';
import 'monthly_record_repository.dart';
import 'one_off_entry_repository.dart';

/// Ações sobre itens do mês, direcionadas ao repositório certo pelo tipo.
class MonthItemActions {
  MonthItemActions(AppDatabase db)
    : _records = MonthlyRecordRepository(db),
      _debts = DebtRepository(db),
      _oneOffs = OneOffEntryRepository(db);

  final MonthlyRecordRepository _records;
  final DebtRepository _debts;
  final OneOffEntryRepository _oneOffs;

  /// Marca como pago/recebido em [paidAt] ou, com `null`, desfaz.
  ///
  /// Pagar uma parcela de dívida reduz as parcelas restantes da dívida.
  Future<void> setPaid(MonthItem item, YearMonth month, DateTime? paidAt) {
    return switch (item.type) {
      MonthItemType.income => _records.setPaid(
        RecordSource.income,
        item.sourceId,
        month,
        paidAt,
      ),
      MonthItemType.fixedExpense => _records.setPaid(
        RecordSource.fixedExpense,
        item.sourceId,
        month,
        paidAt,
      ),
      MonthItemType.cardInvoice => _records.setPaid(
        RecordSource.cardInvoice,
        item.sourceId,
        month,
        paidAt,
      ),
      MonthItemType.debtInstallment => _debts.setInstallmentPaid(
        item.sourceId,
        paidAt,
      ),
      MonthItemType.oneOffIncome ||
      MonthItemType.oneOffExpense => _oneOffs.setPaid(item.sourceId, paidAt),
    };
  }

  /// Ajusta o valor real de uma receita ou despesa fixa só em [month].
  /// Com `null`, volta ao valor padrão.
  Future<void> adjustAmount(MonthItem item, YearMonth month, int? cents) {
    final source = switch (item.type) {
      MonthItemType.income => RecordSource.income,
      MonthItemType.fixedExpense => RecordSource.fixedExpense,
      _ => throw ArgumentError('Item ${item.type} não permite ajuste'),
    };
    final value = cents == item.defaultAmountCents ? null : cents;
    return _records.setAmountOverride(source, item.sourceId, month, value);
  }

  /// Exclui um lançamento avulso.
  Future<void> deleteOneOff(MonthItem item) {
    if (item.type != MonthItemType.oneOffIncome &&
        item.type != MonthItemType.oneOffExpense) {
      throw ArgumentError('Somente avulsos podem ser excluídos aqui');
    }
    return _oneOffs.delete(item.sourceId);
  }
}

final monthItemActionsProvider = Provider<MonthItemActions>(
  (ref) => MonthItemActions(ref.watch(databaseProvider)),
);
