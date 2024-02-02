import 'dart:ui';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/controllers/cart_controller.dart';
import 'package:rolade_pos/controllers/ordersController.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:get/get.dart';
import 'package:rolade_pos/controllers/user_controller.dart';
import 'package:rolade_pos/controllers/workdays_controller.dart';
import 'package:rolade_pos/helpers/pdf_gen.dart';
import 'package:rolade_pos/models/cart_item_model.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/models/store_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../components/form_components/button1.dart';
import '../components/form_components/form_input_field.dart';
import '../models/order_model.dart';
import '../models/workday_model.dart';
import '../styles/colors.dart';
import '../styles/title_styles.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Methods {

  StoreController _storeController = Get.find();
  CartController _cartController = Get.find();
  UserController _userController = Get.find();
  ProductsController _productsController = Get.find();

  WorkdaysController _workdaysController = Get.find();


  void getMyStore(String email) async {
    try {

      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('store_user')
          .where('user', isEqualTo: email)
          .get();

      if (userQuery.size > 0) {
        DocumentSnapshot storeDocument = await FirebaseFirestore.instance
            .collection('store')
            .doc(userQuery.docs.first.get('store_id'))
            .get();

        _storeController.store.value = StoreModel(
          id: storeDocument.id,
          name: storeDocument.get('name'),
          email: storeDocument.get('email'),
          description: storeDocument.get('description'),
          datetime: storeDocument.get('datetime'),
        );

        QuerySnapshot productQuery = await FirebaseFirestore.instance
            .collection('product')
            .where('store_id', isEqualTo: storeDocument.id)
            .get();

        QuerySnapshot workdaysQuery = await FirebaseFirestore.instance.collection('working_hours')
            .where('store_id',isEqualTo:_storeController.store.value.id).orderBy('day')
            .get();

        List<ProductModel> products = productQuery.docs.map((e) {
          return ProductModel(
            id: e.id,
            productName: e.get('name'),
            price: '${e.get('price')}',
            description: e.get('description'),
            quantity: '${e.get('quantity')}',
            images: e.get('images'),
            tax: '${e.get('tax')}',
            supplierName: e.get('supplierName'),
            supplierPhone: e.get('supplierPhone'),
            category: e.get('category'),
            unit: e.get('unit'),
          );
        }).toList();
        List<WorkDayModel> workdays = workdaysQuery.docs.map((e) {
          return WorkDayModel(
            day: e.get('day'),
            from: e.get('startTime'),
            to: e.get('endTime')
          );
        }).toList();


        _workdaysController.workdays.value = workdays;
        _productsController.products.value = products;
        _workdaysController.update();
        _productsController.update();
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void addCategory(FirebaseFirestore fs){
    TextEditingController categoryController = TextEditingController();
    Get.bottomSheet(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Categories', style: title1),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FormInputField(
                          controller: categoryController,
                          isNumeric: false,
                          placeholder: 'Category',
                          backgroundColor: Karas.secondary,
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 45,
                        height: 50,
                        child: Button1(
                          height: 47,
                          label: 'Add',
                          tap: (){
                            if(categoryController.text.isNotEmpty){
                              FirebaseFirestore.instance.collection('categories').add({
                                'name':categoryController.text,
                                'store_id':_storeController.store.value.id
                              })
                                  .then((value){
                                categoryController.clear();
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder(
                    stream: fs.collection('categories')
                        .where('store_id', isEqualTo: _storeController.store.value.id).snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData&&snapshot.data!.size>0?
                      Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...
                                snapshot.data!.docs.map((e) => ListTile(
                                  title: Text(e.get('name')),
                                  trailing: InkWell(
                                      onTap: ()=>fs.collection('categories').doc(e.id).delete(),
                                      child: Text('Remove', style: TextStyle(color: Colors.red),)
                                  ),
                                ))
                          ],
                        )
                      )
                          :Container();
                    }
                  )
              )
            ],
          ),
        ),
        backgroundColor: Karas.background,
        barrierColor: Colors.black26,
        elevation: 10
    );
  }

  void addUser(FirebaseFirestore fs){
    TextEditingController userNameController = TextEditingController();
    TextEditingController userEmailController = TextEditingController();
    Get.bottomSheet(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
             color: Karas.background
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add User', style: title1),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    FormInputField(
                      controller: userNameController,
                      isNumeric: false,
                      placeholder: 'Full Name',
                      backgroundColor: Karas.secondary,
                    ),
                    SizedBox(height: 8),
                    FormInputField(
                      controller: userEmailController,
                      isNumeric: false,
                      placeholder: 'Email Address',
                      backgroundColor: Karas.secondary,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button1(
                        height: 40,
                        label: 'Add',
                        tap: (){
                          if(userNameController.text.isNotEmpty&&userEmailController.text.isNotEmpty){
                            FirebaseFirestore.instance.collection('store_user').add({
                              'name':userNameController.text,
                              'user':userEmailController.text,
                              'store_id':_storeController.store.value.id,
                              'active':true,
                              'datetime':'${DateTime.now()}'
                            })
                                .then((value){
                              userNameController.clear();
                              userEmailController.clear();
                
                              Get.back();
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        barrierColor: Colors.black26,
        elevation: 10
    );
  }

  void editStore(FirebaseFirestore fs){
    TextEditingController storeNameController = TextEditingController();
    TextEditingController storeDescriptionController = TextEditingController();

    storeDescriptionController.text = _storeController.store.value.description;
    storeNameController.text = _storeController.store.value.name;

    Get.bottomSheet(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
             color: Karas.background
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Store', style: title1),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text('Store Name', style: title2,),
                    SizedBox(height: 5),
                    FormInputField(
                      controller: storeNameController,
                      isNumeric: false,
                      placeholder: 'Store Name',
                      backgroundColor: Karas.secondary,
                    ),
                    SizedBox(height: 8),
                    Text('Description', style: title2,),
                    SizedBox(height: 5),
                    FormInputField(
                      controller: storeDescriptionController,
                      isNumeric: false,
                      placeholder: 'Description',
                      backgroundColor: Karas.secondary,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button1(
                        height: 40,
                        label: 'SAVE',
                        tap: (){
                          if(storeNameController.text.isNotEmpty&&storeDescriptionController.text.isNotEmpty){
                            fs.collection('store').doc(_storeController.store.value.id).update({
                              'name':storeNameController.text,
                              'description':storeDescriptionController.text,
                            })
                                .then((value){
                              _storeController.store.value.name = storeNameController.text;
                              _storeController.store.value.description = storeDescriptionController.text;
                              _storeController.update();
                              storeNameController.clear();
                              storeDescriptionController.clear();

                              Get.back();
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        barrierColor: Colors.black26,
        elevation: 10
    );
  }

  void editUser(DocumentSnapshot user, FirebaseFirestore fs){
    TextEditingController nameController = TextEditingController();
    nameController.text = user.get('name');
    
    var isActive = false.obs;

    isActive.value = user.get('active');

    Get.bottomSheet(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
             color: Karas.background
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Sales Person', style: title1),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text('Store Name', style: title2,),
                    SizedBox(height: 5),
                    FormInputField(
                      controller: nameController,
                      isNumeric: false,
                      placeholder: 'Full Name',
                      backgroundColor: Karas.secondary,
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Row(
                        children: [
                          Text('Active', style: title3,),
                          Obx(() => Switch(value: isActive.value, onChanged: (value)=>isActive.value = value))
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button1(
                        height: 40,
                        label: 'SAVE',
                        tap: (){
                          if(nameController.text.isNotEmpty){
                            fs.collection('store_user').doc(user.id).update({
                              'name':nameController.text,
                              'active':isActive.value,
                            })
                                .then((value){
                              nameController.clear();

                              Get.back();
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        barrierColor: Colors.black26,
        elevation: 10
    );
  }
  void editMyName(FirebaseFirestore fs){
    TextEditingController nameController = TextEditingController();
    nameController.text = _userController.user.value.displayName;


    Get.bottomSheet(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
             color: Karas.background
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Your Name', style: title1),
              SizedBox(height: 30),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text('Name', style: title2,),
                    SizedBox(height: 5),
                    FormInputField(
                      controller: nameController,
                      isNumeric: false,
                      placeholder: 'Name',
                      backgroundColor: Karas.secondary,
                    ),

                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Button1(
                        height: 40,
                        label: 'SAVE',
                        tap: (){
                          if(nameController.text.isNotEmpty){
                            fs.collection('users').doc(_userController.user.value.uid).update({
                              'dispayName':nameController.text,
                            }).then((value){
                              _userController.user.value.displayName = nameController.text;
                              _userController.update();
                              nameController.clear();

                              Get.back();
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        barrierColor: Colors.black26,
        elevation: 10
    );
  }

  void addSupplier(FirebaseFirestore fs){
    TextEditingController supplierNameController = TextEditingController();
    TextEditingController supplierPhoneController = TextEditingController();

    Get.bottomSheet(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Text('Add Suppliers', style: title1),
                  SizedBox(height: 20),
                  FormInputField(
                    isNumeric: false,
                    controller: supplierNameController,
                    backgroundColor: Karas.secondary,
                    placeholder: 'Name',
                  ),
                  SizedBox(height: 10,),
                  FormInputField(
                    isNumeric: true,
                    controller: supplierPhoneController,
                    backgroundColor: Karas.secondary,
                    placeholder: 'Phone Number',
                  ),
                  SizedBox(height: 15),
                  Button1(
                    label: 'Add',
                    tap: (){
                      if(supplierNameController.text.isNotEmpty){
                        FirebaseFirestore.instance.collection('supplier').add({
                          'name':supplierNameController.text,
                          'phone':supplierPhoneController.text,
                          'store_id':_storeController.store.value.id
                        })
                            .then((value){
                          supplierNameController.clear();
                          supplierPhoneController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder(
                    stream: fs.collection('supplier')
                        .where('store_id', isEqualTo: _storeController.store.value.id).snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData&&snapshot.data!.size>0?
                      Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...
                                snapshot.data!.docs.map((e) => ListTile(
                                  title: Text(e.get('name'), style: TextStyle(fontWeight: FontWeight.bold),),
                                  trailing: InkWell(
                                      onTap: ()=>fs.collection('supplier').doc(e.id).delete(),
                                      child: Text('Remove', style: TextStyle(color: Colors.red),)
                                  ),
                                ))
                          ],
                        )
                      )
                          :Container();
                    }
                  )
              )
            ],
          ),
        ),
        backgroundColor: Karas.background,
        barrierColor: Colors.black26,
        elevation: 10
    );
  }

  List<String> uploadedImages = [];

  Future<String> uploadImage(String image) async {


    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('product_images/${image}${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = storageReference.putFile(File(image));

    await uploadTask.whenComplete(() => print('Image uploaded'));
    String downloadURL = await storageReference.getDownloadURL();
    uploadedImages.add(downloadURL);
    return downloadURL;
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message, style: TextStyle(color: Colors.white),)),
        duration: Duration(seconds: 3), // Adjust the duration as needed
        backgroundColor: Colors.black87,
      ),
    );
  }
  
 addProduct({
       required String category,
       required String productName,
       required String price,
       required List<String> images,
       String? costPrice,
       String? unit,
       String? description,
       String? supplierName,
       String? supplierPhone,
       String? barcode,
       String? quantity,
       String? tax,
       String? supplier
  })async{
          for(String image in images){
            await uploadImage(image);
          }
          FirebaseFirestore.instance.collection('product')
              .add({
                  'category':category,
                  'name':productName,
                  'price':price,
                  'cost':costPrice??'0',
                  'unit':unit??'',
                  'description':description??'',
                  'supplierName':supplierName??'',
                  'supplierPhone':supplierPhone??'',
                  'barcode':barcode??'',
                  'images':uploadedImages,
                  'quantity':quantity??'0',
                  'store_id': _storeController.store.value.id,
                  'tax':tax??'0',
                  'supplier':supplier??''
                }).then((value) {
                  uploadedImages.clear();
                }
          );
          

        }

 editProduct({
       required productID,
       required String category,
       required String productName,
       required String price,
       String? costPrice,
       String? unit,
       String? description,
       String? supplierName,
       String? barcode,
       String? quantity,
       String? tax,
       String? supplier
  })async{

        await  FirebaseFirestore.instance.collection('product')
              .doc(productID)
              .update({
                  'category':category,
                  'name':productName,
                  'price':price,
                  'cost':costPrice??'0',
                  'unit':unit??'',
                  'description':description??'',
                  'supplierName':supplierName??'',
                  'barcode':barcode??'',
                  'quantity':quantity??'0',
                  'store_id': _storeController.store.value.id,
                  'tax':tax??'0',
                  'supplier':supplier??''
                }).then((value) {
                  getMyStore(_userController.user.value.email);
                }
          );


        }

  String formatNumber(double price) {
    NumberFormat formatter = NumberFormat.decimalPattern();

    // Format the price and return the result
    return formatter.format(price);
  }
        
  void productBarcodeDialog(String barcode){
          var qty = 1.obs;

          Get.defaultDialog(
            title: '',
            titlePadding: EdgeInsets.zero,
            content: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('product')
                  .where('barcode', isEqualTo: barcode)
                  .where('store_id', isEqualTo: _storeController.store.value.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.size > 0) {
                  DocumentSnapshot document = snapshot.data!.docs.first;
                  ProductModel product = 
                  ProductModel(
                      id: document.id,
                      productName: document.get('name'),
                      price: document.get('price'),
                      description:document.get('description'),
                      quantity: '${document.get('quantity')}',
                      images: document.get('images').map<String>((e)=>e.toString()).toList(),
                      tax: document.get('tax'),
                      supplierName: document.get('supplierName'),
                      supplierPhone: document.get('supplierPhone'),
                      category: document.get('category'),
                      unit: document.get('unit')
                  );
                  return Container(
                  child: Column(
                    children: [
                      Container(
                        color: Karas.secondary,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                   width: 70,
                                   height: 72,
                                   fit: BoxFit.cover,
                                  imageUrl: product.images.first,
                                  errorWidget: (c,e,i)=>Image.asset('assets/placeholder.webp'),
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
                                      Text('K${formatNumber(double.parse(product.price))}', style: title1,),
                                      Text('${formatNumber(double.parse(product.quantity))} remaining', style: title4,),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Obx(
                              ()=> Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Total', style: title2,),
                                            Text(
                                              'K${formatNumber(double.parse(product.price)*qty.value)}',style: title1,
                                            ),
                                          ],
                                        ),
                                      )
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
                                              qty.value>1?qty.value--:null;
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: 35,
                                          height: 50,
                                          child: Center(child: Text('${qty.value}')),
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
                                              qty.value<int.parse(product.quantity)?qty.value++:null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: Button2(
                                        backgroundColor: Colors.orange,
                                        content: Text('Add to Cart',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                        tap: (){
                                          CartItemModel item = CartItemModel(product: {'productId':product.id,'quantity':'${qty.value}'}, qty: qty.value, price: (qty.value.toDouble()*double.parse(product.price)).toInt(),tax: (qty.value * double.parse(product.tax)), datetime: '${DateTime.now()}');
                                          _cartController.addToCart(item);
                                          Get.back();
                                          showSnackBar(context, 'Product Added to Cart, Successfully.');
                                        }
                                    )
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                    child: Button2(
                                        backgroundColor: Karas.primary,
                                        content: Text('Sale', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                        tap: (){

                                        }
                                    )
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
                );
                } else {
                  return Container();
                }
              }
            ),
          );
        }
  void productToCartDialog(ProductModel product, context){
          var qty = 1.obs;

          Get.defaultDialog(
            title: '',
            titlePadding: EdgeInsets.zero,
            content: Container(
                child: Column(
                  children: [
                    Container(
                      color: Karas.secondary,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              width: 70,
                              height: 72,
                              fit: BoxFit.cover,
                              imageUrl: product.images.first,
                              errorWidget: (c,e,i)=>Image.asset('assets/placeholder.webp'),
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
                                    Text('K${formatNumber(double.parse(product.price))}', style: title1,),
                                    Text('${formatNumber(double.parse(product.quantity))} remaining', style: title4,),
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Obx(
                                ()=> Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Total', style: title2,),
                                          Text(
                                            'K${formatNumber(double.parse(product.price)*qty.value)}',style: title1,
                                          ),
                                        ],
                                      ),
                                    )
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
                                            qty.value>1?qty.value--:null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 35,
                                        height: 50,
                                        child: Center(child: Text('${qty.value}')),
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
                                            qty.value<int.parse(product.quantity)?qty.value++:null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: Button2(
                                      backgroundColor: Colors.orange,
                                      content: Text('Add to Cart',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                      tap: (){
                                        CartItemModel item = CartItemModel(product: {'productId':product.id,'qty':'${qty.value}'}, qty: qty.value, price: (qty.value.toDouble()*double.parse(product.price)).toInt(),tax: (qty.value * double.parse(product.tax)), datetime: '${DateTime.now()}');
                                        _cartController.addToCart(item);
                                        Get.back();
                                        showSnackBar(context, 'Product Added to Cart, Successfully.');
                                      }
                                  )
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  child: Button2(
                                      backgroundColor: Karas.primary,
                                      content: Text('Order Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                      tap: (){

                                      }
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          );
        }
  void productQtyDialog(ProductModel product, context){
          var qty = int.parse(product.quantity).obs;

          Get.defaultDialog(
            title: 'RE-STOCK PRODUCT',
            titleStyle: title1,
            titlePadding: EdgeInsets.symmetric(vertical: 20),
            content: Container(
                child: Column(
                  children: [
                    Container(
                      color: Karas.secondary,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              width: 70,
                              height: 72,
                              fit: BoxFit.cover,
                              imageUrl: product.images.first,
                              errorWidget: (c,e,i)=>Image.asset('assets/placeholder.webp'),
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
                                    Text('K${formatNumber(double.parse(product.price))}', style: title1,),
                                    Text('${formatNumber(double.parse(product.quantity))} remaining', style: title4,),
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Obx(
                                ()=> Row(
                              children: [
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
                                            qty.value>1?qty.value--:null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 35,
                                        height: 50,
                                        child: Center(child: Text('${qty.value}')),
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
                                            qty.value++;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: Button2(
                                      backgroundColor: Colors.orange,
                                      content: Text('Cancel',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                      tap: (){
                                        Get.back();
                                      }
                                  )
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  child: Button2(
                                      backgroundColor: Karas.primary,
                                      content: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                      tap: (){
                                         FirebaseFirestore.instance.collection('product').doc(product.id).
                                          update({'quantity':qty.value});

                                         _productsController.products.value
                                             .where((element) => element.id==product.id).first.quantity = qty.value.toString();
                                         _productsController.update();
                                         Get.back();
                                      }
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          );
        }

  String generateOrderNumber() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time as needed
    String formattedDateTime = DateFormat('yyyyMMddHHmmss').format(now);

    // Generate a unique order number by adding some additional information
    String orderNumber = 'ORD-$formattedDateTime';

    return orderNumber;
  }
  double calculateDaySales(List<OrderModel>snapshot,int day){
    double totalSales = 0.0;

    DateTime today = DateTime.now();
    DateTime todayStart = DateTime(today.year, today.month, today.day-day);
    DateTime todayEnd = todayStart.add(Duration(days: 1));

    List<String> totalSalesList = snapshot
        .where((element) {
      // Convert Firestore Timestamp to DateTime
      DateTime elementDateTime = DateTime.parse(element.date.toString());

      // Check if the element's datetime is within today
      return elementDateTime.isAfter(todayStart) && elementDateTime.isBefore(todayEnd) && element.user == _userController.user.value.uid;
    })
        .map<String>((e) => e.total.toString())
        .toList();

// Summing up the total sales
    totalSales = totalSalesList.isEmpty
        ? 0.0
        : totalSalesList.map((total) => double.parse(total)).reduce((value, element) => value + element);

    return totalSales;
  }

  DateTime selectedDate = DateTime.now();

  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      print(picked);
    }
    return selectedDate;
  }


  double salesByDate(String date){
    OrdersController _orderController = Get.find();

    double total = 0.0;

    Iterable<OrderModel> filtered = _orderController.orders.value.where((p0) => p0.date.split(' ').first==date);

    if(filtered.isNotEmpty){
      total = filtered.map((e) => e.total).reduce((value, element) => value+element);
    }

    print(total);
    return total;
  }


}