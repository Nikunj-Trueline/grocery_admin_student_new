import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import '../product_manage/product_manage_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List "),
      ),
      body: StreamBuilder(
        stream: FirebaseServicies().getAllProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.hasError}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final objectofProduct = snapshot.data![index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Image(
                      image: NetworkImage(objectofProduct.imageUrl),
                    ),
                  ),
                  title: Column(
                    children: [
                      Text("ProductName : ${objectofProduct.name}"),
                      Text("ProductDesc : ${objectofProduct.description}"),
                      Text("Price : ${objectofProduct.price}"),
                      Text("Quantity : ${objectofProduct.stock}"),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        try {
                          bool delete = await FirebaseServicies()
                              .deleteProduct(productId: objectofProduct.id!);
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      icon: Icon(Icons.delete)),
                );
              },
            );
          } else {
            return Center(child: Text("Product not found"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductManageScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
