
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.context,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String image;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white70,
              child: Row(
                children: [
                  Image.asset(
                    image,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.silkscreen(fontSize: 14),
                        ),
                        SizedBox(height: 8,),
                        Expanded(
                          child: Text(
                            subtitle,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.silkscreen(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
