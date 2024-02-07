import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_enhanced_barcode_scanner/flutter_enhanced_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:gallery_camera_image_picker_view/gallery_camera_image_picker_view.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../helpers/methods.dart';

class ProductEntry extends StatelessWidget {
  ProductEntry({Key? key}) : super(key: key);

  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierPhoneController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController lowStockLevelController = TextEditingController();
  TextEditingController taxController = TextEditingController();

  final player = AudioPlayer();


  final controller = GalleryCameraImagePickerController();
  
  StoreController _storeController = Get.find();
  
  FirebaseFirestore fs = FirebaseFirestore.instance;

  Methods _methods = Methods();


  String category = '';
  String supplier = '';

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      backgroundColor: Karas.secondary,
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(18),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('New Product Entry', style: title1,),
            SizedBox(height: 8,),
            Text("Enter the product you'll be selling.", style: title4,),
            SizedBox(height: 20,),
            CardItems(
                head: CardItemsHeader(title: 'Category'),
                body: Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: fs.collection('categories')
                            .where('store_id', isEqualTo: _storeController.store.value.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData&&snapshot.data!.size>0?
                          DropdownSearch<String>(
                            items: [
                              ...
                                  snapshot.data!.docs.map((e) => e.get('name'))
                            ],
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              fit: FlexFit.loose,
                              disabledItemFn: (String s) => s.startsWith('I'),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 15,
                                  vertical: 15
                                ),
                                filled: true,
                                fillColor: Karas.secondary
                              )
                            ),
                            dropdownButtonProps: DropdownButtonProps(

                            ),
                            onChanged:(value)=> category=value!,
                            selectedItem: "Select Category",
                          ):Container();
                        }
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                )
            ),
            SizedBox(height: 16),
            CardItems(
                head: CardItemsHeader(title: 'Product Details'),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      FormInputField(
                          isNumeric: false,
                          controller: productNameController,
                          backgroundColor: Karas.secondary,
                          placeholder: 'Product Name',
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: true,
                        controller: priceController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Price',
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: true,
                        controller: quantityController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Stock Quantity',
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: true,
                        controller: lowStockLevelController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Low Stock Level',
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: true,
                        controller: costPriceController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Cost Price',
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: false,
                        controller: unitController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Unit of Measure',
                      ),
                      SizedBox(height: 15,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FormInputField(
                              isNumeric: false,
                              controller: barcodeController,
                              backgroundColor: Karas.secondary,
                              placeholder: 'Barcode / QR Code',
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: 50,
                            height: 47,
                            child: Button2(
                                height: 47,
                                backgroundColor: Karas.background,
                                content: Icon(Icons.barcode_reader, color: Karas.primary,),
                                tap: ()async{
                                  String barcode = await FlutterBarcodeScanner.scanBarcode('#3b8f68', 'Cancel', false, ScanMode.DEFAULT);
                                  if(barcode.contains('-')||barcode.length<10){
                                    player.setAsset('assets/barcode_failed.mp3');
                                    player.play();
                                  }else{
                                    barcodeController.text = barcode;
                                    player.setAsset('assets/barcode_scanned.mp3');
                                    player.play();

                                  }
                                }
                            )
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: true,
                        controller: taxController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Tax (%)',
                      ),
                      SizedBox(height: 15,),
                      FormInputField(
                        isNumeric: false,
                        controller: descriptionController,
                        backgroundColor: Karas.secondary,
                        placeholder: 'Product Description',
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
            ),
            SizedBox(height: 15),
            CardItems(
                head: CardItemsHeader(title: 'Product Images'),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      GallaryCameraImagePickerView(
                        controller: controller,
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
            ),
            SizedBox(height: 15),
            CardItems(
                head: CardItemsHeader(title: 'Supplier Information', seeallbtn: InkWell(
                    onTap: (){
                      _methods.addSupplier(fs);
                    },
                    child: Container(child: Text('Add Supplier', style: title3,))),
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      StreamBuilder(
                          stream: fs.collection('supplier')
                              .where('store_id', isEqualTo: _storeController.store.value.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData&&snapshot.data!.size>0?
                            DropdownSearch<String>(
                              items: [
                                ...
                                snapshot.data!.docs.map((e) => e.get('name'))
                              ],
                              popupProps: PopupProps.menu(
                                showSelectedItems: true,
                                fit: FlexFit.loose,
                                disabledItemFn: (String s) => s.startsWith('I'),
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 15,
                                          vertical: 15
                                      ),
                                      filled: true,
                                      fillColor: Karas.secondary
                                  )
                              ),
                              dropdownButtonProps: DropdownButtonProps(

                              ),
                              onChanged:(value)=> supplier=value!,
                              selectedItem: "Select Supplier",
                            ):Container();
                          }
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
            ),
            SizedBox(height: 15),
            Button1(
                height: 35,
                label: 'SAVE',
                tap: ()async{
                   if(category.isNotEmpty&&productNameController.text.isNotEmpty&&priceController.text.isNotEmpty){
                     Get.dialog(
                         Container(
                             child: Center(
                                 child: LoadingAnimationWidget.flickr(rightDotColor: Karas.primary, size: 40, leftDotColor: Colors.deepOrange)
                             )
                         ),
                         barrierColor: Colors.black26,
                         barrierDismissible: false
                     );
                     await _methods.addProduct(
                         category:category,
                         productName:productNameController.text,
                         price:priceController.text,
                         images:controller.pathList,
                         costPrice:costPriceController.text,
                         unit:unitController.text,
                         description:descriptionController.text,
                         barcode:barcodeController.text,
                         quantity:quantityController.text,
                         tax: taxController.text,
                         supplier: supplier,
                         lowStockLevel: lowStockLevelController.text.isNotEmpty?lowStockLevelController.text:'0'
                     );

                     productNameController.clear();
                     priceController.clear();
                     costPriceController.clear();
                     barcodeController.clear();
                     quantityController.clear();
                     unitController.clear();
                     descriptionController.clear();
                     controller.pathList.clear();
                     taxController.clear();

                     Get.back();
                     _methods.showSnackBar(context, 'Product Added Successfully');
                   }
                }
            )
          ],
        ),
      ),
    )
    );
  }
}
