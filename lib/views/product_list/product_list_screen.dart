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
  bool checkBox = false;

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
                final product = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    // Navigate to product manage screen.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductManageScreen(
                            product:  snapshot.data![index],
                          ),
                        ));
                  },
                  child: ListTile(
                      leading: CircleAvatar(
                        child: Image(
                          image: NetworkImage(product.imageUrl),
                        ),
                      ),
                      title: Column(
                        children: [
                          Text("ProductName : ${product.name}"),
                          Text("ProductDesc : ${product.description}"),
                          Text("Price : ${product.price}"),
                          Text("Quantity : ${product.stock}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: snapshot.data![index].inTop,
                              onChanged: (status) async {
                                // print(status!);

                                await FirebaseServicies().updateInTopStatus(
                                    productId: snapshot.data![index].id!,
                                    status: status!);
                              }),
                          IconButton(
                              onPressed: () async {
                                try {
                                  await FirebaseServicies()
                                      .deleteProduct(productId: product.id!);
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      )),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Product not found"),
            );
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
                builder: (context) =>  ProductManageScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
