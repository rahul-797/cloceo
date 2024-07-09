import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:you/models/user_model.dart';
import 'package:you/screens/home_screen.dart';
import 'package:you/screens/login_screen.dart';

class LoginService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static late User? user;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  LoginService._privateConstructor();

  static final LoginService instance = LoginService._privateConstructor();

  login() async {
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

        // Create empty document with email ID
        try {
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .get()
              .then((docSnapshot) => {
                    if (!docSnapshot.exists)
                      {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .set(UserModel(
                                habitDetails: [],
                                habitRecords: [],
                                habitBreakDetails: [],
                                habitBreakRecords: []).toJson())
                      }
                  });
        } catch (e) {
          print(e);
        }
        Get.offAll(() => const HomeScreen());
      } catch (e) {
        print(e);
      }
    }
  }

  logout() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print(e);
    }
  }
}
