import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/form_components/form_input_field.dart';
import 'package:rolade_pos/components/list_tile_custom.dart';
import 'package:rolade_pos/controllers/user_controller.dart';
import 'package:rolade_pos/models/store_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:rolade_pos/views/product_views/product_entry.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../../components/category_item.dart';
import '../../controllers/products_controller.dart';
import '../../controllers/store_controller.dart';
import '../../helpers/methods.dart';
import 'package:get/get.dart';
import '../product_views/products_by_category.dart';

class Store extends StatelessWidget {
  Store({Key? key}) : super(key: key);

  StoreController _storeController = Get.find();
  UserController _userController = Get.find();
  TextEditingController categoryController = TextEditingController();

  FirebaseFirestore fs = FirebaseFirestore.instance;
  Methods _methods = Methods();

  @override
  Widget build(BuildContext context) {
    StoreModel store = _storeController.store.value;
    return SafeArea(
      child: GetBuilder<ProductsController>(
        builder: (productsController) {
          return DraggableHome(
              backgroundColor: Karas.secondary,
              appBarColor: Karas.primary,
              headerExpandedHeight: 0.2,
              title: Container(
                child: Text('Your Store', ),
              ),
              headerWidget: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_storeController.store.value.name}', style: title1,),
                    Text('${store.description}', style: title4,)
                  ],
                ),
              ),
              body: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: BorderDirectional(top: BorderSide(color: Karas.background),bottom: BorderSide(color: Karas.background))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       ListTileCustom(title: '${store.address}', subtitle: 'Address',),
                       ListTileCustom(title: '${store.province}', subtitle: 'Province',),
                       ListTileCustom(title: '${store.district}', subtitle: 'District',),
                       SizedBox(height: 10),
                       Container(
                         height: 100,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20)
                         ),
                         width: double.infinity,
                         child:  ClipRRect(
                         borderRadius: BorderRadius.circular(20),
                           child: GoogleMap(
                               markers: {
                                 Marker(
                                     markerId: MarkerId('2'),
                                     position: LatLng(double.parse(store.latitude), double.parse(store.longitude)),
                                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
                                 )
                               },
                               initialCameraPosition: CameraPosition(
                                   target: LatLng(double.parse(store.latitude), double.parse(store.longitude)),
                                   zoom: 17
                               )
                           ),
                         ),
                       )
                    ],
                  )
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: CardItems(
                    head: CardItemsHeader(
                      title: 'Categories',
                      seeallbtn: _storeController.store.value.admins.contains(_userController.user.value.email)?InkWell(
                          child: Text('Add', style: title3,),
                          onTap: ()=>_methods.addCategory(fs),
                      ):Container(),
                    ),
                    body: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      height: 120,
                      child: StreamBuilder(
                        stream: fs.collection('categories')
                            .where('store_id', isEqualTo: _storeController.store.value.id).snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData&&snapshot.data!.size>0?
                            ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: List.generate(snapshot.data!.size, (index) =>
                                Row(
                                  children: [
                                    index==0?SizedBox(width: 10,):Container(),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: TouchRippleEffect(
                                            onTap: ()=>Get.to(()=>ProductsByCategory(snapshot.data!.docs[index].get('name'))),
                                            rippleColor: Colors.grey.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(8),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Karas.secondary,
                                                  child: Icon(Icons.category_rounded),
                                                ),
                                                SizedBox(height: 10),
                                                Text('${snapshot.data!.docs[index].get('name')} (${productsController.products.value.where((element) => element.category==snapshot.data!.docs[index].get('name')).length})', style: title3,)
                                              ],
                                            )),
                                    ),
                                    index==5?SizedBox(width: 10,)
                                        :
                                    Container(

                                    ),
                                  ],
                                )
                            ),
                          ):Container(
                              child: Center(
                                  child: SizedBox(
                                      width: 200,
                                      child: Button2(
                                          content: Text('Add Categories', style: title3,),
                                          tap: (){
                                            _methods.addCategory(fs);
                                          },
                                        backgroundColor: Karas.secondary,
                                      )
                                  )
                              )
                          );
                        }
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: CardItems(
                    head: CardItemsHeader(title: 'Products', seeallbtn: _storeController.store.value.admins.contains(_userController.user.value.email)?InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                          child: Text('Add', style: title3,),
                        ),
                        onTap: ()=>Get.to(()=>ProductEntry())
                    ):Container(),
                    ),
                    body: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Column(
                        children: [
                           productsController.products.isNotEmpty?
                              GroupedListView.grid(
                                items: productsController.products.value,
                                itemGrouper: (var e) => e.category,
                                physics: NeverScrollableScrollPhysics(),
                                headerBuilder: (context, e) => Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Karas.secondary,
                                        margin: EdgeInsets.only(bottom: 10, top: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Text(
                                              e,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                            ),
                                            SizedBox(height: 5)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                shrinkWrap: true,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 15,
                                gridItemBuilder:
                                    (context, int countInGroup, int itemIndexInGroup, item, itemIndexInOriginalList) {
                                      return TouchRippleEffect(
                                          rippleColor: Colors.grey.withOpacity(0.3),
                                          onTap: ()=>_methods.productToCartDialog(item, context),
                                          child:SmallProductContainer(image: '${item.images.first}', title: '${item.productName} (${item.quantity})', id: item.id, product: item,));
                                    },
                                crossAxisCount: 3,
                              )

                                  :Container(),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40,)
              ]
          );
        }
      ),
    );
  }
}
