import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_admin_student/model/user_model.dart';

class FirebaseServicies {
  static FirebaseServicies instance = FirebaseServicies.named();

  FirebaseServicies.named();

  factory FirebaseServicies() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // signIn with email password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  Stream<List<UserData>> userData() {
    return _database.ref().child('Users').onValue.map((event) {
      List<UserData> usersList = [];

      print(event.snapshot.exists);
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> userMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        print("Uermap : $userMap");

        userMap.forEach((key, value) {
          print("value - $value}");
          UserData userData = UserData.fromJson(value);
          print("Userdata object : $userData");
          usersList.add(userData);
        });
      }

        print("userList : ${usersList[0].name}");
      return usersList;
    });
  }
}
