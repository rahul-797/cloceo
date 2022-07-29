import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:you/models/user_model.dart';
import 'package:you/utils/date_provider.dart';

class CalenderScreen extends StatefulWidget {
  final UserModel userModel;
  final int index;

  const CalenderScreen({Key? key, required this.userModel, required this.index}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  final kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  final kLastDay = DateTime.now();
  late UserModel userModel;
  late int index;

  @override
  void initState() {
    userModel = widget.userModel;
    index = widget.index;
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
                userModel.habitDetails[index]["name"],
                style: const TextStyle(fontSize: 36),
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
                      String doneCount = (((userModel.habitRecords[index][getDateId(dateTime)]) != null) &&
                              (userModel.habitRecords[index].containsKey(getDateId(dateTime))))
                          ? userModel.habitRecords[index][getDateId(dateTime)].toString()
                          : "0";
                      return Center(
                        child: Badge(
                          badgeContent: Text(
                            doneCount,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          elevation: 0,
                          badgeColor: Colors.white,
                          padding: const EdgeInsets.all(4),
                          position: BadgePosition.bottomEnd(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: dateColor(int.parse(doneCount)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                dateTime.day.toString(),
                                style:
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

  Color dateColor(int doneCount) {
    if (doneCount == 0) {
      return Colors.red;
    } else if (doneCount < userModel.habitDetails[index]["goal"]) {
      return Colors.orange;
    }
    return Colors.green;
  }
}
