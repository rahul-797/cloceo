import 'package:table_calendar/table_calendar.dart';

StartingDayOfWeek startDayProvider(String startDay) {
  if (startDay == "monday") {
    return StartingDayOfWeek.monday;
  } else if (startDay == "tuesday") {
    return StartingDayOfWeek.tuesday;
  } else if (startDay == "wednesday") {
    return StartingDayOfWeek.wednesday;
  } else if (startDay == "thursday") {
    return StartingDayOfWeek.thursday;
  } else if (startDay == "friday") {
    return StartingDayOfWeek.friday;
  } else if (startDay == "saturday") {
    return StartingDayOfWeek.saturday;
  }
  return StartingDayOfWeek.sunday;
}
