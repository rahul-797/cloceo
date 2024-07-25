import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:you/models/user_model.dart';
import 'package:you/screens/home_screen.dart';
import 'package:you/utils/color_scheme.dart';
import 'package:you/utils/date_provider.dart';

class AddEditScreen extends StatefulWidget {
  final UserModel? userModel;
  final int? index;
  final bool isAdding;
  final bool? isHabitMake;

  const AddEditScreen(
      {super.key,
      required this.userModel,
      this.index,
      required this.isAdding,
      this.isHabitMake});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserModel userModel;
  late int index = 0;
  String name = "";
  int repetition = 1;
  int goal = 1;
  String type = "make";
  late bool isAdding;
  late bool? isHabitMake;
  late String date;
  late String dateWithApos;
  List<int> countingInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 100, 120, 150, 200];
  List<String> countingString = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "15",
    "20",
    "25",
    "30",
    "40",
    "50",
    "60",
    "70",
    "80",
    "100",
    "120",
    "150",
    "200"
  ];

  @override
  void initState() {
    isAdding = widget.isAdding;
    isHabitMake = widget.isHabitMake;
    date = getDateId(DateTime.now());
    dateWithApos = "\"$date\"";
    if (widget.userModel != null) {
      userModel = widget.userModel!;
      index = widget.index ?? 0;
      if (isHabitMake != null) {
        if (isHabitMake!) {
          if (userModel.habitDetails.isNotEmpty && !isAdding) {
            name = userModel.habitDetails[index]["name"];
            goal = userModel.habitDetails[index]["goal"];
            type = userModel.habitDetails[index]["type"];
            repetition = userModel.habitDetails[index]["repetition"];
          }
        } else {
          if (userModel.habitBreakDetails.isNotEmpty && !isAdding) {
            name = userModel.habitBreakDetails[index]["name"];
            goal = userModel.habitBreakDetails[index]["goal"];
            type = userModel.habitBreakDetails[index]["type"];
            repetition = userModel.habitBreakDetails[index]["repetition"];
          }
        }
      }
    } else {
      userModel = UserModel(habitDetails: [], habitRecords: [], habitBreakDetails: [], habitBreakRecords: []);
    }
    super.initState();
  }

  showDeleteConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('This can not be undone!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (isHabitMake!) {
                    userModel.habitDetails.removeAt(index);
                    userModel.habitRecords.removeAt(index);
                  } else {
                    userModel.habitBreakDetails.removeAt(index);
                    userModel.habitBreakRecords.removeAt(index);
                  }
                  update(userModel);
                  Get.offAll(() => const HomeScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isAdding
            ? const Text("Add habit", style: TextStyle(fontSize: 24))
            : const Text("Edit habit", style: TextStyle(fontSize: 24)),
        actions: [
          !isAdding
              ? IconButton(
                  onPressed: () {
                    showDeleteConfirmDialog();
                  },
                  icon: const Icon(Icons.delete))
              : const SizedBox(height: 0, width: 0),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: getInitialName(index, isHabitMake),
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        validator: (str) => str == "" ? "* Can not be blank" : null,
                        decoration: InputDecoration(
                          hintText: "Habit name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black87),
                          ),
                        ),
                        keyboardAppearance: Brightness.light,
                        cursorColor: Colors.black87,
                        onChanged: (str) {
                          str = toBeginningOfSentenceCase(str)!;
                          name = str;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "I want to",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      CustomRadioButton(
                        elevation: 0,
                        width: 148,
                        unSelectedColor: kPrimaryBackgroundLight,
                        selectedColor: kSecondaryTextLight,
                        defaultSelected: type,
                        enableShape: true,
                        padding: 6,
                        buttonLables: const ['Build a habit', 'Break a habit'],
                        buttonValues: const ["make", "break"],
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: kPrimaryBackgroundLight,
                          unSelectedColor: kPrimaryTextLight,
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        radioButtonValue: (value) {
                          type = value.toString();
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 24),
                      // const Text(
                      //   "How often?",
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      // const SizedBox(height: 10),
                      // CustomRadioButton(
                      //   elevation: 0,
                      //   width: ((MediaQuery.of(context).size.width) - 80) / 3,
                      //   unSelectedColor: kSecondaryTextLight,
                      //   selectedColor: kPrimaryBackgroundLight,
                      //   defaultSelected: repetition,
                      //   enableShape: true,
                      //   padding: 6,
                      //   buttonLables: const ['Daily'],
                      //   buttonValues: const [1],
                      //   buttonTextStyle: const ButtonTextStyle(
                      //     selectedColor: kPrimaryTextLight,
                      //     unSelectedColor: kPrimaryBackgroundLight,
                      //     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      //   ),
                      //   radioButtonValue: (value) => repetition = int.parse(value.toString()),
                      // ),
                      // const SizedBox(height: 16),
                      // const Divider(color: Colors.grey),
                      // const SizedBox(height: 16),
                      Text(
                        type == "make" ? "My goal" : "Maximum limit",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      CustomRadioButton(
                        elevation: 0,
                        width: 64,
                        unSelectedColor: kPrimaryBackgroundLight,
                        selectedColor: kSecondaryTextLight,
                        defaultSelected: goal,
                        enableShape: true,
                        padding: 6,
                        enableButtonWrap: true,
                        buttonLables: countingString,
                        buttonValues: countingInt,
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: kPrimaryBackgroundLight,
                          unSelectedColor: kPrimaryTextLight,
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        radioButtonValue: (value) => goal = int.parse(value.toString()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isAdding) {
                    // add new habit
                    if (type == "make") {
                      userModel.habitDetails.add({
                        "name": name,
                        "goal": goal,
                        "type": type,
                        "repetition": repetition,
                      });
                      userModel.habitRecords.add({});
                    } else {
                      userModel.habitBreakDetails.add({
                        "name": name,
                        "goal": goal,
                        "type": type,
                        "repetition": repetition,
                      });
                      userModel.habitBreakRecords.add({});
                    }
                  } else {
                    // update habit
                    String previousType = isHabitMake! ? "make" : "break";
                    if (previousType == type) {
                      if (type == "make") {
                        userModel.habitDetails[index] = {
                          "name": name,
                          "goal": goal,
                          "type": type,
                          "repetition": repetition,
                        };
                      } else {
                        userModel.habitBreakDetails[index] = {
                          "name": name,
                          "goal": goal,
                          "type": type,
                          "repetition": repetition,
                        };
                      }
                    } else {
                      if (type == "make") {
                        userModel.habitDetails.insert(0, {
                          "name": name,
                          "goal": goal,
                          "type": type,
                          "repetition": repetition,
                        });
                        userModel.habitBreakDetails.removeAt(index);
                        userModel.habitRecords.insert(0, userModel.habitBreakRecords[index]);
                        userModel.habitBreakRecords.removeAt(index);
                      } else {
                        userModel.habitBreakDetails.insert(0, {
                          "name": name,
                          "goal": goal,
                          "type": type,
                          "repetition": repetition,
                        });
                        userModel.habitDetails.removeAt(index);
                        userModel.habitBreakRecords.insert(0, userModel.habitRecords[index]);
                        userModel.habitRecords.removeAt(index);
                      }
                    }
                  }
                  update(userModel);
                  Get.offAll(() => const HomeScreen());
                }
                return;
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black87),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12)),
              ),
              child: const Center(
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void update(UserModel userModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(userModel.toJson());
  }

  String getInitialName(int index, bool? isHabitMake) {
    if (isHabitMake != null) {
      if (isHabitMake) {
        return isAdding ? "" : userModel.habitDetails[index]['name'];
      } else {
        return isAdding ? "" : userModel.habitBreakDetails[index]['name'];
      }
    } else {
      return "";
    }
  }
}
