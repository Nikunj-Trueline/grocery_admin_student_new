import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import 'package:grocery_admin_student/model/category_model.dart';
import 'package:grocery_admin_student/widget/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class CategoryManageScreen extends StatefulWidget {
  CategoryModel? categoryModel;
  CategoryManageScreen({super.key, this.categoryModel});

  @override
  State<CategoryManageScreen> createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.categoryModel != null) {
      categoryName.text = widget.categoryModel!.name;
      categoryDescription.text = widget.categoryModel!.description;
      existingImageUrl = widget.categoryModel!.imageUrl;
      print("Category id in initstate : ${widget.categoryModel!.id}");

    }
  }

  XFile? newImage;

  final categoryName = TextEditingController();
  final categoryDescription = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? existingImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Manage Screen"),
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
                    backgroundImage:
                        existingImageUrl != null && newImage == null

                            ? NetworkImage(existingImageUrl!)
                            : newImage != null
                                ? FileImage(
                                    File(newImage!.path),
                                  )
                                : const AssetImage("assets/app_logo.png")
                                    as ImageProvider,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: categoryName,
                  decoration: const InputDecoration(
                      border: null, labelText: "Enter Category Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryDescription,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      border: null, labelText: "Enter Category Description"),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                    title: widget.categoryModel == null ? "Add Category" : "Update Category",
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    callback: () {
                      addCategoryInDatabase();
                    },
                    isLoading: isLoading)
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
        if (newImage != null || existingImageUrl !=null) {
          setState(() {
            isLoading = true;
          });

          // data add in firebase storage and realtime database
          log("------------------------------1");

           // print("categoryid : ${widget.categoryModel!.id}");
          FirebaseServicies().addCategory(
              image: newImage,
              categoryName: categoryName.text.toString(),
              categoryDesc: categoryDescription.text.toString(),
              categoryId: widget.categoryModel?.id,
              createdAt: widget.categoryModel?.createdAt,
              existingImageUrl: widget.categoryModel?.imageUrl,
              context: context);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

/// https://firebasestorage.googleapis.com/v0/b/grocery-student.appspot.com/o/Category%2F1714480387239.png?alt=media&token=a93822ec-bc09-4d55-a752-c384d6dd51dd
