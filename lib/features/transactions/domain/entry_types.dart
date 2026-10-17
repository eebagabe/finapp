/// Natureza de um lançamento avulso.
enum EntryKind { income, expense }

/// Origem de um registro mensal (ajuste de valor e/ou status de pagamento de
/// um item recorrente em um mês específico).
enum RecordSource {
  /// Receita fixa.
  income,

  /// Despesa fixa.
  fixedExpense,

  /// Fatura de cartão. O valor ajustado é o atalho "valor total da fatura".
  cardInvoice,
}
