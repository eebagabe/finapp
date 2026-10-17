import 'entry_types.dart';

/// Receita ou despesa avulsa, fora do cartão (ex.: "Exame", R$ 300 à vista).
class OneOffEntry {
  const OneOffEntry({
    required this.id,
    required this.kind,
    required this.description,
    required this.amountCents,
    required this.date,
    this.paidAt,
    this.categoryId,
  });

  final int id;
  final EntryKind kind;
  final String description;
  final int amountCents;
  final DateTime date;

  /// Data em que foi paga (despesa) ou recebida (receita).
  final DateTime? paidAt;
  final int? categoryId;
}

class OneOffEntryDraft {
  const OneOffEntryDraft({
    required this.kind,
    required this.description,
    required this.amountCents,
    required this.date,
    this.categoryId,
  });

  final EntryKind kind;
  final String description;
  final int amountCents;
  final DateTime date;
  final int? categoryId;
}
