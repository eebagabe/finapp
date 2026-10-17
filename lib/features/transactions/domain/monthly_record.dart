import '../../../core/domain/year_month.dart';
import 'entry_types.dart';

/// Ajuste de valor e/ou status de pagamento de um item recorrente em um mês.
class MonthlyRecord {
  const MonthlyRecord({
    required this.source,
    required this.sourceId,
    required this.month,
    this.amountOverrideCents,
    this.paidAt,
  });

  final RecordSource source;
  final int sourceId;
  final YearMonth month;

  /// Valor real do mês, quando diferente do padrão. Em faturas, é o "valor
  /// total da fatura" informado manualmente.
  final int? amountOverrideCents;
  final DateTime? paidAt;
}

/// Índice de [MonthlyRecord] por origem, id e mês.
class MonthlyRecordIndex {
  MonthlyRecordIndex(Iterable<MonthlyRecord> records)
    : _records = {
        for (final r in records) _key(r.source, r.sourceId, r.month): r,
      };

  const MonthlyRecordIndex.empty() : _records = const {};

  final Map<String, MonthlyRecord> _records;

  static String _key(RecordSource source, int id, YearMonth month) =>
      '${source.name}:$id:${month.key}';

  MonthlyRecord? find(RecordSource source, int id, YearMonth month) =>
      _records[_key(source, id, month)];
}
