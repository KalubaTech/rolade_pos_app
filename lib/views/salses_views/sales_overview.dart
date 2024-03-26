import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_table/flutter_easy_table.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/controllers/ordersController.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/helpers/charts.dart';
import 'package:rolade_pos/helpers/date_formater.dart';
import 'package:rolade_pos/helpers/pdf_gen.dart';
import 'package:rolade_pos/models/order_product_model.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/models/user_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/checkout.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../components/card_items.dart';
import '../../components/expandable_table.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/user_controller.dart';
import '../../helpers/creds.dart';
import '../../helpers/methods.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';
import '../product_views/product_details.dart';


class SalesOverview extends StatefulWidget {

  SalesOverview();

  @override
  State<SalesOverview> createState() => _SalesOverviewState();
}

class _SalesOverviewState extends State<SalesOverview> {
  Methods _methods = Methods();

  DateTime fromDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  DateTime? toDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1);

  FirebaseFirestore fs = FirebaseFirestore.instance;

  StoreController _storeController = Get.find();
  OrdersController _ordersController = Get.find();
  ProductsController _productsController = Get.find();

  CartController _cartController = Get.find();

  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: GetBuilder<OrdersController>(
          builder: (controller) {
            List<OrderModel> data = controller.orders.value
                .where((order) {
                  return DateTime.parse(order.date).millisecondsSinceEpoch
                >=
                fromDate!.millisecondsSinceEpoch &&
                DateTime.parse(order.date).millisecondsSinceEpoch
                    <=
                    toDate!.millisecondsSinceEpoch;
                }

            ).toList();
            return DraggableHome(
              appBarColor: Karas.primary,
                headerExpandedHeight: 0.1,
                alwaysShowTitle: true,
                alwaysShowLeadingAndAction: true,
                title: Text('Sales Overview'),
                headerWidget: Container(
                  color: Karas.primary,
                ),
                body: [
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.filter_alt_outlined,color: Colors.blueGrey,),
                            Text('Filter by Date Range',),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                         Expanded(
                           child: TouchRippleEffect(
                             onTap: () async{
                               fromDate = await _methods.selectDate(context);
                               setState(() {

                               });
                             },
                             rippleColor: Colors.grey.withOpacity(0.5),
                             child: Container(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Karas.secondary,
                                border: Border.all(color: Colors.grey.withOpacity(0.3))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${fromDate}'.split(' ').first.replaceAll('-', '/'), style: title3,),
                                  Icon(Icons.calendar_month_outlined, color: Karas.primary),
                                ],
                              ),
                            ),
                          ),
                        ),
                         SizedBox(width: 20,),
                         Expanded(
                           child: TouchRippleEffect(
                             onTap: () async {
                               toDate = await _methods.selectDate(context);
                               setState(() {

                               });
                             },
                             rippleColor: Colors.grey.withOpacity(0.5),
                             child: Container(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Karas.secondary,
                                border: Border.all(color: Colors.grey.withOpacity(0.3))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${toDate}'.split(' ').first.replaceAll('-', '/'), style: title3,),
                                  Icon(Icons.calendar_month_outlined, color: Karas.primary),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Creds().admin()?StreamBuilder(
                    stream: fs.collection('store_user').where('store_id', isEqualTo: _storeController.store.value.id).snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData?Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                        child: Container(
                          child: DropdownSearch(
                            items: [
                              'All',
                              ...snapshot.data!.docs.map((e) => e.get('name')).toList()
                            ],
                            selectedItem: 'Select Cashier',
                            onChanged: (value){

                            },
                          )
                        ),
                      ): Container();
                    }
                  ):Container(),
                  ElasticInRight(
                      duration: Duration(seconds: 2),
                      child: Text('KALUBA')
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 1,
                          offset: Offset(0, 1)
                        )
                      ]
                    ),
                    padding: EdgeInsets.all(20),
                    height: 200,
                    child: Charts.barChartSales(data),
                  ),
                  Container(
                    child: Container(
                      height: 400,
                      child: Builder(
                          builder: (context){
                            return EasyPaginatedTable(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              rowTail: true,
                              columnSpacing: 20,
                              rowsPerPage: 6,
                              columnStyle: ColumnStyle(
                                columnLabel: 'name',
                                columnStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                rowCellLabel: 'Taha',
                                rowCellStyle: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onEdit: (index) async{
                                OrderModel order = data[index];

                                List<OrderProductModel> orderedProducts = [];

                                for(Map<dynamic,dynamic>item in order.products) {
                                 // print(item);
                                  ProductModel product = _productsController
                                      .products.value.where((element) {
                                    return element.id == item['productId'];
                                  }).first;
                                  orderedProducts.add(
                                      OrderProductModel(id: product.id,
                                          name: product.productName,
                                          price: product.price,
                                          qty: item['quantity'] ?? item['qty'],
                                          image: product.images.first)
                                  );
                                }
                                Get.bottomSheet(
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Karas.primary,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  topLeft: Radius.circular(20)
                                              )
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Order Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                                                SizedBox(height: 8),
                                                Text(order.ordID, style: TextStyle(color: Karas.background, fontWeight: FontWeight.w600, fontSize: 12),),
                                                ],
                                            )
                                          ),
                                          Container(
                                            width: double.infinity,
                                            color: Karas.background,
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(formatDate(order.date), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 12),),
                                                Creds().admin()?Row(
                                                  children: [
                                                    Text('Cashier: ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 11),),
                                                    StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection('users').doc(order.user).snapshots(),
                                                      builder: (context, snapshot) {
                                                        return snapshot.hasData? Text('${snapshot.data!.get('displayName')}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 11),):Container();
                                                      }
                                                    )
                                                  ],
                                                ):Container(),
                                                SizedBox(height: 5,),
                                                Text('Total: K${_methods.formatNumber(order.total)}  |  Cash: K${_methods.formatNumber(order.cash)}  |  Change: K${_methods.formatNumber(order.change)}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 11),),
                                              ],
                                            )
                                          ),
                                          SizedBox(height:5),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Container(height: 1,color: Karas.background,width: 10,),
                                                      Text('Products (${order.quantity})', style: title3,),
                                                      Expanded(child: Container(height: 1,color: Karas.background,))
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: ListView(
                                                      physics: BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      children: [
                                                        ...orderedProducts.map((e){
                                                          ProductModel product = _productsController.products.value.where((element) => element.id==e.id).first;
                                                          return InkWell(
                                                              onTap: ()=>Get.to(()=>ProductDetails(product)),
                                                                child: Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                                  child: Row(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        width: 40,
                                                                        height: 40,
                                                                        fit: BoxFit.cover,
                                                                        imageUrl: '${e.image}',
                                                                        errorWidget: (e,i,c)=>Icon(Icons.image),
                                                                      ),
                                                                      SizedBox(width: 10),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Price: K${e.price}   | Total: K${double.parse(e.price)*int.parse(e.qty)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                                                                            Text(e.name, style: title3,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      CircleAvatar(child: Text(e.qty, style: title2,), radius: 10,backgroundColor: Karas.background,)
                                                    
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                        })
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                            child: Row(
                                              children: [
                                                Expanded(child: Button2(
                                                  backgroundColor: Karas.background,
                                                    content: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.print, color: Karas.primary),
                                                    Text('  Receipt', style: TextStyle(color: Karas.primary),)
                                                  ],
                                                ), tap: (){
                                                    pdfGen(_storeController.store.value, _userController.user.value, order, order.total.toString(), order.subtotal.toString(), order.cash.toString(), order.change.toString(), order.tax.toString(), _productsController);
                                                })),
                                                SizedBox(width: 20,),
                                                Expanded(child: Button2(content: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.payment, color: Colors.white,),
                                                    Text('  Sell Again', style: TextStyle(color: Colors.white),)
                                                  ],
                                                ), tap: (){

                                                    for(Map<String, String> prod in order.products.map((e) => {'productId':e['productId'], 'qty':e['quantity']??e['qty']})){
                                                      ProductModel product = _productsController.products.where((p0) => p0.id==prod['productId']).first;
                                                      CartItemModel cartItem = CartItemModel(product: prod, qty: int.parse(prod['qty']!), price: int.parse(product.price)*int.parse(prod['qty']!), tax: double.parse(product.tax), datetime: '${DateTime.now()}');

                                                      _cartController.cart.value.clear();
                                                      _cartController.cart.value.add(cartItem);
                                                      _cartController.update();

                                                      Get.to(()=>Checkout());
                                                    }

                                                })),
                                              ],
                                            )
                                          )
                                        ],
                                      )
                                    ),
                                );
                              },
                              onDelete: (index) {},
                              columns: const ['Order No.', 'Total Amount', 'Tax'],
                              rows:  data.map<Map<String,String>>((e) =>
                              {
                                'Order No.':e.ordID,
                                'Total Amount': 'K${_methods.formatNumber(e.total)}',
                                'Tax': 'K${_methods.formatNumber(e.tax)}'
                              }
                              ).toList(),
                            );
                          }
                      ),
                    ),
                  ),
                  SizedBox(height: 10,)
                ]
            );
          }
        )
    );
  }
}
