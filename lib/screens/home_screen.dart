import 'package:flutter/material.dart';
import 'package:you/services/firestore_service.dart';
import 'package:you/services/login_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginService loginService = LoginService.instance;

  @override
  void initState() {
    super.initState();
    FirestoreService().getSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Hello"),
            const SizedBox(height: 48),
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
}
