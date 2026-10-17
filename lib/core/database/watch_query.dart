import 'package:drift/drift.dart';

extension WatchComputed on GeneratedDatabase {
  /// Executa [load] agora e novamente sempre que alguma das [tables] mudar.
  ///
  /// Útil para consultas que combinam várias tabelas e montam objetos de
  /// domínio em Dart.
  Stream<T> watchComputed<T>(
    Iterable<TableInfo<Table, dynamic>> tables,
    Future<T> Function() load,
  ) async* {
    yield await load();
    yield* tableUpdates(TableUpdateQuery.onAllTables(tables))
        .asyncMap((_) => load());
  }
}
