import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:you/models/user_model.dart';
import 'package:you/screens/home_screen.dart';
import 'package:you/utils/date_provider.dart';

class AddEditScreen extends StatefulWidget {
  final UserModel? userModel;
  final int? index;
  final bool isAdding;

  const AddEditScreen({Key? key, required this.userModel, this.index, required this.isAdding}) : super(key: key);

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
  late String date;
  late String dateWithApos;
  List<int> countingInt = List.generate(30, (i) => i + 1);
  List<String> countingString = List.generate(30, (i) => "${i + 1}");

  @override
  void initState() {
    date = getDateId(DateTime.now());
    dateWithApos = "\"$date\"";
    if (widget.userModel != null) {
      userModel = widget.userModel!;
      index = widget.index ?? 0;
      name = userModel.habitDetails[index]["name"];
      goal = userModel.habitDetails[index]["goal"];
      type = userModel.habitDetails[index]["type"];
      repetition = userModel.habitDetails[index]["repetition"];
    } else {
      userModel = UserModel(habitDetails: [], habitRecords: []);
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
                  userModel.habitDetails.removeAt(index);
                  update(userModel);
                  Get.offAll(() => const HomeScreen());
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                child: const Text('Yes'),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey.shade400)),
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
        title: widget.isAdding ? const Text("Add habit") : const Text("Edit habit"),
        actions: [
          !(widget.isAdding)
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
                      const Text(
                        "Name",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: widget.isAdding ? "" : userModel.habitDetails[index]['name'],
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        validator: (str) => str == "" ? "* Can not be blank" : null,
                        decoration: InputDecoration(
                          hintText: "Habit name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (str) {
                          str = toBeginningOfSentenceCase(str)!;
                          name = str;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "I want to",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomRadioButton(
                        elevation: 0,
                        width: 148,
                        unSelectedColor: Colors.white,
                        selectedColor: Colors.blue,
                        defaultSelected: type,
                        enableShape: true,
                        padding: 6,
                        buttonLables: const ['Build a habit', 'Break a habit'],
                        buttonValues: const ["make", "break"],
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black87,
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        radioButtonValue: (value) => type = value.toString(),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "How often?",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomRadioButton(
                        elevation: 0,
                        width: ((MediaQuery.of(context).size.width) - 80) / 3,
                        unSelectedColor: Colors.white,
                        selectedColor: Colors.blue,
                        defaultSelected: repetition,
                        enableShape: true,
                        padding: 6,
                        buttonLables: const ['Daily', 'Weekly', 'Monthly'],
                        buttonValues: const [1, 7, 30],
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black87,
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        radioButtonValue: (value) => repetition = int.parse(value.toString()),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "My daily/weekly goal",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      CustomRadioButton(
                        elevation: 0,
                        width: 64,
                        unSelectedColor: Colors.white,
                        selectedColor: Colors.blue,
                        defaultSelected: goal,
                        enableShape: true,
                        padding: 6,
                        buttonLables: countingString,
                        buttonValues: countingInt,
                        buttonTextStyle: const ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black87,
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.isAdding) {
                  userModel.habitDetails.add({
                    "name": name,
                    "goal": goal,
                    "type": type,
                    "repetition": repetition,
                  });
                } else {
                  userModel.habitDetails[index] = {
                    "name": name,
                    "goal": goal,
                    "type": type,
                    "repetition": repetition,
                  };
                }
                update(userModel);
                Get.offAll(() => const HomeScreen());
              }
              return;
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
            ),
            child: const Center(
              child: Text(
                "Save",
                style: TextStyle(fontSize: 20),
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
}
