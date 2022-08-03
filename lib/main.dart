import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you/screens/home_screen.dart';
import 'package:you/screens/login_screen.dart';
import 'package:you/utils/color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      home: FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const HomeScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        hintColor: kPrimaryLight,
        brightness: Brightness.dark,
        primaryColor: kPrimaryDark,
        appBarTheme: const AppBarTheme(
            backgroundColor: kPrimaryTextLight,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            centerTitle: false,
            titleTextStyle: TextStyle(color: Colors.white)),
        colorScheme: const ColorScheme.dark().copyWith(primary: kPrimaryLight, secondary: kPrimaryLight),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: kPrimaryLight,
          ),
          border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryLight)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryLight, width: 2)),
          labelStyle: TextStyle(
            color: kPrimaryLight,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: kAccentLight,
          ),
        ),
      ),
    ),
  );
}
