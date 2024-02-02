import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/components/cart_item_container.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/cart_controller.dart';
import '../../models/cart_item_model.dart';
import '../checkout.dart';

class Cart extends StatefulWidget {
  Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Methods _methods = Methods();

  var selectedItems = <CartItemModel>[].obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<CartController>(
          builder:(controller)=>  DraggableHome(
              backgroundColor: Karas.secondary,
                centerTitle: true,
                appBarColor: Karas.primary,
                headerExpandedHeight: 0.09,
                alwaysShowLeadingAndAction: true,
                title: Container(
                  child: Text('Cart'),
                ),
                actions: [
                  selectedItems.value.isNotEmpty?
                  IconButton(onPressed: (){
                    int length = selectedItems.length;
                    for(CartItemModel item in selectedItems){
                      controller.cart.value.remove(item);
                      controller.update();
                      setState(() {
                        selectedItems.value.remove(item);
                        controller.update();
                      });
                    }
                  }, icon: Icon(Icons.delete, color: Colors.white,)):
                      Container()
                ],
                headerWidget: Container(
                  color: Karas.primary,

                ),
                body: [
                  Container(
                    child: controller.cart.isNotEmpty?
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ...
                          controller.cart.value.map((e) =>
                              InkWell(
                                  onLongPress: (){
                                    selectedItems.contains(e)?selectedItems.value.remove(e):selectedItems.value.add(e);
                                    setState((){
                                      controller.update();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(child: CartItemContainer(e,controller)),
                                      selectedItems.value.isNotEmpty?Checkbox(value: selectedItems.contains(e), onChanged: (value){
                                        selectedItems.contains(e)?selectedItems.value.remove(e):selectedItems.value.add(e);
                                        setState(() {

                                        });
                                      }):Container()
                                    ],
                                  )
                              )).toList()
                        ],
                      ):
                    Container(
                      height: Get.height-250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/empty_cart.png', width: 200,),
                          SizedBox(height: 10),
                          Text('EMPTY!', style: title1,),
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 40),
                              child: Text('Add Items To Cart By Scanning With Barcode Or Direct From Your Store.', textAlign: TextAlign.center, style: title2,),

                          )
                        ],
                      ),
                    )
                  ),
                  SizedBox(height: 80,)
                ],
              bottomSheet: controller.cart.isNotEmpty?Container(

                height: 60,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 8,horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total'),
                              Text(
                                  'K${_methods.formatNumber(controller.cart.value.map<double>((e) => e.price.toDouble()).toList().reduce((value, element) => value+element))}',
                                  style: title1,
                              )
                            ],
                          ),
                        )
                    ),
                    Container(
                      width: 140,
                      height: 40,
                      child: Button2(
                          width: 140,
                          height: 40,
                          content: Text('Sale', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          tap: (){
                             Get.to(()=>Checkout());
                          }
                      ),
                    ),
                    SizedBox(width: 16,)
                  ],
                ),
              ):
              Container(
                color: Karas.secondary,
                height: 60,width: double.infinity,
              ),
            ),
          ),

    );
  }
}
