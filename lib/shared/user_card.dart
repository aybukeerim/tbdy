import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 60,
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
            Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.silkscreen(fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
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
          ],
        ),
      ),
    );
  }
}
