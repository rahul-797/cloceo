import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:you/models/user_model.dart';
import 'package:you/utils/date_provider.dart';

class CalenderScreen extends StatefulWidget {
  final UserModel userModel;
  final int index;
  final bool isHabitMake;

  const CalenderScreen(
      {super.key,
      required this.userModel,
      required this.index,
      required this.isHabitMake});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  final kLastDay = DateTime.now();
  late UserModel userModel;
  late int index;
  late bool isHabitMake;

  @override
  void initState() {
    userModel = widget.userModel;
    index = widget.index;
    isHabitMake = widget.isHabitMake;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Column(
            children: [
              Text(
                isHabitMake
                    ? userModel.habitDetails[index]["name"]
                    : userModel.habitBreakDetails[index]["name"],
                style: const TextStyle(fontSize: 28),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Center(
                child: TableCalendar(
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, dateTime, focusedDay) {
                      String doneCount = getDoneCount(dateTime, isHabitMake);
                      return Center(
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                          badgeContent: Text(
                            doneCount,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          position: badges.BadgePosition.bottomEnd(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color:
                                  dateColor(int.parse(doneCount), isHabitMake),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                dateTime.day.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color dateColor(int doneCount, bool isHabitMake) {
    if (isHabitMake) {
      if (doneCount == 0) {
        return Colors.grey;
      } else if (doneCount < userModel.habitDetails[index]["goal"]) {
        return Colors.orange;
      }
      return Colors.green;
    } else {
      if (doneCount == 0) {
        return Colors.green;
      } else if (doneCount <= userModel.habitBreakDetails[index]["goal"]) {
        return Colors.orange;
      }
      return Colors.red;
    }
  }

  String getDoneCount(DateTime dateTime, bool isHabitMake) {
    if (isHabitMake) {
      return (((userModel.habitRecords[index][getDateId(dateTime)]) != null) &&
              (userModel.habitRecords[index].containsKey(getDateId(dateTime))))
          ? userModel.habitRecords[index][getDateId(dateTime)].toString()
          : "0";
    } else {
      return (((userModel.habitBreakRecords[index][getDateId(dateTime)]) !=
                  null) &&
              (userModel.habitBreakRecords[index]
                  .containsKey(getDateId(dateTime))))
          ? userModel.habitBreakRecords[index][getDateId(dateTime)].toString()
          : "0";
    }
  }
}
