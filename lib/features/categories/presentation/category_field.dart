import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_repository.dart';

/// Seleção opcional de categoria nos formulários de lançamento.
class CategoryField extends ConsumerWidget {
  const CategoryField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final known = categories.any((c) => c.id == value);
    return DropdownButtonFormField<int?>(
      // A chave recria o campo quando as categorias carregam.
      key: ValueKey(known),
      initialValue: known ? value : null,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        prefixIcon: Icon(Icons.label_outline),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Sem categoria')),
        for (final category in categories)
          DropdownMenuItem(value: category.id, child: Text(category.name)),
      ],
      onChanged: onChanged,
    );
  }
}
