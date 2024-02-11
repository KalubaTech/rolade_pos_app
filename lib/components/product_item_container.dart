import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/controllers/cart_controller.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/views/cart/cart.dart';
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
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Karas.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: Row(
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
                    hasCartbtn?Column(
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: Container()),
                            SizedBox(width: 20,),
                            GetBuilder<CartController>(
                              builder: (controller)=> Container(
                                width: 100,
                                child: controller.cart.value.map((e) => e.product['productId']).toList().contains(product.id)?
                                Button2(
                                    backgroundColor: Karas.background,
                                    content: Text('View In Cart', style: title3),
                                    tap: (){
                                      Get.to(()=>Cart());
                                    }
                                ):
                                Button2(
                                    content: Text('Add to Cart', style: TextStyle(color: Colors.white),),
                                    tap: (){
                                      _methods.productToCartDialog(product, context);
                                    }
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ):Container()
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
