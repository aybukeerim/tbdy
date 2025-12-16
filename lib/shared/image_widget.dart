import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  String imageSrc;
  Color color;

  ImageWidget(
      this.imageSrc,
      this.color, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageSrc,
      color: color,
      width: 30,
      height: 30,
    );
  }
}
