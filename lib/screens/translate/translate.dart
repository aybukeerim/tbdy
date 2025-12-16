import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TestTranslation extends StatefulWidget {
  const TestTranslation({Key? key}) : super(key: key);

  @override
  State<TestTranslation> createState() => _TestTranslationState();
}

class _TestTranslationState extends State<TestTranslation> {
  String translatedText = '';
  String hintText = 'Enter Text';
  String text = '';
  TextEditingController txtController = TextEditingController();

  void clearText() {
    setState(() {
      text = '';
      txtController.text = '';
      translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      //  maxLength: 50,
                      autocorrect: false,
                      controller: txtController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),),
                      ),
                      onChanged: (text) async {
                        setState(() {
                          if (text.isEmpty) {
                            translatedText = '';
                          } else {
                            text
                                .translate(from: 'auto', to: 'en')
                                .then((translation) {
                              setState(() {
                                translatedText = translation.text;
                              });
                            });
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      clearText();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.yellow.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text("Clean"),
                  ),
                ],
              ),
              if (translatedText.isNotEmpty)
                const Divider(
                  height: 15,
                ),
              if (translatedText.isNotEmpty)
                Text(
                  translatedText,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
