import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you/screens/home_screen.dart';
import 'package:you/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      home: FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const HomeScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
