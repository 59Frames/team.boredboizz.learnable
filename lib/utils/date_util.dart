import 'package:date_format/date_format.dart' as formatter;

String getLongDateString(DateTime date) =>
  date != null
      ? formatter.formatDate(date, [formatter.d, ' ', formatter.M, ' ', formatter.yyyy])
      : "";

String getShortDateString(DateTime date) =>
    date != null
      ? formatter.formatDate(date, [formatter.d, '.', formatter.m, '.', formatter.yyyy])
      : "";
String getNumberedDateString(DateTime date) =>
    date != null
      ? formatter.formatDate(date, [formatter.yyyy, '-', formatter.mm, '-', formatter.dd])
      : "";

String getTimeString(DateTime date) =>
    date != null
      ? formatter.formatDate(date, [formatter.HH, ':', formatter.nn])
      : "";

bool isOnSameDay(DateTime a, DateTime b) =>
    getShortDateString(a) == getShortDateString(b);

bool isOnSameDayShort(String day, DateTime a) =>
    day == getShortDateString(a);

bool isOnSameDayLong(String day, DateTime a) =>
    day == getLongDateString(a);