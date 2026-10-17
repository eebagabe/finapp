import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';

/// Lista de categorias: adicionar, renomear e excluir.
class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final name = await _askName(context, title: 'Nova categoria');
    if (name == null) return;
    await ref.read(categoryRepositoryProvider).create(name);
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final name = await _askName(
      context,
      title: 'Renomear categoria',
      initial: category.name,
    );
    if (name == null) return;
    await ref.read(categoryRepositoryProvider).rename(category.id, name);
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final confirmed = await confirmAction(
      context,
      title: 'Excluir "${category.name}"?',
      message: 'Os lançamentos com esta categoria ficarão sem categoria.',
    );
    if (!confirmed) return;
    await ref.read(categoryRepositoryProvider).delete(category.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova categoria',
        onPressed: () => _create(context, ref),
        child: const Icon(Icons.add),
      ),
      body: ref
          .watch(categoriesProvider)
          .when(
            data: (categories) => categories.isEmpty
                ? const EmptyState(
                    icon: Icons.label_outline,
                    message: 'Nenhuma categoria.',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    children: [
                      AppCard(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            for (final category in categories)
                              ListTile(
                                leading: const Icon(Icons.label_outline),
                                title: Text(category.name),
                                onTap: () => _edit(context, ref, category),
                                trailing: IconButton(
                                  tooltip: 'Excluir',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      _delete(context, ref, category),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(error),
          ),
    );
  }
}

Future<String?> _askName(
  BuildContext context, {
  required String title,
  String? initial,
}) => showDialog<String>(
  context: context,
  builder: (_) => _NameDialog(title: title, initial: initial),
);

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.title, this.initial});

  final String title;
  final String? initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_name.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _name,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(labelText: 'Nome'),
          textCapitalization: TextCapitalization.sentences,
          validator: requiredText,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: _submit,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
