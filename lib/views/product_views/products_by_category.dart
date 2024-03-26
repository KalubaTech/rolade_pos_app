import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_enhanced_barcode_scanner/flutter_enhanced_barcode_scanner.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:get/get.dart';
import '../../components/product_item_container.dart';

class ProductsByCategory extends StatefulWidget {
  String category;
  ProductsByCategory(this.category);

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
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
                title: Text('${widget.category}'),
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
                              initialList: productController.products.value.where((e)=>e.category==widget.category).toList(),
                              builder: (c,i,product) => ProductItemContainer(product, true),
                              filter: (value) => productController.products,
                              emptyWidget:  Container(
                                child: Center(
                                    child: Text('No matches')
                                ),
                              ),
                              inputDecoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Search product',
                                contentPadding: EdgeInsets.only(left: 20),
                                suffixIcon: TouchRippleEffect(
                                  rippleColor: Karas.background,
                                    onTap: ()async{
                                      String barcode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);
                                      if(barcode.toString().contains('-')||barcode.toString().length<10){
                                        player.setAsset('assets/barcode_failed.mp3');
                                        player.play();
                                      }else{
                                        player.setAsset('assets/barcode_scanned.mp3');
                                        player.play();
                                        searchController.text = barcode;
                                        setState((){});
                                        //_methods.productBarcodeDialog(barcode);
                                      }
                                    },
                                    child: Icon(Icons.barcode_reader)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Karas.primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),

                                ),
                              ),
                            ):Container()
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
