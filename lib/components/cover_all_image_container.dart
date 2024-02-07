import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';


class CoverAllImageContainer extends StatelessWidget {
  String image;
  CoverAllImageContainer({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        width: 90,
        imageUrl: '$image',
          fit: BoxFit.cover,
        errorWidget: (e,i,c)=>Container(
          color: Karas.background,
          child: Image.asset('assets/placeholder.webp', fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
