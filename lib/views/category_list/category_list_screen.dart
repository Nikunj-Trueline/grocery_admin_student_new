import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import 'package:grocery_admin_student/views/category_manage/category_manage_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category List Screen"),
        backgroundColor: Colors.amber.shade400,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseServicies().getCategory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final value = snapshot.data![index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryManageScreen(
                                categoryModel: snapshot.data![index],
                              ),
                            ));
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.network(value.imageUrl),
                          ),
                          title: Column(
                            children: [
                              Text(value.name),
                              Text(value.description),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                // call function for delete category.

                                print(value.id.toString());

                                setState(() {
                                  isLoading = true;
                                });

                                FirebaseServicies()
                                    .deleteCategory(categoryId: value.id!);
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Category Not Found"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryManageScreen(),
              ));
        },
        backgroundColor: Colors.amber.shade400,
        child: const Icon(Icons.add),
      ),
    );
  }
}
