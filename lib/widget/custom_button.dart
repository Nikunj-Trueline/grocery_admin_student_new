import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback callback;
  bool isLoading = false;

  CustomButton(
      {super.key,
        required this.title,
        required this.backgroundColor,
        required this.foregroundColor,
        required this.callback,
        required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
        )
            : Text(
          title,
          style: TextStyle(color: foregroundColor, fontSize: 18),
        ),
      ),
    );
  }
}
