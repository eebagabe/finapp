import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

/// Instância única do banco. Em testes, sobrescreva com um banco em memória.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
