import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import 'package:grocery_admin_student/widget/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class CategoryManageScreen extends StatefulWidget {
  const CategoryManageScreen({super.key});

  @override
  State<CategoryManageScreen> createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen> {
  XFile? newImage;

  final categoryName = TextEditingController();
  final categoryDescription = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Manage Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    //   child: Image.network("https://firebasestorage.googleapis.com/v0/b/grocery-student.appspot.com/o/Category%2F1714480387239.png?alt=media&token=a93822ec-bc09-4d55-a752-c384d6dd51dd"),
                    backgroundImage: newImage != null
                        ? FileImage(
                            File(newImage!.path),
                          )
                        : AssetImage("assets/app_logo.png") as ImageProvider,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: categoryName,
                  decoration: InputDecoration(
                      border: null, labelText: "Enter Category Name"),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryDescription,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: null, labelText: "Enter Category Description"),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomButton(
                    title: "Add Category",
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    callback: () {
                      addCategoryInDatabase();
                    },
                    isLoading: isLoading )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        newImage = image;
        log("File image path --> ${newImage!.path.toString()}");
      });
    }
  }

  void addCategoryInDatabase() {
    try {
      if (formKey.currentState!.validate()) {
        if (newImage != null) {

          setState(() {
            isLoading = true;
          });

          // data add in firebase storage and realtime database
          log("------------------------------1");
          FirebaseServicies().addCategory(
            image: newImage,
            categoryName: categoryName.text.toString(),
            categoryDesc: categoryDescription.text.toString(),
            context: context
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

/// https://firebasestorage.googleapis.com/v0/b/grocery-student.appspot.com/o/Category%2F1714480387239.png?alt=media&token=a93822ec-bc09-4d55-a752-c384d6dd51dd
