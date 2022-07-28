import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:you/models/user_model.dart';

class FirestoreService {
  UserModel? getSnapshot() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        return user;
      } else {
        print('Document does not exists on the database');
      }
    }).onError((error, stackTrace) {
      print('Error: $error\n\nStackTrace: $stackTrace}');
    });
    return null;
  }

  void update(UserModel userModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(userModel.toJson());
  }
}
