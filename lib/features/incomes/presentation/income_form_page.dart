import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../data/income_repository.dart';
import '../domain/income.dart';

/// Cadastro e edição de receita fixa. Com [incomeId] nulo, cria uma nova.
class IncomeFormPage extends ConsumerWidget {
  const IncomeFormPage({this.incomeId, super.key});

  final int? incomeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (incomeId == null) return const _IncomeForm();
    return ref
        .watch(incomeProvider(incomeId!))
        .when(
          data: (income) => _IncomeForm(initial: income),
          loading: () => const Scaffold(body: LoadingView()),
          error: (error, _) => Scaffold(body: ErrorView(error)),
        );
  }
}

class _IncomeForm extends ConsumerStatefulWidget {
  const _IncomeForm({this.initial});

  final Income? initial;

  @override
  ConsumerState<_IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends ConsumerState<_IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _description;
  late final TextEditingController _amount;
  late final TextEditingController _day;
  late bool _active;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final income = widget.initial;
    _description = TextEditingController(text: income?.description);
    _amount = TextEditingController(
      text: MoneyField.initialText(income?.amountCents),
    );
    _day = TextEditingController(text: income?.dayOfMonth.toString());
    _active = income?.active ?? true;
  }

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _day.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final input = IncomeInput(
      description: _description.text,
      amountCents: parseCents(_amount.text)!,
      dayOfMonth: int.parse(_day.text),
      active: _active,
    );
    final repository = ref.read(incomeRepositoryProvider);
    if (_isEditing) {
      await repository.update(widget.initial!.id, input);
    } else {
      await repository.create(input);
    }
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await confirmAction(
      context,
      title: 'Excluir receita?',
      message: 'Para manter o histórico, prefira marcar como inativa.',
    );
    if (!confirmed) return;
    await ref.read(incomeRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar receita' : 'Nova receita fixa'),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Excluir',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          children: [
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex.: Salário',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: requiredText,
            ),
            const FormGap(),
            MoneyField(controller: _amount, label: 'Valor'),
            const FormGap(),
            IntField(
              controller: _day,
              label: 'Dia do recebimento',
              min: 1,
              max: 31,
            ),
            const FormGap(),
            SwitchListTile(
              title: const Text('Ativa'),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
