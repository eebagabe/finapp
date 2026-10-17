import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../domain/year_month.dart';

const String _locale = 'pt_BR';

/// Carrega os nomes de meses/dias em pt_BR. Chamar uma vez no `main`.
Future<void> initializeDateFormats() => initializeDateFormatting(_locale);

/// `21/11/2026`
String formatDate(DateTime date) =>
    DateFormat('dd/MM/yyyy', _locale).format(date);

/// `21/11`
String formatDayMonth(DateTime date) =>
    DateFormat('dd/MM', _locale).format(date);

/// `7 de novembro`
String formatDayMonthName(DateTime date) =>
    DateFormat("d 'de' MMMM", _locale).format(date);

/// `Novembro de 2026`
String formatMonthYear(YearMonth month) {
  final text = DateFormat("MMMM 'de' y", _locale).format(month.firstDay);
  return text[0].toUpperCase() + text.substring(1);
}

/// `nov/26`
String formatShortMonthYear(YearMonth month) =>
    DateFormat('MMM/yy', _locale).format(month.firstDay).replaceAll('.', '');
