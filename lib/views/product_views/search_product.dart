import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_enhanced_barcode_scanner/flutter_enhanced_barcode_scanner.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/views/product_views/product_entry.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:get/get.dart';
import '../../components/product_item_container.dart';

class SearchProducts extends StatefulWidget {

  @override
  State<SearchProducts> createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  FirebaseFirestore fs = FirebaseFirestore.instance;

  Methods _methods = Methods();

  final player = AudioPlayer();

  String barcode = '';

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<ProductsController>(
            builder: (productController) {
              return Scaffold(
                backgroundColor: Karas.secondary,
                appBar: AppBar(
                  title: Text('Search Products'),
                  actions: [
                     IconButton(
                         onPressed: (){
                           Get.to(()=>ProductEntry());
                         },
                         icon: Icon(Icons.add)
                     )
                  ],
                  backgroundColor: Karas.primary,
                ),
                body: Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Expanded(
                          child:  productController.products.isNotEmpty
                              ?SearchableList<ProductModel>(
                            searchTextController: searchController,
                            initialList: productController.products.value,
                            builder: (context, index, product) => ProductItemContainer(product,true),
                            filter: (list) {
                              if (list != null) {
                                return productController.products.value.where((product) {
                                  // Check if the search text matches the product name or barcode
                                  return product.productName.toLowerCase().contains(list.toLowerCase()) ||
                                      product.productName.contains(list);
                                }).toList();
                              } else {
                                return [];
                              }
                            },
                            emptyWidget: Container(
                              child: Center(
                                child: Text('No matches'),
                              ),
                            ),
                            inputDecoration: InputDecoration(
                              // Your input decoration configuration here
                            ),
                          )
                              :Container()
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}
