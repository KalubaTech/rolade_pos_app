
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rolade_pos/components/ad_container.dart';
import 'package:rolade_pos/components/alert_banner.dart';
import 'package:rolade_pos/components/bigItem.dart';
import 'package:rolade_pos/components/card_items.dart';
import 'package:rolade_pos/components/card_items_header.dart';
import 'package:rolade_pos/components/drawer_header.dart';
import 'package:rolade_pos/components/form_components/button1.dart';
import 'package:rolade_pos/components/form_components/button2.dart';
import 'package:rolade_pos/components/header_avatar.dart';
import 'package:rolade_pos/controllers/ordersController.dart';
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/google_sign_helper.dart';
import 'package:rolade_pos/helpers/methods.dart';
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
import '../../styles/colors.dart';
import '../../styles/title_styles.dart';
import 'package:get/get.dart';
import '../cart/cart.dart';
import '../product_views/product_details.dart';
import '../product_views/product_entry.dart';
import '../product_views/products_by_category.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:time_diffrence/time_diffrence.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../settings/code_generator.dart';
import '../store/stock.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  UserController _userController = Get.find();

  StoreController _storeController = Get.find();

  FirebaseFirestore fs = FirebaseFirestore.instance;

  Methods _methods = Methods();

  OrdersController _ordersController = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  GoogleSignInHelper signInHelper = GoogleSignInHelper();

  ProductsController _productsController = Get.find();

  DateTime selectedDate = DateTime.now();

  String nextSalesDate = DateTime.now().toString().split(' ').first;
  String prevSalesDate = DateTime.now().subtract(Duration(days: 1)).toString().split(' ').first;

   _selectDate(BuildContext context, String initDate) async {
    /*final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(initDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      return picked.toString().split(' ').first;//picked;
    }else{
      return '${DateTime.now().toString().split(' ').first}';
    }*/

    Get.bottomSheet(
        Container(
          child: DatePickerWidget(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ProductsController>(
      builder: (productsController) {

        double prevSales = 0.0;
        double nextSales = 0.0;

        prevSales = _methods.salesByDate(prevSalesDate);
        nextSales = _methods.salesByDate(nextSalesDate);

        double percentageChange = ((nextSales - prevSales) / prevSales) * 100;
        double percentageChangeNxt = prevSales<nextSales?
        percentageChange:percentageChange;

        return Scaffold(
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
                                Icon(Ionicons.pricetag, size: 18, color: Karas.primary,),
                                SizedBox(width: 10,)
                              ],
                            ),
                            title: 'Stock Track',
                            tap: (){
                              Get.to(()=>Stock(), transition: Transition.rightToLeft);
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
                          DrawerListItem(
                            leading: Row(
                              children: [
                                Icon(Icons.qr_code_scanner, size: 18, color: Karas.primary,),
                                SizedBox(width: 10,)
                              ],
                            ),
                            title: 'Code Generator',
                            tap: (){
                              Get.to(()=>CodeGen(), transition: Transition.rightToLeft);
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
          body: DraggableHome(
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
                _scaffoldKey.currentState!.openDrawer();
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
                    productsController.products.value.where((element) => int.parse(element.quantity)<4).toList().isNotEmpty&&_storeController.store.value.email==_userController.user.value.email?AlertBanner(
                        message: '${productsController.products.value.where((element) => int.parse(element.quantity)<int.parse(element.lowStockLevel)).toList().length} product(s) are running out of stock!',
                        child: _storeController.store.value.admins.contains(_userController.user.value.email)?Container(
                          width: 85,
                          child: Button2(content: Text('Re-stock', style: TextStyle(color: Colors.white),), tap: (){
                              Get.to(()=>Stock());
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
                    _ordersController.orders.length>0?CardItems(
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
                          child: Row(
                            children: [
                              SizedBox(width: 20,),
                              Expanded(
                                child: Container(
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
                                        child: InkWell(
                                          onTap: ()async{
                                            nextSalesDate = await _selectDate(context, nextSalesDate);
                                /*            nextSalesDate = await _selectDate(context, nextSalesDate);
                                            setState(() {
                                              nextSales = _methods.salesByDate(nextSalesDate);
                                            });*/
                                
                                
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${convertToNaturalLanguageDate(DateTime.parse(nextSalesDate))}', style: title3,),
                                              Icon(Icons.edit_calendar_outlined, size: 18, color: Karas.primary)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                                        child: AnimatedDigitWidget(
                                            value: nextSales,
                                            textStyle: title1,
                                            duration: Duration(seconds: 2),
                                            prefix: 'K'
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 1),
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon((percentageChangeNxt.isNaN || percentageChangeNxt.isInfinite?0:percentageChangeNxt)<1?Icons.trending_down:Icons.trending_up, color: (percentageChangeNxt.isNaN || percentageChangeNxt.isInfinite?0:percentageChangeNxt)<1?Colors.deepOrange:Colors.blue),
                                                  Text('  ${_ordersController.orders.length<2?100:(percentageChangeNxt.isNaN || percentageChangeNxt.isInfinite?0:percentageChangeNxt.ceil()).abs()}%', style: TextStyle(fontSize: 14, color:(percentageChangeNxt.isNaN || percentageChangeNxt.isInfinite?0:percentageChangeNxt)<1?Colors.red:Colors.blue, fontWeight: FontWeight.w700),),
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
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
                                        child: InkWell(
                                          onTap: ()async{
                                            prevSalesDate = await _selectDate(context, prevSalesDate);
                                            setState(() {
                                              prevSales = _methods.salesByDate(prevSalesDate);
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${convertToNaturalLanguageDate(DateTime.parse(prevSalesDate))}', style: title3,),
                                              Icon(Icons.edit_calendar_outlined, size: 18, color: Karas.primary)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 3),
                                        child: AnimatedDigitWidget(
                                            value: prevSales.obs(),
                                            textStyle: title1,
                                            duration: Duration(seconds: 2),
                                            prefix: 'K'
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                            ],
                          ),
                        ),
                      ),
                    ):Container(),
                    _ordersController.orders.length>0?Column(
                      children: [
                        SizedBox(height: 16,),
                        Container(
                          height: 150,
                          child: FlutterCarousel(
                            options: CarouselOptions(
                              height: 150.0,
                              showIndicator: false,
                              slideIndicator: CircularSlideIndicator(),
                              clipBehavior: Clip.none,
                              autoPlay: true,
                              autoPlayCurve: Curves.slowMiddle,
                              viewportFraction: 0.999
                            ),
                            items:  _productsController.products.where((p0) => true).toList()
                            .map((product) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      child: AdContainer(
                                        image: '${product.images.first}',
                                        backgroundColor: Karas.background,
                                        title: '${product.productName}',
                                        details: '${product.description}',
                                        orderbtn: Button1(label: 'View', tap: (){
                                          Get.to(()=>ProductDetails(product));
                                        }),
                                      )
                                  );
                                },
                              );
                            }).toList(),
                          )
                        ),
                      ],
                    ):Container(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:  productsController.products.isNotEmpty?
                GroupedListView.grid(
                  items: productsController.products.value,
                  itemGrouper: (var e) => e.category,
                  physics: NeverScrollableScrollPhysics(),
                  headerBuilder: (context, e) => Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: BorderDirectional(top: BorderSide(color: Karas.secondary))
                          ),
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                "$e",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18),
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
                  crossAxisSpacing: 10,
                  gridItemBuilder:
                      (context, int countInGroup, int itemIndexInGroup, item, itemIndexInOriginalList) {
                    return TouchRippleEffect(
                        rippleColor: Colors.grey.withOpacity(0.4),
                        onTap: () {
                          _methods.productToCartDialog(item, context);
                        },
                        child: BigItem(product: item)
                    );
                  },
                  crossAxisCount: 2,
                ): Container(),

                  /*CardItems(
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

                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                )*/
              ),
              SizedBox(height: 40)
            ],
          ),
        );
      }
    );
  }
}
