import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../domain/category.dart';

class CategoryRepository {
  CategoryRepository(this._db);

  final AppDatabase _db;

  Stream<List<Category>> watchAll() {
    final query = _db.select(_db.categories)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<Category>> getAll() async {
    final rows = await _db.select(_db.categories).get();
    return rows.map(_toDomain).toList();
  }

  Future<int> create(String name) => _db
      .into(_db.categories)
      .insert(CategoriesCompanion.insert(name: name.trim()));

  Future<void> rename(int id, String name) async {
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(name: Value(name.trim())),
    );
  }

  /// Exclui a categoria. Lançamentos que a usavam ficam sem categoria.
  Future<void> delete(int id) async {
    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();
  }

  static Category _toDomain(CategoryRow row) =>
      Category(id: row.id, name: row.name);
}

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(databaseProvider)),
);

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);
