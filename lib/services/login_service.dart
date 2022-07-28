import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:you/screens/home_screen.dart';
import 'package:you/screens/login_screen.dart';

class LoginService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static late final User? user;
  static late final GoogleSignIn googleSignIn;

  LoginService._privateConstructor();

  static final LoginService instance = LoginService._privateConstructor();

  login() async {
    googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
        Get.to(() => const HomeScreen());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print(e);
        } else if (e.code == 'invalid-credential') {
          print(e);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print(e);
    }
  }
}
