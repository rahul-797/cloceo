import 'package:flutter/material.dart';
import 'package:you/services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginService loginService = LoginService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _getContent(),
      ),
    );
  }

  _getContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          height: 24.0,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _getLoginButtons(),
            ),
          ],
        ),
      ],
    );
  }

  _getLoginButtons() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black87),
        padding: const EdgeInsets.all(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/google-icon.png',
            width: 24,
          ),
          const SizedBox(
            width: 12,
          ),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      onPressed: () {
        loginService.login();
      },
    );
  }
}
