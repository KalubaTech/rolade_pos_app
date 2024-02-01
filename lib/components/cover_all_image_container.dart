import 'package:flutter/material.dart';

import '../styles/colors.dart';


class CoverAllImageContainer extends StatelessWidget {
  String image;
  CoverAllImageContainer({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Karas.background,
        image: DecorationImage(image: AssetImage('$image'), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
