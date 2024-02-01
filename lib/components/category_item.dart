import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/product_views/product_details.dart';

import '../models/product_model.dart';

class SmallProductContainer extends StatelessWidget {
  String image;
  String title;
  String id;
  ProductModel product;
  SmallProductContainer({required this.image, required this.title, required this.id, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(()=>ProductDetails(product));
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Karas.background,
                borderRadius: BorderRadius.circular(10)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                    width: 80,
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: image??'',
                    errorWidget: (c,i,e)=>Image.asset('assets/category.png'),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text(title, style: title4,maxLines: 1, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}
