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
      body: isLoading ? const Center(child: CircularProgressIndicator()) : showHabitTiles(),
    );
  }

  Widget showHabitTiles() {
    return userModel != null && userModel!.habitDetails.isNotEmpty
        ? ListView.builder(
      itemCount: userModel!.habitDetails.length,
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showBottomSheet(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        userModel!.habitDetails[index]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                          "${userModel!.habitRecords[index][getDateId(dateTime)] ?? "0"}/${userModel!.habitDetails[index]["goal"]}"),
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(child: Text("Create first habit"));
  }

  showBottomSheet(int index) {
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
                                Get.to(() => CalenderScreen(userModel: userModel!, index: index));
                              },
                              icon: const Icon(Icons.calendar_month_rounded)),
                        ),
                        Expanded(
                          child: Text(
                            userModel!.habitDetails[index]["name"],
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
                                Get.to(() => AddEditScreen(userModel: userModel, isAdding: false, index: index));
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
                              if (userModel!.habitRecords[index].containsKey(getDateId(dateTime))) {
                                if (userModel!.habitRecords[index][getDateId(dateTime)] > 0) {
                                  userModel!.habitRecords[index][getDateId(dateTime)] -= 1;
                                }
                              } else {
                                userModel!.habitRecords[index][getDateId(dateTime)] = 0;
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
                              initialValue: userModel!.habitRecords[index][getDateId(dateTime)] != null
                                  ? double.parse(userModel!.habitRecords[index][getDateId(dateTime)].toString())
                                  : 0.0,
                              min: 0,
                              max: ((userModel!.habitRecords[index][getDateId(dateTime)] ?? 0) >
                                      (userModel!.habitDetails[index]["goal"]))
                                  ? double.parse(userModel!.habitRecords[index][getDateId(dateTime)].toString())
                                  : double.parse(userModel!.habitDetails[index]["goal"].toString()),
                              innerWidget: (_) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    userModel!.habitRecords[index][getDateId(dateTime)] != null
                                        ? userModel!.habitRecords[index][getDateId(dateTime)].toString()
                                        : "0",
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  Text(
                                    userModel!.habitDetails[index]["type"] == "make" ? "Done!" : "No more!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ((userModel!.habitRecords[index][getDateId(dateTime)] ?? 0) >=
                                              (userModel!.habitDetails[index]["goal"]))
                                          ? Colors.black87
                                          : Colors.transparent, // update
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
                              if (userModel!.habitRecords[index].containsKey(getDateId(dateTime))) {
                                userModel!.habitRecords[index][getDateId(dateTime)] += 1;
                              } else {
                                userModel!.habitRecords[index][getDateId(dateTime)] = 1;
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
}
