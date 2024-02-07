import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_table/flutter_easy_table.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/controllers/ordersController.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/helpers/charts.dart';
import 'package:rolade_pos/models/order_product_model.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../components/card_items.dart';
import '../../components/expandable_table.dart';
import '../../helpers/methods.dart';
import '../../models/order_model.dart';


class SalesOverview extends StatefulWidget {

  SalesOverview();

  @override
  State<SalesOverview> createState() => _SalesOverviewState();
}

class _SalesOverviewState extends State<SalesOverview> {
  Methods _methods = Methods();

  DateTime fromDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  DateTime? toDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  FirebaseFirestore fs = FirebaseFirestore.instance;

  StoreController _storeController = Get.find();
  OrdersController _ordersController = Get.find();
  ProductsController _productsController = Get.find();

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

                                for(Map<dynamic,dynamic>item in order.products){
                                  await _productsController.products.value.where((element){
                                    return element.id == item['productId'];
                                  }).map((e){
                                    orderedProducts.add(
                                        OrderProductModel(name: e.productName, price: e.price, qty: item['qty'], image: e.images.first)
                                    );
                                  });
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
                                            height: 60,
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Karas.primary,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  topLeft: Radius.circular(20)
                                              )
                                            ),
                                            child: Text(order.ordID, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      ...orderedProducts.map((e) => ListTile(
                                                        title: Text(e.name),
                                                        trailing: Text(e.qty)
                                                      ))
                                                    ],
                                                  )
                                                ],
                                              )
                                            ),
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
