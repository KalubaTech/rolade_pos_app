import 'package:flutter/material.dart';
import 'package:rolade_pos/styles/colors.dart';

import '../styles/title_styles.dart';


class ListTileCustom extends StatelessWidget {
  String title;
  String? subtitle;

  ListTileCustom({required this.title, String? this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: BorderDirectional(bottom: BorderSide(color: Karas.background))
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${title}', style: title2,),
          Text('${subtitle??''}', style: title3),
        ],
      ),
    );
  }
}
