import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:you/models/user_model.dart';
import 'package:you/screens/add_edit_screen.dart';
import 'package:you/screens/calender_screen.dart';
import 'package:you/services/login_service.dart';
import 'package:you/utils/color_scheme.dart';
import 'package:you/utils/date_provider.dart';
import 'package:you/utils/startday_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginService loginService = LoginService.instance;
  late UserModel? userModel;
  late DateTime dateTime;
  bool isLoading = true;

  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final DateTime _focusedDay = DateTime.now();
  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 6);
  final kLastDay = DateTime.now();
  late String startDay;
  late StartingDayOfWeek startingDayOfWeek;

  @override
  void initState() {
    dateTime = DateTime.now();
    startDay = (DateFormat('EEEE').format(kFirstDay)).toLowerCase();
    startingDayOfWeek = startDayProvider(startDay);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cloceo",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showLogoutConfirmDialog();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditScreen(isAdding: true, userModel: userModel));
        },
        backgroundColor: Colors.grey.shade200,
        child: const Icon(Icons.add, size: 32),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text(
                      "Routines to adopt",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  showMakeHabitTiles(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Text(
                      "Habits to overcome",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  showBreakHabitTiles(),
                ],
              ),
            ),
    );
  }

  Widget showMakeHabitTiles() {
    return userModel != null && userModel!.habitDetails.isNotEmpty
        ? ListView.builder(
            itemCount: userModel!.habitDetails.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showBottomSheet(
                      index, true); // "make" habits are sent as true
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userModel!.habitDetails[index]["name"],
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                      showCalender(index, true),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: Text("Create first habit"));
  }

  Widget showBreakHabitTiles() {
    return userModel != null && userModel!.habitBreakDetails.isNotEmpty
        ? Column(
            children: [
              ListView.builder(
                itemCount: userModel!.habitBreakDetails.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showBottomSheet(
                          index, false); // "break" habits are sent as false
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userModel!.habitBreakDetails[index]["name"],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const Icon(Icons.navigate_next),
                              ],
                            ),
                          ),
                          showCalender(index, false),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
            ],
          )
        : const Center(child: Text("Create first habit"));
  }

  Widget showCalender(int index, bool isHabitMake) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        availableGestures: AvailableGestures.none,
        headerVisible: false,
        daysOfWeekVisible: false,
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: false,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, dateTime, focusedDay) {
            String doneCount = getDoneCount(dateTime, index, isHabitMake);
            return Center(
              child: badges.Badge(
                badgeContent: Text(
                  doneCount,
                  style: const TextStyle(color: Colors.black87, fontSize: 10),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                position: badges.BadgePosition.bottomEnd(),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: dateColor(int.parse(doneCount), index, isHabitMake),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      dateTime.day.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
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
        startingDayOfWeek: startingDayOfWeek,
      ),
    );
  }

  showBottomSheet(int index, bool isHabitMake) {
    Get.bottomSheet(
      Wrap(
        children: [
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomState) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Container(
                          height: 4,
                          width: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.to(() => CalenderScreen(
                                    userModel: userModel!,
                                    index: index,
                                    isHabitMake: isHabitMake,
                                  ));
                            },
                            icon: const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isHabitMake
                                ? userModel!.habitDetails[index]["name"]
                                : userModel!.habitBreakDetails[index]["name"],
                            style: const TextStyle(fontSize: 24),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: IconButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Get.to(() => AddEditScreen(
                                    userModel: userModel,
                                    isAdding: false,
                                    index: index,
                                    isHabitMake: isHabitMake));
                              },
                              icon: const Icon(Icons.edit)),
                        ),
                      ],
                    ),
                    Text(
                      formulateHabitTypeString(index, isHabitMake),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (isHabitMake) {
                                if (userModel!.habitRecords[index]
                                    .containsKey(getDateId(dateTime))) {
                                  if (userModel!.habitRecords[index]
                                          [getDateId(dateTime)] >
                                      0) {
                                    userModel!.habitRecords[index]
                                        [getDateId(dateTime)] -= 1;
                                  }
                                } else {
                                  userModel!.habitRecords[index]
                                      [getDateId(dateTime)] = 0;
                                }
                              } else {
                                if (userModel!.habitBreakRecords[index]
                                    .containsKey(getDateId(dateTime))) {
                                  if (userModel!.habitBreakRecords[index]
                                          [getDateId(dateTime)] >
                                      0) {
                                    userModel!.habitBreakRecords[index]
                                        [getDateId(dateTime)] -= 1;
                                  }
                                } else {
                                  userModel!.habitBreakRecords[index]
                                      [getDateId(dateTime)] = 0;
                                }
                              }
                              update(userModel!);
                              setState(() {});
                              setBottomState(() {});
                            },
                            icon: const Icon(Icons.remove),
                            iconSize: 36,
                            padding: const EdgeInsets.all(16),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            child: SleekCircularSlider(
                              initialValue: getInitialValue(index, isHabitMake),
                              min: 0,
                              max: getMaxValue(index, isHabitMake),
                              innerWidget: (_) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getSliderText(index, isHabitMake),
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  Text(
                                    getDoneText(index, isHabitMake),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: getTextColor(
                                          index, isHabitMake), // update
                                    ),
                                  ),
                                ],
                              ),
                              appearance: CircularSliderAppearance(
                                animationEnabled: false,
                                customWidths: CustomSliderWidths(
                                    progressBarWidth: 12, trackWidth: 12),
                                customColors: CustomSliderColors(
                                  dotColor: Colors.transparent,
                                  hideShadow: true,
                                  trackColor: Colors.blueGrey.shade50,
                                  progressBarColors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (isHabitMake) {
                                if (userModel!.habitRecords[index]
                                    .containsKey(getDateId(dateTime))) {
                                  userModel!.habitRecords[index]
                                      [getDateId(dateTime)] += 1;
                                } else {
                                  userModel!.habitRecords[index]
                                      [getDateId(dateTime)] = 1;
                                }
                              } else {
                                if (userModel!.habitBreakRecords[index]
                                    .containsKey(getDateId(dateTime))) {
                                  userModel!.habitBreakRecords[index]
                                      [getDateId(dateTime)] += 1;
                                } else {
                                  userModel!.habitBreakRecords[index]
                                      [getDateId(dateTime)] = 1;
                                }
                              }
                              update(userModel!);
                              setState(() {});
                              setBottomState(() {});
                            },
                            icon: const Icon(Icons.add),
                            iconSize: 36,
                            padding: const EdgeInsets.all(16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  void fetchData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userModel =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        setState(() {
          isLoading = false;
        });
      } else {
        userModel = null;
        setState(() {
          isLoading = false;
        });
      }
    }).onError((error, stackTrace) {
      print(error);
      userModel = null;
      setState(() {
        isLoading = false;
      });
    });
  }

  void update(UserModel userModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(userModel.toJson());
  }

  showLogoutConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Logout from this account?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  loginService.logout();
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.redAccent)),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.grey.shade400)),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(width: 2),
            ],
          );
        });
  }

  Color dateColor(int doneCount, int index, bool isHabitMake) {
    if (isHabitMake) {
      if (doneCount == 0) {
        return Colors.grey;
      } else if (doneCount < userModel!.habitDetails[index]["goal"]) {
        return Colors.orange;
      }
      return Colors.green;
    } else {
      if (doneCount == 0) {
        return Colors.green;
      } else if (doneCount <= userModel!.habitBreakDetails[index]["goal"]) {
        return Colors.orange;
      }
      return Colors.redAccent;
    }
  }

  String getDoneCount(DateTime dateTime, int index, isHabitMake) {
    if (isHabitMake) {
      return (((userModel!.habitRecords[index][getDateId(dateTime)]) != null) &&
              (userModel!.habitRecords[index].containsKey(getDateId(dateTime))))
          ? userModel!.habitRecords[index][getDateId(dateTime)].toString()
          : "0";
    } else {
      return (((userModel!.habitBreakRecords[index][getDateId(dateTime)]) !=
                  null) &&
              (userModel!.habitBreakRecords[index]
                  .containsKey(getDateId(dateTime))))
          ? userModel!.habitBreakRecords[index][getDateId(dateTime)].toString()
          : "0";
    }
  }

  double getInitialValue(int index, bool isHabitMake) {
    if (isHabitMake) {
      return userModel!.habitRecords[index][getDateId(dateTime)] != null
          ? double.parse(
              userModel!.habitRecords[index][getDateId(dateTime)].toString())
          : 0.0;
    } else {
      return userModel!.habitBreakRecords[index][getDateId(dateTime)] != null
          ? double.parse(userModel!.habitBreakRecords[index]
                  [getDateId(dateTime)]
              .toString())
          : 0.0;
    }
  }

  double getMaxValue(int index, bool isHabitMake) {
    if (isHabitMake) {
      return ((userModel!.habitRecords[index][getDateId(dateTime)] ?? 0) >
              (userModel!.habitDetails[index]["goal"]))
          ? double.parse(
              userModel!.habitRecords[index][getDateId(dateTime)].toString())
          : double.parse(userModel!.habitDetails[index]["goal"].toString());
    } else {
      return ((userModel!.habitBreakRecords[index][getDateId(dateTime)] ?? 0) >
              (userModel!.habitBreakDetails[index]["goal"]))
          ? double.parse(userModel!.habitBreakRecords[index]
                  [getDateId(dateTime)]
              .toString())
          : double.parse(
              userModel!.habitBreakDetails[index]["goal"].toString());
    }
  }

  String getSliderText(int index, bool isHabitMake) {
    if (isHabitMake) {
      return userModel!.habitRecords[index][getDateId(dateTime)] != null
          ? userModel!.habitRecords[index][getDateId(dateTime)].toString()
          : "0";
    } else {
      return userModel!.habitBreakRecords[index][getDateId(dateTime)] != null
          ? userModel!.habitBreakRecords[index][getDateId(dateTime)].toString()
          : "0";
    }
  }

  Color getTextColor(int index, bool isHabitMake) {
    if (isHabitMake) {
      return ((userModel!.habitRecords[index][getDateId(dateTime)] ?? 0) >=
              (userModel!.habitDetails[index]["goal"]))
          ? Colors.white
          : Colors.transparent;
    } else {
      return ((userModel!.habitBreakRecords[index][getDateId(dateTime)] ?? 0) >=
              (userModel!.habitBreakDetails[index]["goal"]))
          ? Colors.white
          : Colors.transparent;
    }
  }

  String getDoneText(int index, bool isHabitMake) {
    if (isHabitMake) {
      return "Done!";
    } else {
      return "No more!";
    }
  }

  String formulateHabitTypeString(int index, bool isHabitMake) {
    if (isHabitMake) {
      if (userModel!.habitDetails[index]["repetition"] == 1) {
        return "Daily goal: ${userModel!.habitDetails[index]["goal"]}";
      } else if (userModel!.habitDetails[index]["repetition"] == 7) {
        return "Weekly goal: ${userModel!.habitDetails[index]["goal"]}";
      } else if (userModel!.habitDetails[index]["repetition"] == 30) {
        return "Monthly goal: ${userModel!.habitDetails[index]["goal"]}";
      }
    } else if (!isHabitMake) {
      if (userModel!.habitBreakDetails[index]["repetition"] == 1) {
        return "Daily maximum: ${userModel!.habitBreakDetails[index]["goal"]}";
      } else if (userModel!.habitBreakDetails[index]["repetition"] == 7) {
        return "Weekly maximum: ${userModel!.habitBreakDetails[index]["goal"]}";
      } else if (userModel!.habitBreakDetails[index]["repetition"] == 30) {
        return "Monthly maximum: ${userModel!.habitBreakDetails[index]["goal"]}";
      }
    }
    return "repeatTime is not 1/7/30";
  }
}
