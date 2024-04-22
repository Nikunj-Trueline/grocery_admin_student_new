import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import 'package:grocery_admin_student/model/user_model.dart';
import 'package:grocery_admin_student/views/login/login_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                } catch (e) {
                  log(e.toString());
                }
              },
              icon: Icon(Icons.logout, color: Colors.white),
            )
          ],
          backgroundColor: Colors.green,
        ),
        body: StreamBuilder(
          stream: FirebaseServicies().userData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.hasError.toString()),
              );
            } else if (snapshot.hasData) {
              // build your widget ui
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserData userData = snapshot.data![index];

                  // List = [(),()];

                  return Card(
                    child: Column(
                      children: [
                        Text(userData.name),
                        Text(userData.email),
                        Text(userData.contact)
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("User Not Found"),
              );
            }
          },
        ));
  }
}
