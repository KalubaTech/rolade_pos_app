import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/controllers/cart_controller.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/views/cart/cart.dart';
import 'package:rolade_pos/views/product_views/product_details.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../styles/colors.dart';
import '../styles/title_styles.dart';


class ProductItemContainer extends StatelessWidget {
  ProductModel product;
  bool hasCartbtn;
  ProductItemContainer(this.product, this.hasCartbtn);

  CartController _cartController = Get.find();

  ProductsController _productsController = Get.find();


  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return TouchRippleEffect(
      rippleColor: Karas.background,
      onTap: ()=>Get.to(()=>ProductDetails(product)),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Karas.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      width: 70,
                      height: 72,
                      fit: BoxFit.cover,
                      imageUrl: product.images.first,
                      errorWidget: (c,e,i)=>Image.asset('assets/placeholder.webp'),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product.productName}', style: title2,),
                          Text('K${_methods.formatNumber(double.parse(product.price))}', style: title1,),
                          Text('${_methods.formatNumber(double.parse(product.quantity))} remaining', style: TextStyle(color: int.parse(product.quantity)<int.parse(product.lowStockLevel)?Colors.red:Karas.primary),),
                        ],
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Karas.secondary,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  !product.supplierName.isBlank!?Row(
                    children: [
                      Text('Supplier: ', style: TextStyle(
                        fontSize: 10
                      ),),
                      Text('${product.supplierName}', style: title2,)
                    ],
                  ):Container(),
                  !product.cost.isBlank!?Row(
                    children: [
                      Text('Costed: ', style: TextStyle(
                          fontSize: 10
                      ),),
                      Text('K${product.cost}', style: title2,)
                    ],
                  ):Container(),
                  !product.stock_quantity.isBlank!?Row(
                    children: [
                      Text('Stock Qty: ', style: TextStyle(
                          fontSize: 10
                      ),),
                      Text('${product.stock_quantity}', style: title2,)
                    ],
                  ):Container(),
                  !product.quantity.isBlank!?Row(
                    children: [
                      Text('Sold: ', style: TextStyle(
                          fontSize: 10
                      ),),
                      Text('K${double.parse(product.stock_quantity)-double.parse(product.quantity)}', style: title2,)
                    ],
                  ):Container(),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
