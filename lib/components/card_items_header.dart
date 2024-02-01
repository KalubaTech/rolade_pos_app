import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/title_styles.dart';

class CardItemsHeader extends StatelessWidget {
  String title;
  Widget? seeallbtn;
  CardItemsHeader({required this.title, this.seeallbtn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 15,),
          Row(
            children: [
              Text('$title', style: title2),
              Spacer(),
              seeallbtn??Container()
            ],
          ),
          SizedBox(height: 15,),
          Container(
            height: 0.5,
            color: Karas.background,
          )
        ],
      ),
    );
  }
}
