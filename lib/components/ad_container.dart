import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/title_styles.dart';

class AdContainer extends StatelessWidget {
  Widget image;
  Color backgroundColor;
  String title;
  String details;
  Widget? orderbtn;
  AdContainer(
      {
        required this.image,
        required this.backgroundColor,
        required this.title,
        required this.details,
        this.orderbtn
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 330,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18)
        ),
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              child: image, //
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$title', style: titleprimary,), //
                    SizedBox(height: 8),
                    Text('$details', style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),),//
                    SizedBox(height: 10),
                    orderbtn??Container()//Text('Order Now', style: title3,)
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
