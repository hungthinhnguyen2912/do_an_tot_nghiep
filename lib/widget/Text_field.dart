import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obs;
  final TextEditingController controller;
  const MyTextField({super.key, required this.hintText, required this.obs, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
      obscureText: obs,
      controller: controller,
    );
  }
}