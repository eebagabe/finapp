import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/year_month.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/form_fields.dart';
import '../../../summary/domain/monthly_summary.dart';
import '../../data/month_item_actions.dart';

/// Abre as ações de um item do mês.
Future<void> showMonthItemSheet(
  BuildContext context, {
  required MonthItem item,
  required YearMonth month,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _MonthItemSheet(item: item, month: month),
  );
}

class _MonthItemSheet extends ConsumerWidget {
  const _MonthItemSheet({required this.item, required this.month});

  final MonthItem item;
  final YearMonth month;

  String get _paidVerb => item.isIncome ? 'recebido' : 'pago';

  Future<void> _markPaid(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      helpText: 'Data do ${item.isIncome ? 'recebimento' : 'pagamento'}',
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;
    await ref.read(monthItemActionsProvider).setPaid(item, month, date);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _undoPaid(BuildContext context, WidgetRef ref) async {
    await ref.read(monthItemActionsProvider).setPaid(item, month, null);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _adjust(BuildContext context, WidgetRef ref) async {
    final cents = await showDialog<int>(
      context: context,
      builder: (_) => _AdjustAmountDialog(item: item, month: month),
    );
    if (cents == null) return;
    await ref.read(monthItemActionsProvider).adjustAmount(item, month, cents);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _resetAmount(BuildContext context, WidgetRef ref) async {
    await ref.read(monthItemActionsProvider).adjustAmount(item, month, null);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmAction(
      context,
      title: 'Excluir lançamento?',
      message: '"${item.title}" será excluído.',
    );
    if (!confirmed) return;
    await ref.read(monthItemActionsProvider).deleteOneOff(item);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _openSource(BuildContext context) async {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    switch (item.type) {
      case MonthItemType.cardInvoice:
        await router.push(AppRoutes.cardDetail(item.sourceId));
      case MonthItemType.debtInstallment:
        await router.push(AppRoutes.debtDetail(item.parentId!));
      case MonthItemType.income:
        await router.push(AppRoutes.editIncome(item.sourceId));
      case MonthItemType.fixedExpense:
        await router.push(AppRoutes.editFixedExpense(item.sourceId));
      case MonthItemType.oneOffIncome || MonthItemType.oneOffExpense:
        break;
    }
  }

  String? get _openSourceLabel => switch (item.type) {
    MonthItemType.cardInvoice => 'Ver fatura',
    MonthItemType.debtInstallment => 'Ver dívida',
    MonthItemType.income => 'Editar receita fixa',
    MonthItemType.fixedExpense => 'Editar despesa fixa',
    _ => null,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final muted = context.appColors.mutedText;
    final openLabel = _openSourceLabel;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    '${formatCents(item.amountCents)} · '
                    '${formatDate(item.date)}',
                    style: textTheme.bodyMedium?.copyWith(color: muted),
                  ),
                  if (item.isOnCard)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Cobrada no cartão ${item.cardName}: o valor entra na '
                        'fatura e é pago junto com ela.',
                        style: textTheme.bodySmall?.copyWith(color: muted),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (item.isPayable && !item.isPaid)
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text('Marcar como $_paidVerb'),
                subtitle: const Text('Escolher a data'),
                onTap: () => _markPaid(context, ref),
              ),
            if (item.isPayable && item.isPaid)
              ListTile(
                leading: const Icon(Icons.undo),
                title: Text(
                  'Desfazer ($_paidVerb em ${formatDate(item.paidAt!)})',
                ),
                onTap: () => _undoPaid(context, ref),
              ),
            if (item.type.isAdjustable)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Ajustar valor deste mês'),
                subtitle: const Text('O valor padrão não muda'),
                onTap: () => _adjust(context, ref),
              ),
            if (item.isAdjusted)
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: Text(
                  'Voltar ao valor padrão '
                  '(${formatCents(item.defaultAmountCents!)})',
                ),
                onTap: () => _resetAmount(context, ref),
              ),
            if (openLabel != null)
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: Text(openLabel),
                onTap: () => _openSource(context),
              ),
            if (item.type == MonthItemType.oneOffIncome ||
                item.type == MonthItemType.oneOffExpense)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Excluir lançamento'),
                onTap: () => _delete(context, ref),
              ),
          ],
        ),
      ),
    );
  }
}

class _AdjustAmountDialog extends StatefulWidget {
  const _AdjustAmountDialog({required this.item, required this.month});

  final MonthItem item;
  final YearMonth month;

  @override
  State<_AdjustAmountDialog> createState() => _AdjustAmountDialogState();
}

class _AdjustAmountDialogState extends State<_AdjustAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount = TextEditingController(
    text: MoneyField.initialText(widget.item.amountCents),
  );

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.item.title} · ${formatMonthYear(widget.month)}'),
      content: Form(
        key: _formKey,
        child: MoneyField(controller: _amount, label: 'Valor real do mês'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(parseCents(_amount.text));
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
