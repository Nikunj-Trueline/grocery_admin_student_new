import 'package:flutter/material.dart';
import 'package:grocery_admin_student/views/category_list/category_list_screen.dart';
import 'package:grocery_admin_student/views/product_list/product_list_screen.dart';
import 'package:grocery_admin_student/views/users/user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1 / 1.3,
          children: [
            InkWell(
              onTap: () {
                // Navigate to category list screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryListScreen(),
                    ));
              },
              child: _dashboardCard(
                  title: 'Categories',
                  value: 0,
                  color: Colors.amber.shade400,
                  image: "assets/categories.png"),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductListScreen(),
                    ));

              },
              child: _dashboardCard(
                  title: 'Products',
                  value: 0,
                  color: Colors.blue.shade400,
                  image: "assets/product.png"),
            ),
            InkWell(
              onTap: () {
                // Navigate to users dashboard

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserScreen(),
                    ));
              },
              child: _dashboardCard(
                  title: 'User',
                  value: 0,
                  image: "assets/users.png",
                  color: Colors.pinkAccent.shade400),
            ),
            InkWell(
              onTap: () {},
              child: _dashboardCard(
                title: "order",
                color: Colors.purple.shade400,
                image: "assets/order.png",
                value: 0,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _dashboardCard(
      {required String title,
      required int value,
      required Color color,
      required String image}) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white.withOpacity(.4),
                child: Image.asset(
                  image,
                  height: 43,
                  width: 43,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$value',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 23),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
