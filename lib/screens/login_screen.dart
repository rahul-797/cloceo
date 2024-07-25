import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:you/services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginService loginService = LoginService.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cloceo",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black87,
                ),
              )
            : _getContent(),
      ),
    );
  }

  _getContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Track Your Progress, Achieve Your Goals. Start Building Better Habits Today!",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
            ),
          ),
          SvgPicture.asset(
            "assets/illustrations/login.svg",
            height: MediaQuery.of(context).size.height / 2,
          ),
          _getLoginButton(),
        ],
      ),
    );
  }

  _getLoginButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.black87,
        side: const BorderSide(color: Colors.black87),
        padding: const EdgeInsets.all(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/google-icon.svg",
            width: 24,
          ),
          const SizedBox(
            width: 12,
          ),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () {
        loginService.login();
        isLoading = true;
        setState(() {});
      },
    );
  }
}
