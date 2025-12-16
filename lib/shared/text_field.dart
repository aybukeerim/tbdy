import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  String title = "";

  TextFieldWidget({
    super.key,
    required this.title,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: false,
      controller: _controller,
      decoration: InputDecoration(
        fillColor: const Color(0xffe8f0fd),
        filled: true,
        hintText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
