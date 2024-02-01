import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';
import 'form_components/button2.dart';


class CartItemContainer extends StatelessWidget {
  CartItemModel cartItem;
  CartController controllers;

  CartItemContainer(this.cartItem, this.controllers);

  ProductsController _productsController = Get.find();

  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                  imageUrl: _productsController.products.where((p0) => p0.id==cartItem.product['productId']).first.images.first,
                  width: 100,
                  fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(_productsController.products.where((p0) => p0.id==cartItem.product['productId']).first.productName)),
                    Text('K${_methods.formatNumber(cartItem.price.toDouble())}', style: title4,),
                  ],
                ),
              ),
          ),
          Container(
            width: 120,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  child: Button2(
                    height: 35,
                    width: 35,
                    content: Center(
                      child: Icon(Icons.remove, color: Colors.white,),
                    ),
                    tap: () {
                      if(controllers.cart.where((element) => element == cartItem).first.qty>1){
                        //Get price from products controller using cart
                       var price = _productsController.products.where((p0) => p0.id==controllers.cart.where((element) => element == cartItem).first.product['productId']).first.price;
                      controllers.cart.where((element) => element == cartItem).first.qty--;
                      controllers.cart.where((element) => element == cartItem).first.price = (controllers.cart.where((element) => element == cartItem).first.qty*double.parse(price)).toInt();
                      controllers.update();
                    }
                    },
                  ),
                ),
                Container(
                  width: 35,
                  height: 50,
                  child: Center(child: Text('${cartItem.qty}')),
                ),
                Container(
                  width: 35,
                  height: 35,
                  child: Button2(
                    height: 35,
                    width: 35,
                    content: Center(
                      child: Icon(Icons.add, color: Colors.white,),
                    ),
                    tap: () {
                      if(int.parse(_productsController.products.where((p0) => p0.id==controllers.cart.where((element) => element == cartItem).first.product['productId']).first.quantity)>controllers.cart.where((element) => element == cartItem).first.qty){

                        controllers.cart.where((element) => element == cartItem).first.qty++;
                        controllers.cart.where((element) => element == cartItem).first.price = (controllers.cart.where((element) => element == cartItem).first.qty.toDouble()*double.parse(_productsController.products.where((p0) => p0.id==controllers.cart.where((element) => element == cartItem).first.product['productId']).first.price)).toInt();
                        controllers.update();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
