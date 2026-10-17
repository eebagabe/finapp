import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

/// Preferências do app guardadas no banco.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  static const _themeModeKey = 'theme_mode';

  Stream<ThemeMode> watchThemeMode() {
    final query = _db.select(_db.appSettings)
      ..where((t) => t.key.equals(_themeModeKey));
    return query.watchSingleOrNull().map(
      (row) => ThemeMode.values.asNameMap()[row?.value] ?? ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: _themeModeKey, value: mode.name),
      );

  /// Apaga todos os dados cadastrados. Ver [AppDatabase.resetAllData].
  Future<void> resetAllData() => _db.resetAllData();
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final themeModeProvider = StreamProvider<ThemeMode>(
  (ref) => ref.watch(settingsRepositoryProvider).watchThemeMode(),
);
