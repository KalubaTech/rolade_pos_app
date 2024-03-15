import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/product_views/product_details.dart';

import '../helpers/methods.dart';
import '../models/product_model.dart';

class SmallProductContainer extends StatelessWidget {
  String image;
  String title;
  String id;
  ProductModel product;
  SmallProductContainer({required this.image, required this.title, required this.id, required this.product});

  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
        if (currentRoute != null) {
          String currentScreen = currentRoute.settings.name ?? 'Unknown Screen';
          if(currentScreen=='/ProductDetails'){
            _methods.productToCartDialog(product, context);
          }else{
            Get.to(()=>ProductDetails(product));
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(title, style:
          TextStyle(
              color: int.parse(product.quantity)==0?Colors.red:int.parse(product.quantity)<int.parse(product.lowStockLevel)?Colors.orange:Karas.primary,
              fontSize: 13,
            fontWeight: FontWeight.w600
          ),
              maxLines: 1, overflow: TextOverflow.ellipsis,),
          Text('K${_methods.formatNumber(double.parse(product.price))}', style: title4,)
        ],
      ),
    );
  }
}
