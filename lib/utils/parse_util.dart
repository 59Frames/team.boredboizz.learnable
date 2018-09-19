import 'package:date_format/date_format.dart' as formatter;

String getLongDateString(DateTime date) => formatter.formatDate(date, [formatter.d, ' ', formatter.M, ' ', formatter.yyyy]);
String getShortDateString(DateTime date) => formatter.formatDate(date, [formatter.d, ' ', formatter.m, ' ', formatter.yyyy]);
String getNumberedDateString(DateTime date) => formatter.formatDate(date, [formatter.yyyy, '-', formatter.mm, '-', formatter.dd]);
String getTimeString(DateTime date) => formatter.formatDate(date, [formatter.HH, ':', formatter.nn]);