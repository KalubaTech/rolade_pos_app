import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../styles/colors.dart';
import '../styles/title_styles.dart';

class AdContainer extends StatelessWidget {
  String image;
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
        height: 100,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18)
        ),
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            CachedNetworkImage(
              width: 90,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: image,
              errorWidget: (e,i,c)=>Container(
                color: Karas.background,
                child: Image.asset('assets/placeholder.webp', fit: BoxFit.cover,),
              ),
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
                    Spacer(),
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
