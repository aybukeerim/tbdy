import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SampleLinearPage extends StatefulWidget {
  @override
  _SampleLinearPageState createState() => _SampleLinearPageState();
}

class _SampleLinearPageState extends State<SampleLinearPage> {
  String state = 'Animation start';
  bool isRunning = true;

  double progressPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () {
              _showProgressPopup(context, progressPercent);
            },
            child: LinearPercentIndicator(
              lineHeight: 20,
              center: Text('${(progressPercent * 100).toStringAsFixed(0)}%'),
              progressColor: Colors.amber,
              barRadius: Radius.circular(10),
              percent: progressPercent,
              animation: true,
              animationDuration: 1000,
            ),
          ),
        ),
      ],
    );
  }

  void _showProgressPopup(BuildContext context, double progress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Progress"),
          content: Text("Current progress: ${(progress * 100).toStringAsFixed(2)}%"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
