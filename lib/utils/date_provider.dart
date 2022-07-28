import 'package:intl/intl.dart';

String getDateId(DateTime dateTime) {
  return DateFormat("yyMMdd").format(dateTime);
}
