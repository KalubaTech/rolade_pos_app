import 'dart:math';
import 'package:animated_number/animated_number.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:rolade_pos/components/ad_container.dart';
import 'package:rolade_pos/components/alert_banner.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/cover_all_image_container.dart';
import 'package:rolade_pos/components/drawer_header.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/header_avatar.dart';
import 'package:rolade_pos/controllers/ordersController.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/google_sign_helper.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/helpers/notifications.dart';
import 'package:rolade_pos/models/order_model.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/views/product_views/search_product.dart';
import 'package:rolade_pos/views/salses_views/sales_overview.dart';
import 'package:rolade_pos/views/settings/settings_screen.dart';
import 'package:rolade_pos/views/store/store.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../../components/drawer_list_item.dart';
import '../../controllers/store_controller.dart';
import '../../controllers/user_controller.dart';
import '../../components/category_item.dart';
import '../../components/serachbar_mock.dart';
import '../../controllers/user_controller.dart';
import '../../helpers/charts.dart';
import '../../styles/colors.dart';
import '../../styles/title_styles.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../cart/cart.dart';
import '../product_views/product_entry.dart';
import '../product_views/products_by_category.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  UserController _userController = Get.find();
  StoreController _storeController = Get.find();
  FirebaseFirestore fs = FirebaseFirestore.instance;

  Methods _methods = Methods();

  OrdersController _ordersController = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleSignInHelper signInHelper = GoogleSignInHelper();

  ProductsController _productsController = Get.find();



  @override
  Widget build(BuildContext context) {

    return GetBuilder<ProductsController>(
      builder: (productsController) {
        return DraggableHome(
          key: _scaffoldKey,
          drawer: Container(
            height: double.infinity,
            color: Colors.white,
            width: Get.width*0.79,
            child: Column(
              children: [
                CustomDrawerHeader(),
                Expanded(
                    child: Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          DrawerListItem(
                              leading: Row(
                                children: [
                                  Icon(Icons.ac_unit_outlined, size: 18, color: Karas.primary,),
                                  SizedBox(width: 10,)
                                ],
                              ),
                              title: 'Products',
                              tap: (){
                                Get.to(()=>SearchProducts(), transition: Transition.rightToLeft);
                              },
                              trailing: Text('${productsController.products.value.length}',
                                style: title4,)
                          ),
                          DrawerListItem(
                            leading: Row(
                              children: [
                                Icon(Icons.trending_up, size: 18, color: Karas.primary,),
                                SizedBox(width: 10,)
                              ],
                            ),
                              title: 'Sales Overview',
                              tap: (){
                                Get.to(()=>SalesOverview(), transition: Transition.rightToLeft);
                              },
                          ),
                          DrawerListItem(
                            leading: Row(
                              children: [
                                Icon(Icons.shopping_cart, size: 18, color: Karas.primary,),
                                SizedBox(width: 10,)
                              ],
                            ),
                              title: 'Cart',
                              tap: (){
                                Get.to(()=>Cart());
                              },
                          ),
                          DrawerListItem(
                              leading: Row(
                                children: [
                                  Icon(Icons.store, size: 18, color: Karas.primary,),
                                  SizedBox(width: 10,)
                                ],
                              ),
                              title: 'Store Account',
                              tap: (){
                                Get.to(()=>Store(), transition: Transition.rightToLeft);
                              },
                          ),
                          DrawerListItem(
                            leading: Row(
                              children: [
                                Icon(Icons.settings, size: 18, color: Karas.primary,),
                                SizedBox(width: 10,)
                              ],
                            ),
                              title: 'Settings',
                              tap: (){
                                Get.to(()=>SettingsScreen(), transition: Transition.rightToLeft);
                              },
                          ),
                        ],
                      ),
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Karas.secondary,
                    borderRadius: BorderRadius.circular(20),
                    border: BorderDirectional(top: BorderSide(color: Karas.background,width: 1))
                  ),
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        width: 150,
                        child: Button2(
                            backgroundColor: Karas.background,
                            border: Border.all(color: Colors.grey),
                            content: Text('Sign Out', style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),), tap: ()async{
                          await signInHelper.signOutGoogle();
                        }),
                      ),
                      Spacer(),
                      Text('@${DateTime.now().year}', style: title4,),
                      SizedBox(width: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                width: 20,
                height: 20,
                imageUrl: _userController.user.value.photo,
                errorWidget: (c,e,i)=>CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar_placeholder.jpg'),
                ),
              ),
            ),
            width: 30,
          ),
          actions: [
            IconButton(onPressed: (){
              _scaffoldKey.currentState?.openDrawer();
            }, icon: Icon(Icons.menu))
          ],
          title: Container(
            child: HeaderAvatar(),
          ),
          alwaysShowLeadingAndAction: true,
          headerExpandedHeight: 0.25,
          appBarColor: Karas.primary,
          headerWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            color: Karas.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: ()=>Get.to(()=>SearchProducts()),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SearchMock(placeholder: 'Search products')
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Karas.secondary,
          body: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  productsController.products.value.where((element) => int.parse(element.quantity)<4).toList().isNotEmpty?AlertBanner(
                      message: '${productsController.products.value.where((element) => int.parse(element.quantity)<4).toList().length} product(s) are running out of stock!',
                      child: _userController.user.value.email==_storeController.store.value.email?Container(
                        width: 85,
                        child: Button2(content: Text('Re-stock', style: TextStyle(color: Colors.white),), tap: (){
                          productsController.products.value.where((element) => int.parse(element.quantity)<4).toList().length==1?
                          _methods.productQtyDialog(productsController.products.value.where((element) => int.parse(element.quantity)<4).toList().first, context)
                              : NotificationsHelper().showNotification('HELLO', 'HOW ARE YOU!');





                        }),
                      ):Container(),
                  ):Container(),
                  StreamBuilder(
                      stream: fs.collection('categories')
                          .where('store_id',isEqualTo: _storeController.store.value.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData&&snapshot.data!.size>0?
                        CardItems(
                          head: CardItemsHeader(title: 'Categories (${snapshot.data!.size})',),
                          body: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            height: 98,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              children:
                              List.generate(snapshot.data!.size, (index) =>
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
                                              )
                                          )
                                      ),
                                      index==snapshot.data!.size-1?SizedBox(width: 10,):Container(),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        )
                            :Container();
                      }
                  ),
                  SizedBox(height: 16,),
                  StreamBuilder(
                    stream: fs.collection('order')
                        .where('storeId', isEqualTo: _storeController.store.value.id)
                        .where('user', isEqualTo:_userController.user.value.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        double totalSales = 0.0;
                        double totalYesterdaySales = 0.0;
                        double percentageChange = 0;
                        if(_ordersController.orders.length>0){
                          totalSales = _methods.calculateDaySales(_ordersController.orders,0);
                          totalYesterdaySales = snapshot.data!.size>1?_methods.calculateDaySales(_ordersController.orders,01):0.1;

                          percentageChange = ((totalSales - totalYesterdaySales) / totalYesterdaySales) * 100;

                        }

                        return CardItems(
                        head: CardItemsHeader(title: 'Sales Overview',
                          seeallbtn: InkWell(
                            onTap: ()=>Get.to(()=>SalesOverview()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                            child: Text('See all', style: title3,),
                          ),
                        ),),
                        body: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          height: 130,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              children: [
                                SizedBox(width: 20,),
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Karas.background,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                         padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 8),
                                          child: Text('Today', style: title3,)
                                      ),
                                      Container(
                                         padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                                          child: AnimatedNumber(
                                            startValue: 0,
                                            endValue: totalSales,
                                            duration: Duration(seconds: 2),
                                            isFloatingPoint: false,
                                            prefixText: 'K',
                                            style: headerL,
                                          )
                                      ),
                                      Container(
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 1),
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(percentageChange.ceil()<1?Icons.trending_down:Icons.trending_up, color: percentageChange.ceil()<1?Colors.deepOrange:Colors.blue),
                                                  Text('  ${_ordersController.orders.length<2?100:percentageChange.ceil()}%', style: TextStyle(fontSize: 14, color:percentageChange.ceil()<1?Colors.red:Colors.blue, fontWeight: FontWeight.w700),),
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Karas.orange,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                         padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 8),
                                          child: Text('Yesterday', style: title3,)
                                      ),
                                      Container(
                                         padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                                          child: AnimatedNumber(
                                            startValue: 0,
                                            endValue: totalYesterdaySales,
                                            duration: Duration(seconds: 3),
                                            isFloatingPoint: false,
                                            prefixText: 'K',
                                            style: headerL,
                                          )
                                      ),
                                      Container(
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20,),
                              ],
                            ),
                          ),
                        ),
                      );
                      } else {
                        return Container();
                      }
                    }
                  ),
                  SizedBox(height: 16,),
                  CardItems(
                    head: CardItemsHeader(title: 'Daily Sales',/*seeallbtn: SizedBox(
                      width: 100,
                      child: DropdownSearch<String>(
                        items: [
                          'Daily',
                          'Weekly',
                          'Monthly',
                          'Yearly',
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
                                    horizontal: 0,
                                    vertical: 15
                                ),
                                filled: false,

                            )
                        ),
                        dropdownButtonProps: DropdownButtonProps(
                          padding: EdgeInsetsDirectional.zero,
                          iconSize: 20,
                          icon: Icon(Icons.arrow_drop_down, )
                        ),
                        onChanged:(value)=> value,
                        selectedItem: "Daily",
                      ),
                    )*/),
                    body: Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      height: 180,
                      width: Get.width,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: StreamBuilder(
                          stream: fs.collection('order')
                              .where('storeId', isEqualTo: _storeController.store.value.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                             List<OrderModel> data = snapshot.data!.docs.map<OrderModel>((e) =>
                                 OrderModel.fromMap({
                                   'orderNo': e.get('orderNo'),
                                   'products': e.get('products').map((element) => {'productId':element['productId'],'quantity':element['quantity']}).toList(),
                                   'datetime': '${DateTime.now()}',
                                   'quantity': '${e.get('quantity')}',
                                   'total': '${e.get('total')}',
                                   'cash': '${e.get('cash')}',
                                   'change': '${e.get('change')}',
                                   'tax': '${e.get('change')}',
                                   'subtotal': '${e.get('subtotal')}',
                                   'customer': '',
                                   'user': '${_userController.user.value.uid}',
                                   'storeId': '${_storeController.store.value.id}',
                                 })
                              ).toList();

                             _ordersController.orders.value = data.where((element) => element.user==_userController.user.value.uid).toList();
                              return Container(
                              child:  Charts.barChartSales(data)
                              /*Sparkline(
                                data: [
                                  40,
                                  60,
                                  80,
                                  50,
                                  70,
                                  90
                                ],
                                gridLinelabelPrefix: '',
                                gridLineLabelPrecision: 3,
                                gridLineColor: Colors.red.withOpacity(0.4),
                                enableGridLines: true,
                                min: 0.0,
                                max: 100.0,
                                fillMode: FillMode.below,
                                fillColor: Colors.orange.withOpacity(0.4),
                                fallbackWidth: 150,
                                cubicSmoothingFactor: 0.2,
                                lineWidth: 2,
                                pointColor: Colors.green,
                                pointsMode: PointsMode.all,
                              )*/
                            );
                            } else {
                              return Container();
                            }
                          }
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    height: 135,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: _ordersController.orders.length,
                      itemBuilder: (context,index){
                       ProductModel product = _productsController.products.where((p0) => p0.id == _ordersController.orders[index].products.first['productId']).first;
                       return AdContainer(
                          image: Image.network('${product.images.first}', width: 100,fit: BoxFit.cover,),
                          backgroundColor: Karas.background,
                          title: '${product.productName}',
                          details: '${product.description}',
                          orderbtn: Text('Order Now', style: title3,),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 18,),
                ],
              ),
            ),
           /* Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder(
                stream: fs.collection('order')
                    .where('storeId', isEqualTo:_storeController.store.value.id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData&&snapshot.data!.size>0) {

                    return CardItems(
                    head: CardItemsHeader(title: 'Popular Sales', seeallbtn: Text('See all', style: title3,),),
                    body: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      height: 120,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children:  [
                          ...
                          snapshot.data!.docs.map((e) => CoverAllImageContainer(image: '${e.get('images').first}',)).toList()
                        ],
                      ),
                    ),
                  );
                  } else {
                    return Container();
                  }
                }
              ),
            ),*/
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: CardItems(
                head: CardItemsHeader(title: 'Products', seeallbtn: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                      child: Text('Add', style: title3,),
                    ),
                    onTap: ()=>Get.to(()=>ProductEntry())
                ),
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
                                      rippleColor: Colors.grey.withOpacity(0.4),
                                      onTap: () {

                                        _methods.productToCartDialog(item, context);
                                      },
                                      child: SmallProductContainer(image: '${item.images.first}', title: '${item.productName} (${item.quantity})', id: item.id, product: item,)
                                  );
                                  },
                              crossAxisCount: 3,
                            ): Container(),

                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40)
          ],
        );
      }
    );
  }
}
