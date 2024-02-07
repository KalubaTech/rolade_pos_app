import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/views/product_views/product_details.dart';
import '../helpers/methods.dart';
import '../models/product_model.dart';
import '../styles/title_styles.dart';

class StockItem extends StatelessWidget {
  ProductModel product;
  StockItem({required this.product});
  
  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Karas.secondary,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 120,
                color: Karas.background,
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: '${product.images.first}'
                ),
              ),
              Positioned(
                bottom: 5,
                left: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10)

                  ),
                  child: Row(
                    children: [
                      Icon(Ionicons.pricetag_outline, color: Colors.orange, size: 15,),
                      Text(' K${_methods.formatNumber(double.parse(product.price))}', style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w700),),
                    ],
                  ),
                )
              )
            ],
          ),
          SizedBox(width: 20,),
          Expanded(
            child: InkWell(
              onTap: ()=>Get.to(()=>ProductDetails(product)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(product.productName, style: title1,),
                    Text(product.description),
                    SizedBox(height: 10,),
                    Text(product.quantity+' Remaining',
                      style: TextStyle(color: int.parse(product.quantity)==0?Colors.red:int.parse(product.quantity)<int.parse(product.lowStockLevel)?Colors.orange:Karas.primary, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Button1(
                            width: 80,
                            label: 'Re-stock',
                            tap: ()=>_methods.productQtyDialog(product, context)
                        ),
                        SizedBox(width: 10,),
                        Button1(
                            backgroundColor: Karas.background,
                            textStyle: TextStyle(color: Karas.primary, fontWeight: FontWeight.bold),
                            width: 100,
                            label: 'Add to Cart',
                            tap: ()=>_methods.productToCartDialog(product, context)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
