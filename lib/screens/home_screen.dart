import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you/models/user_model.dart';
import 'package:you/screens/add_edit_screen.dart';
import 'package:you/services/login_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginService loginService = LoginService.instance;
  late UserModel? userModel;
  bool isLoading = true;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditScreen(isAdding: true, userModel: userModel));
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading ? const Center(child: CircularProgressIndicator()) : showHabitTiles(),
            ElevatedButton(
              onPressed: () {
                loginService.logout();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget showHabitTiles() {
    return ListView.builder(
      itemCount: userModel!.habitDetails.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Get.to(() => AddEditScreen(userModel: userModel, isAdding: false, index: index));
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
                //trailing: Text(
                // "${userModel!.habitRecords[index]['270722'] ?? "0"}/${userModel!.habitDetails[index]['goal']}"),
              ),
            ),
          ),
        );
      },
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
        print("returned user");
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
