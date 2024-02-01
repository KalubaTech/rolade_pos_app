import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/models/cart_item_model.dart';
import 'package:rolade_pos/models/order_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/pages_anchor.dart';
import '../controllers/cart_controller.dart';
import '../controllers/store_controller.dart';
import '../controllers/user_controller.dart';
import '../helpers/methods.dart';
import '../helpers/notifications.dart';
import '../helpers/pdf_gen.dart';
import '../models/product_model.dart';

class Checkout extends StatelessWidget {
  Checkout({Key? key}) : super(key: key);

  CartController cartController = Get.find();
  StoreController _storeController = Get.find();
  UserController _userController = Get.find();
  Methods _methods = Methods();

  TextEditingController cashController = TextEditingController();

  ProductsController _productsController = Get.find();

  var receipt = true.obs;
  var cash = 0.0.obs;

  @override
  Widget build(BuildContext context) {

    double subtotal = cartController.cart.value.map<double>((e) => e.price.toDouble()).toList().reduce((value, element) => value+element);
    double tax = (cartController.cart.value.map((e) => e.tax.toDouble()).toList().reduce((value, element) => value+element).toDouble()/100)*subtotal;
    double total = subtotal + tax;
    var change = 0.0.obs;

    cashController.addListener(() {
      cash.value = double.parse(cashController.text.isEmpty?'0':cashController.text);
      change.value = (double.parse(cashController.text.isEmpty?'0':cashController.text)-total);
    });
    return DraggableHome(
        appBarColor: Karas.primary,
        title: Text('Checkout'),
        alwaysShowTitle: true,
        headerExpandedHeight: 0.1,
        alwaysShowLeadingAndAction: true,
        headerWidget: Container(color: Karas.primary,),
        bottomSheet: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
          height: 60,
          color: Karas.primary,
          child: Row(
            children: [
              Expanded(child: Container(child: Row(
                children: [
                  Text('Print Receipt', style: TextStyle(color: Colors.white),),
                  Obx(
                      ()=> Switch(
                        value: receipt.value,
                        inactiveThumbColor: Karas.secondary,
                        activeColor: Karas.secondary,
                        onChanged: (value){
                          receipt.value = value;
                        }
                    ),
                  ),
                ],
              ))),
              Container(
                width: 100,
                child: Obx(
                    ()=> Button2(
                      backgroundColor: cash.value<total?Karas.background:Colors.orange,
                      content: Text('Pay', style: TextStyle(color: cash.value<total?Colors.black87:Colors.white, fontWeight: FontWeight.bold),
                      ), tap: ()async{
                      Get.dialog(
                        Container(
                          child: Center(
                            child: LoadingAnimationWidget.flickr(
                              rightDotColor: Karas.primary,
                              size: 40,
                              leftDotColor: Colors.deepOrange,
                            ),
                          ),
                        ),
                        barrierColor: Colors.black26,
                        barrierDismissible: false,
                      );

                      String orderNo = _methods.generateOrderNumber();

                      Map<String, dynamic> orderData = {
                        'orderNo': orderNo,
                        'products': cartController.cart.value.map((e) => e.product).toList(),
                        'datetime': '${DateTime.now()}',
                        'quantity': '${cartController.cart.value.length}',
                        'total': '${total}',
                        'cash': '${cash.value}',
                        'change': '${change.value}',
                        'tax': '${tax}',
                        'subtotal': '${subtotal}',
                        'customer': '',
                        'user': '${_userController.user.value.uid}',
                        'storeId': '${_storeController.store.value.id}',
                      };

                      try {
                        // Add the order to Firestore
                        DocumentReference orderRef =
                        await FirebaseFirestore.instance.collection('order').add(orderData);

                        // Update product quantities
                        for (CartItemModel e in cartController.cart.value) {
                          ProductModel productSnapshot =
                              _productsController.products.value.where((element) => element.id==e.product['productId']).first;


                          int quantity = int.parse(productSnapshot.quantity.toString());
                          int remainingQuantity = quantity - int.parse(e.product['quantity']??'0');

                          await FirebaseFirestore.instance
                              .collection('product')
                              .doc(e.product['productId'])
                              .update({'quantity': '$remainingQuantity'});
                        }

                        Get.back(); // Close the loading dialog

                        if (receipt.value) {
                          pdfGen(
                            _storeController.store.value,
                            _userController.user.value,
                            OrderModel.fromMap(orderData),
                            _methods.formatNumber(total),
                            _methods.formatNumber(subtotal),
                            _methods.formatNumber(cash.value),
                            _methods.formatNumber(change.value),
                            _methods.formatNumber(tax),
                            _productsController,
                          );
                        }

                        _methods.showSnackBar(context, 'Order Is Successful');
                        NotificationsHelper().showNotification('Ordered Successfully', 'An order of order No. ${orderNo} has completed succesfully!');
                        cartController.cart.clear();
                        cartController.update();
                        Get.back();
                      } catch (error) {
                        // Handle errors, show a snackbar, etc.
                        print('Error adding order: $error');
                        Get.back();
                        // Close the loading dialog on error
                      }
                          }
                  ),
                )
              )
            ],
          )
        ),
        body: [
          CardItems(
              head: CardItemsHeader(title: 'Order Summary'),
              body: Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 20),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Subtotal', textAlign: TextAlign.right,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                          child: Text('K${_methods.formatNumber(subtotal)}', textAlign: TextAlign.right,),
                        )
                      ]
                    ),
                    TableRow(
                      children: [
                        Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Tax', textAlign: TextAlign.right,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                          child: Text('K${_methods.formatNumber(tax)}', textAlign: TextAlign.right,),
                        )
                      ]
                    ),
                    TableRow(
                      children: [
                        Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total', textAlign: TextAlign.right,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
                          child: Text('K${_methods.formatNumber(total)}', style: title2,textAlign: TextAlign.right,),
                        )
                      ]
                    ),
                  ],
                ),
              )
          ),
          SizedBox(height: 10,),
          CardItems(
              head: CardItemsHeader(title: 'Payment'),
              body: Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 20),
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Cash: ', textAlign: TextAlign.right,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            child: FormInputField(controller:cashController, isNumeric: true),
                          )
                        ]
                    ),
                    TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Change: ', textAlign: TextAlign.right,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            child: Obx(()=> Text('K${_methods.formatNumber(change.value)}', style: title1,),),
                          )
                        ]
                    ),

                  ],
                ),
              )
          ),

        ]
    );
  }
}
