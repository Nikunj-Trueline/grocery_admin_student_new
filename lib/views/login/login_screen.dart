import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grocery_admin_student/firebase/firebase_servicies.dart';
import 'package:grocery_admin_student/widget/custom_button.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: const Stack(
          children: [
            SizedBox(
              child: Image(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.fill,
              ),
              height: double.infinity,
              width: double.infinity,
            ),
            Center(
              child: LoginForm(),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool isLoading = false;

  bool visibility = false;

  void toggleChange() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset("assets/logo.png")),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Admin Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                "Enter your email and password.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: emailController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: null,
                    labelText: "Email Address"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
                controller: passwordController,
                obscureText: visibility,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: visibility
                        ? IconButton(
                            onPressed: toggleChange,
                            icon: Icon(Icons.visibility))
                        : IconButton(
                            onPressed: toggleChange,
                            icon: Icon(Icons.visibility_off)),
                    border: null,
                    labelText: "Password"),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                  title: "Login",
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  callback: () {
                    signinMethod(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString());
                  },
                  isLoading: isLoading)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signinMethod(
      {required String email, required String password}) async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = await FirebaseServicies()
            .signInWithEmailAndPassword(email, password);

        if (user != null) {
          log(user.uid);
          log(user.email.toString());
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        } else {
          // show snackbar
        }
      } catch (e) {
        log(e.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
