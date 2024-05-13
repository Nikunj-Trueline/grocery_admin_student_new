import 'dart:developer';

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_admin_student/model/category_model.dart';
import 'package:grocery_admin_student/model/product.dart';
import 'package:grocery_admin_student/model/user_model.dart';
import 'package:grocery_admin_student/views/product_list/product_list_screen.dart';
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
    String? existingImageUrl,
    required BuildContext context,
  }) async {
    try {
      // create timestamp;
      String? newImageUrl;

      newImageUrl = existingImageUrl ?? "";

      log("This is called.......................");

      int? timeStamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

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
        imageUrl: newImageUrl,
        isActive: true,
        createdAt: timeStamp,
        id: categoryId,
      );

      if (categoryModel.id == null) {
        String? categoryId = _database.ref().child("Category").push().key;

        categoryModel.id = categoryId;

        _database
            .ref()
            .child("Category")
            .child(categoryId!)
            .set(categoryModel.toJson());

        print("Add categpry....");

        Navigator.pop(context);
      } else {
        _database
            .ref()
            .child("Category")
            .child(categoryId!)
            .update(categoryModel.toJson());

        print("Update Category...");

        Navigator.pop(context);
      }
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

  // add product in database

  Future<bool> addProductInDataBase(
      {required String productName,
      String? productId,
      required String productDesc,
      required BuildContext context,
      XFile? newImage,
      String? existingImageUrl,
      required int stockQuantity,
      required String categoryId,
      int? timeStamp1,
      required double price}) async {
    try {
      String imageUrl = existingImageUrl?? "";

      if (newImage != null) {
        String filePath = "${DateTime.now().millisecondsSinceEpoch}.png";

        File file = File(newImage.path);

        print("----------------------------------1");
        TaskSnapshot taskSnapshot =
            await _storage.ref().child("Product").child(filePath).putFile(file);

        print("---------------------------------2");

        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      int? timeStamp = timeStamp1 ?? DateTime.now().millisecondsSinceEpoch;

      print("----------------------------------------3");
      Product product = Product(
          id: productId,
          name: productName,
          description: productDesc,
          price: price,
          stock: stockQuantity,
          imageUrl: imageUrl,
          inTop: false,
          createdAt: timeStamp,
          categoryId: categoryId);

      if (product.id == null) {
        // add product in database

        String? id = _database.ref().child("Products").push().key;

        product.id = id;

        await _database
            .ref()
            .child("Products")
            .child(id!)
            .set(product.toJson());
      } else {
        // update product
        await _database
            .ref()
            .child("Products")
            .child(productId!)
            .update(product.toJson());
      }

      Navigator.pop(context);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<Product>> getAllProduct() {
    return _database.ref().child("Products").onValue.map((event) {
      List<Product> productList = [];

      if (event.snapshot.exists) {
        Map<dynamic, dynamic> productMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        productMap.forEach((key, value) {
          Product product = Product.fromJson(value);

          productList.add(product);
        });
      }

      return productList;
    });
  }

  Future<bool> deleteProduct({required String productId}) async {
    try {
      await _database.ref().child("Products").child(productId).remove();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> updateInTopStatus(
      {required String productId, required bool status}) async {
    await _database
        .ref()
        .child("Products")
        .child(productId)
        .update({"inTop": status});
  }

  Future<List<CategoryModel>> getCategories() async {
    DataSnapshot snapshot = await _database.ref().child("Category").get();

    List<CategoryModel> categoryList = [];

    if (snapshot.exists) {
      Map categoriesMap = snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        CategoryModel model = CategoryModel.fromJson(value);

        categoryList.add(model);
      });
    }

    return categoryList;
  }
}

/*

()
()
()
 */
