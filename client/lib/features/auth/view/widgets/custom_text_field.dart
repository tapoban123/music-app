import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool isObsecureText;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.isObsecureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: isObsecureText,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing";
        } else {
          return null;
        }
      },
    );
  }
}
