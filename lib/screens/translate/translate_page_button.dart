import 'package:flutter/material.dart';

class TranslateWidget extends StatelessWidget {
  const TranslateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 10,
      child: Builder(builder: (context) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Icon(Icons.translate, color: Colors.amber.shade50),
        );
      }),
    );
  }
}
