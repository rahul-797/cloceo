import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:you/models/user_model.dart';
import 'package:you/screens/add_edit_screen.dart';
import 'package:you/screens/calender_screen.dart';
import 'package:you/services/login_service.dart';
import 'package:you/utils/date_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginService loginService = LoginService.instance;
  late UserModel? userModel;
  late DateTime dateTime;
  bool isLoading = true;

  @override
  void initState() {
    fetchData();
    dateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cloceo"),
        actions: [
          IconButton(
              onPressed: () {
                loginService.logout();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditScreen(isAdding: true, userModel: userModel));
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                showMakeHabitTiles(),
                showBreakHabitTiles(),
              ],
            ),
    );
  }

  Widget showMakeHabitTiles() {
    return userModel != null && userModel!.habitDetails.isNotEmpty
        ? SizedBox(
            height: ((MediaQuery.of(context).size.height) - ((AppBar().preferredSize.height) * 2)) / 2,
            child: ListView.builder(
              itemCount: userModel!.habitDetails.length,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showBottomSheet(index, true); // "make" habits are sent as true
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(userModel!.habitDetails[index]["name"]),
                      trailing: Text(
                          "${userModel!.habitRecords[index][getDateId(dateTime)] ?? "0"}/${userModel!.habitDetails[index]["goal"]}"),
                    ),
                  ),
                );
              },
            ),
          )
        : const Center(child: Text("Create first habit"));
  }

  Widget showBreakHabitTiles() {
    return userModel != null && userModel!.habitBreakDetails.isNotEmpty
        ? SizedBox(
            height: ((MediaQuery.of(context).size.height) - ((AppBar().preferredSize.height) * 2)) / 2,
            child: ListView.builder(
              itemCount: userModel!.habitBreakDetails.length,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showBottomSheet(index, false); // "break" habits are sent as false
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(userModel!.habitBreakDetails[index]["name"]),
                      trailing: Text(
                          "${userModel!.habitBreakRecords[index][getDateId(dateTime)] ?? "0"}/${userModel!.habitBreakDetails[index]["goal"]}"),
                    ),
                  ),
                );
              },
            ),
          )
        : const Center(child: Text("Create first habit"));
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Colors.grey),
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
                              icon: const Icon(Icons.calendar_month_rounded)),
                        ),
                        Expanded(
                          child: Text(
                            isHabitMake
                                ? userModel!.habitDetails[index]["name"]
                                : userModel!.habitBreakDetails[index]["name"],
                            style: const TextStyle(fontSize: 28),
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
                                    userModel: userModel, isAdding: false, index: index, isHabitMake: isHabitMake));
                              },
                              icon: const Icon(Icons.edit)),
                        ),
                      ],
                    ),
                    const Text(
                      // formulateHabitTypeString(index),
                      "hello",
                      style: TextStyle(fontSize: 14),
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
                                if (userModel!.habitRecords[index].containsKey(getDateId(dateTime))) {
                                  if (userModel!.habitRecords[index][getDateId(dateTime)] > 0) {
                                    userModel!.habitRecords[index][getDateId(dateTime)] -= 1;
                                  }
                                } else {
                                  userModel!.habitRecords[index][getDateId(dateTime)] = 0;
                                }
                              } else {
                                if (userModel!.habitBreakRecords[index].containsKey(getDateId(dateTime))) {
                                  if (userModel!.habitBreakRecords[index][getDateId(dateTime)] > 0) {
                                    userModel!.habitBreakRecords[index][getDateId(dateTime)] -= 1;
                                  }
                                } else {
                                  userModel!.habitBreakRecords[index][getDateId(dateTime)] = 0;
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
                                    userModel!.habitDetails[index]["type"] == "make" ? "Done!" : "No more!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: getTextColor(index, isHabitMake), // update
                                    ),
                                  ),
                                ],
                              ),
                              appearance: CircularSliderAppearance(
                                animationEnabled: false,
                                customWidths: CustomSliderWidths(progressBarWidth: 12, trackWidth: 12),
                                customColors: CustomSliderColors(
                                  dotColor: Colors.transparent,
                                  hideShadow: true,
                                  trackColor: Colors.blueGrey.shade50,
                                  progressBarColors: [Colors.blueAccent, Colors.lightBlueAccent],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (isHabitMake) {
                                if (userModel!.habitRecords[index].containsKey(getDateId(dateTime))) {
                                  userModel!.habitRecords[index][getDateId(dateTime)] += 1;
                                } else {
                                  userModel!.habitRecords[index][getDateId(dateTime)] = 1;
                                }
                              } else {
                                if (userModel!.habitBreakRecords[index].containsKey(getDateId(dateTime))) {
                                  userModel!.habitBreakRecords[index][getDateId(dateTime)] += 1;
                                } else {
                                  userModel!.habitBreakRecords[index][getDateId(dateTime)] = 1;
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
        userModel = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
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

  double getInitialValue(int index, bool isHabitMake) {
    if (isHabitMake) {
      return userModel!.habitRecords[index][getDateId(dateTime)] != null
          ? double.parse(userModel!.habitRecords[index][getDateId(dateTime)].toString())
          : 0.0;
    } else {
      return userModel!.habitBreakRecords[index][getDateId(dateTime)] != null
          ? double.parse(userModel!.habitBreakRecords[index][getDateId(dateTime)].toString())
          : 0.0;
    }
  }

  double getMaxValue(int index, bool isHabitMake) {
    if (isHabitMake) {
      return ((userModel!.habitRecords[index][getDateId(dateTime)] ?? 0) > (userModel!.habitDetails[index]["goal"]))
          ? double.parse(userModel!.habitRecords[index][getDateId(dateTime)].toString())
          : double.parse(userModel!.habitDetails[index]["goal"].toString());
    } else {
      return ((userModel!.habitBreakRecords[index][getDateId(dateTime)] ?? 0) >
              (userModel!.habitBreakDetails[index]["goal"]))
          ? double.parse(userModel!.habitBreakRecords[index][getDateId(dateTime)].toString())
          : double.parse(userModel!.habitBreakDetails[index]["goal"].toString());
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
      return ((userModel!.habitRecords[index][getDateId(dateTime)] ?? 0) >= (userModel!.habitDetails[index]["goal"]))
          ? Colors.black87
          : Colors.transparent;
    } else {
      return ((userModel!.habitBreakRecords[index][getDateId(dateTime)] ?? 0) >=
              (userModel!.habitBreakDetails[index]["goal"]))
          ? Colors.black87
          : Colors.transparent;
    }
  }
}
