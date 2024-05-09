import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import 'package:image_picker/image_picker.dart';
import '../../widget/custom_button.dart';

class ProductManageScreen extends StatefulWidget {
  const ProductManageScreen({super.key});

  @override
  State<ProductManageScreen> createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  XFile? _newImage;
  String? existingImageUrl;

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockQuantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Manage Screen"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.white,
                    child: _newImage == null && existingImageUrl != null
                        ? CircleAvatar(
                            radius: 60,
                            foregroundImage: NetworkImage(existingImageUrl!),
                          )
                        : _newImage != null
                            ? CircleAvatar(
                                radius: 60,
                                foregroundImage: FileImage(
                                  File(_newImage!.path),
                                ),
                              )
                            : const Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.white,
                              ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Item Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stockQuantityController,
                        decoration:
                            const InputDecoration(labelText: 'Stock Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  backgroundColor: Colors.blue.shade300,
                  title: 'Add Item',
                  foregroundColor: Colors.white,
                  callback: () {
                    // add product
                    addProduct();
                  },
                  isLoading: isLoading,
                )
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
        _newImage = image;
      });
    }
  }

  Future<void> addProduct() async {
    try {
      if (formKey.currentState!.validate()) {
        if (_newImage != null || existingImageUrl != null) {

          setState(() {
            isLoading = true;
          });

         bool status = await FirebaseServicies().addProductInDataBase(
              productName: _nameController.text.toString(),
              newImage: _newImage,
              productDesc: _descriptionController.text.toString(),
              context: context,
              stockQuantity: int.parse(_stockQuantityController.text),
              price: double.parse(_priceController.text));

         if(status)
           {
             print("Snackbar............");
           }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
