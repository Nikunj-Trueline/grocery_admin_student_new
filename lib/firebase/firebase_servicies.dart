import 'dart:developer';

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_admin_student/model/category_model.dart';
import 'package:grocery_admin_student/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServicies {
  static FirebaseServicies instance = FirebaseServicies.named();

  FirebaseServicies.named();

  factory FirebaseServicies() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

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

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> userMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        userMap.forEach((key, value) {
          UserData userData = UserData.fromJson(value);

          usersList.add(userData);
        });
      }

      return usersList;
    });
  }

  Future<void> addCategory({
    XFile? image,
    String? categoryName,
    String? categoryDesc,
    int? createdAt,
    String? categoryId,
    required BuildContext context,
  }) async {
    try {
      // create timestamp;
      String? newImageUrl;

      log("This is called.......................");

      int? timeStamp = DateTime.now().millisecondsSinceEpoch;

      if (image != null) {
        // create new path for various categories.
        String? filename = "${DateTime.now().millisecondsSinceEpoch}.png";

        log(filename.toString());

        // create file for store in storage for show category image.

        File file = File(image.path);

        log(file.path);

        // upload file in  storage task

        TaskSnapshot snapshot = await _storage
            .ref()
            .child("Category")
            .child(filename)
            .putFile(file);

        newImageUrl = await snapshot.ref.getDownloadURL();

        log(newImageUrl.toString());

      }

      // task for upload data in real time database

      CategoryModel categoryModel = CategoryModel(
        name: categoryName!,
        description: categoryDesc!,
        imageUrl: newImageUrl!,
        isActive: true,
        createdAt: timeStamp,

      );

      String? categoryId = _database.ref().child("Category").push().key;

      categoryModel.id = categoryId;

      _database
          .ref()
          .child("Category")
          .child(categoryId!)
          .set(categoryModel.toJson());

      print("Thank you...............");

      Navigator.pop(context);


    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<CategoryModel>> getCategory() {
    return _database.ref().child("Category").onValue.map((event) {
      List<CategoryModel> category = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> categoryMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        categoryMap.forEach((key, value) {
          CategoryModel categoryModel = CategoryModel.fromJson(value);
          category.add(categoryModel);
        });
      }
      return category;
    });
  }

  // method for delete category.

  Future<bool> deleteCategory({required String categoryId}) async {
    try {


      await _database.ref().child("Category").child(categoryId).remove();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}

/*

()
()
()
 */
