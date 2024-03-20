import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:get/get.dart';

import '../styles/colors.dart';
import '../views/product_views/product_details.dart';

class BigItem extends StatelessWidget {
  ProductModel product;

  BigItem({required this.product});
  
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
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: product.images.first??'',
                  errorWidget: (c,i,e)=>Image.asset('assets/category.png'),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text(product.productName, style:
          TextStyle(
              color: int.parse(product.quantity)==0?Colors.red:int.parse(product.quantity)<int.parse(product.lowStockLevel)?Colors.orange:Karas.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600
          ),
            maxLines: 1, overflow: TextOverflow.ellipsis,),
          Text('K${_methods.formatNumber(double.parse(product.price))}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
