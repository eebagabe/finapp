import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/currency_input_formatter.dart';
import '../utils/date_formatter.dart';
import '../utils/money_formatter.dart';

/// Campo de valor com máscara `R$ 1.234,56`.
///
/// Use [parseCents] no texto do [controller] para obter os centavos.
class MoneyField extends StatelessWidget {
  const MoneyField({
    required this.controller,
    required this.label,
    this.required = true,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final ValueChanged<int?>? onChanged;

  /// Máscara de valor, para campos de dinheiro montados fora deste widget.
  static const formatters = [CurrencyInputFormatter()];

  /// Texto inicial do campo para um valor em centavos.
  static String initialText(int? cents) =>
      cents == null || cents == 0 ? '' : formatCents(cents);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: r'R$ 0,00'),
      keyboardType: TextInputType.number,
      inputFormatters: formatters,
      onChanged: onChanged == null
          ? null
          : (text) => onChanged!(parseCents(text)),
      validator: (text) {
        final cents = parseCents(text ?? '');
        if (cents == null || cents == 0) {
          return required ? 'Informe um valor' : null;
        }
        return null;
      },
    );
  }
}

/// Campo numérico inteiro com limites, ex.: dia do mês ou nº de parcelas.
class IntField extends StatelessWidget {
  const IntField({
    required this.controller,
    required this.label,
    required this.min,
    required this.max,
    this.required = true,
    this.helperText,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final int min;
  final int max;
  final bool required;
  final String? helperText;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, helperText: helperText),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged == null
          ? null
          : (text) => onChanged!(int.tryParse(text)),
      validator: (text) {
        final value = int.tryParse(text ?? '');
        if (value == null) return required ? 'Obrigatório' : null;
        if (value < min || value > max) return 'Entre $min e $max';
        return null;
      },
    );
  }
}

/// Campo de data que abre o seletor de data ao tocar.
class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.helperText,
    this.errorText,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helperText;
  final String? errorText;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final first = firstDate ?? DateTime(now.year - 5);
    final last = lastDate ?? DateTime(now.year + 30);
    final initial = value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first)
          ? first
          : initial.isAfter(last)
          ? last
          : initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          errorText: errorText,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
        ),
        isEmpty: value == null,
        child: Text(value == null ? '' : formatDate(value!)),
      ),
    );
  }
}

/// Espaçamento vertical padrão entre campos de formulário.
class FormGap extends StatelessWidget {
  const FormGap({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(height: 16);
}

/// Valida que um texto não está vazio.
String? requiredText(String? text) =>
    (text == null || text.trim().isEmpty) ? 'Obrigatório' : null;
