import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/category_item.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/cart/cart.dart';
import 'package:rolade_pos/views/product_views/edit_product.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/products_controller.dart';
import '../../controllers/store_controller.dart';
import '../../controllers/user_controller.dart';
import '../../helpers/creds.dart';
import '../../helpers/methods.dart';


class ProductDetails extends StatelessWidget {
  ProductModel product;
  ProductDetails(this.product);

  PageController pageController = PageController();
  
  Methods _methods = Methods();
  StoreController _storeController = Get.find();
  UserController _userController = Get.find();
  CartController _cartController = Get.find();


  @override
  Widget build(BuildContext context) {

    bool isAdmin = _userController.user.value.email == _storeController.store.value.email?true:false;

    return SafeArea(
        child: GetBuilder<ProductsController>(
          builder: (productController) {
            return DraggableHome(
              appBarColor: Karas.primary,
              alwaysShowLeadingAndAction: true,
              headerExpandedHeight: 0.49,
              actions: [
                PopupMenuButton(
                    itemBuilder: (context)=> [
                      PopupMenuItem(
                        enabled: isAdmin,
                        child: Row(
                          children: [
                            Expanded(child: Text('Edit')),
                            Icon(Icons.edit, color: Colors.blue,size: 15,)
                          ],
                        ),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        enabled: isAdmin,
                        child:Row(
                          children: [
                              Expanded(child: Text('Delete'),),
                              Icon(Icons.delete, color: Colors.red,size: 15,)
                          ],
                        ),
                        value: 'delete',
                      ),
                    ],
                    onSelected: (value){
                      switch(value){
                        case 'edit':
                          Get.to(()=>EditProduct(product));
                      }
                    }
                )
              ],
              title: Text('Product Details'),
              headerWidget: Container(
                color: Karas.primary,
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                       children: [
                         ...
                             product.images.map((e) => CachedNetworkImage(
                                 fit: BoxFit.cover,
                                 imageUrl: e.toString()),
                             ).toList()
                       ],
                    ),
                    Positioned(
                      bottom: 40,
                      child: Container(
                        width: Get.width,
                        child: Center(
                          child: SmoothPageIndicator(
                                controller: pageController,  // PageController
                                count:  product.images.length,
                                effect:  WormEffect(
                                  dotColor: Colors.white,
                                  dotHeight: 6,
                                  dotWidth: 30,
                                  activeDotColor: Karas.primary
                                ),  // your preferred effect
                                onDotClicked: (index){

                                }
                            ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: [
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${product.productName}', style: title1,),
                          Text('K${_methods.formatNumber(double.parse(product.price))}', style: titleprimary,),
                        ],
                      ),
                      Text('${product.description}', style: title2,),
                      SizedBox(height: 5,),
                      InkWell(
                        onTap: ()=>_methods.productQtyDialog(product, context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                              color: Karas.background,
                              borderRadius: BorderRadius.circular(20)
                            ),
                          child: Text('${product.quantity}', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),),
                        ),
                      )

                    ],

                ),
                ),
                SizedBox(height: 18,),
                CardItems(
                    head: CardItemsHeader(title: 'More Products'),
                    body: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child:
                              productController.products.isNotEmpty?
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: productController.products.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemBuilder: (context, index){
                                    ProductModel productModel = productController.products.value[index];
                                    return SmallProductContainer(image: productModel.images.first, title: '${productModel.productName} (${productModel.quantity})', id: productModel.id, product: productModel);
                                  },
                                ):
                                Container(
                                  child: Text('')
                                ),

                        ),
                        SizedBox(height: 20)
                      ],
                    )
                )
              ],
              bottomSheet: double.parse(product.quantity)>0?GetBuilder<CartController>(
                builder: (cartController) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                         Expanded(
                           child: Button2(
                             backgroundColor: Karas.secondary,
                             border: Border.all(color: Karas.primary),
                             width: 120,
                               height: 40,
                               content: Text('${_cartController.cart.value.map((e) => e.product['productId']).toList().contains(product.id)?'View In Cart':'Add to Cart'}', style: title3,),
                               tap: (){
                                 _cartController.cart.value.map((e) => e.product['productId']).toList().contains(product.id)?
                                     Get.to(()=>Cart()):_methods.productToCartDialog(product, context);
                               }
                           ),
                         ),
                         SizedBox(width: 30,),
                         Expanded(
                           child: Button2(
                             border: Border.all(color: Karas.primary),
                             width: 120,
                               height: 40,
                               content: Text('Sell Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
                               tap: (){
                                 _methods.saleDirect(product, context);
                               }
                           ),
                         ),
                      ],
                    ),
                  );
                }
              ):Container(
                decoration: BoxDecoration(
                  color: Karas.background
                ),
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Center(child: Text('Out Of Stock', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500, fontSize: 14))),
                    SizedBox(height: 10),
                    Creds().admin()?Button1(label: 'Re-stock', tap:()=>_methods.productQtyDialog(product, context)):Container()
                  ],
                ),
              ),
            );
          }
        )
    );
  }
}
