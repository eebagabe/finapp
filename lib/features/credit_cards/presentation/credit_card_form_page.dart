import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/form_fields.dart';
import '../data/credit_card_repository.dart';
import '../domain/credit_card.dart';

/// Cadastro e edição de cartão. Com [cardId] nulo, cria um novo.
class CreditCardFormPage extends ConsumerWidget {
  const CreditCardFormPage({this.cardId, super.key});

  final int? cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (cardId == null) return const _CreditCardForm();
    return ref
        .watch(creditCardProvider(cardId!))
        .when(
          data: (card) => _CreditCardForm(initial: card),
          loading: () => const Scaffold(body: LoadingView()),
          error: (error, _) => Scaffold(body: ErrorView(error)),
        );
  }
}

class _CreditCardForm extends ConsumerStatefulWidget {
  const _CreditCardForm({this.initial});

  final CreditCard? initial;

  @override
  ConsumerState<_CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends ConsumerState<_CreditCardForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _closingDay;
  late final TextEditingController _dueDay;
  late final TextEditingController _limit;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final card = widget.initial;
    _name = TextEditingController(text: card?.name);
    _closingDay = TextEditingController(text: card?.closingDay.toString());
    _dueDay = TextEditingController(text: card?.dueDay.toString());
    _limit = TextEditingController(
      text: MoneyField.initialText(card?.limitCents),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _closingDay.dispose();
    _dueDay.dispose();
    _limit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final input = CreditCardInput(
      name: _name.text,
      closingDay: int.parse(_closingDay.text),
      dueDay: int.parse(_dueDay.text),
      limitCents: parseCents(_limit.text),
    );
    final repository = ref.read(creditCardRepositoryProvider);
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
      title: 'Excluir cartão?',
      message:
          'Os lançamentos do cartão serão excluídos e as despesas fixas '
          'vinculadas deixarão de estar no cartão.',
    );
    if (!confirmed) return;
    await ref.read(creditCardRepositoryProvider).delete(widget.initial!.id);
    if (mounted) context.go(AppRoutes.cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar cartão' : 'Novo cartão'),
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
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex.: Nubank',
              ),
              textCapitalization: TextCapitalization.words,
              validator: requiredText,
            ),
            const FormGap(),
            IntField(
              controller: _closingDay,
              label: 'Melhor dia de compra',
              helperText:
                  'Compras a partir deste dia entram na fatura seguinte',
              min: 1,
              max: 31,
            ),
            const FormGap(),
            IntField(
              controller: _dueDay,
              label: 'Dia de vencimento',
              min: 1,
              max: 31,
            ),
            const FormGap(),
            MoneyField(
              controller: _limit,
              label: 'Limite (opcional)',
              required: false,
            ),
            const SizedBox(height: 32),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
