import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/components/cart_item_container.dart';
import 'package:rolade_pos/components/stock_item.dart';
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/controllers/user_controller.dart';
import 'package:rolade_pos/helpers/creds.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/models/product_model.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:rolade_pos/styles/title_styles.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
import 'package:get/get.dart';
import '../../controllers/products_controller.dart';

class Stock extends StatefulWidget {
  Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Methods _methods = Methods();
  StoreController _storeController = StoreController();
  UserController _userController = UserController();

  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {

    return GetBuilder<ProductsController>(
      builder: (products) {
        List<ProductModel> product = products.products.value;
        ProductModel productCalculations = product.reduce((value, element){
          return ProductModel(
              id: value.id,
              productName: value.productName,
              price: value.price,
              description: value.description,
              quantity: value.quantity,
              stock_quantity: value.stock_quantity,
              cost: '${(double.parse(value.stock_quantity)*(double.parse(value.price)+double.parse(value.price)))}',
              images: value.images,
              tax: '${(double.parse(value.cost)+double.parse(element.cost))}',
              category: value.category,
              lowStockLevel: value.lowStockLevel
          );
        });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Karas.primary,
            title: Text('Stock Track'),
            bottom: TabBar(
                controller: _tabController,
                indicatorColor: Karas.orange,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Karas.background,
                tabs: [
                  Tab(
                    text: 'Products',
                  ),
                  Tab(text: 'Profits / Losses',)
                ]
            ),
          ),
          body: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: GroupedListView(
                    itemsCrossAxisAlignment: CrossAxisAlignment.start,
                    itemsMainAxisAlignment: MainAxisAlignment.start,
                    physics: BouncingScrollPhysics(),
                    items: products.products.value,
                    headerBuilder: (context, bool outOfStock) => Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: Karas.background,),
                          Text(
                            outOfStock?'Low In Stock':'In Stock',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          outOfStock?Text('Products that are low or out of stock.'):Text('Available Products')
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    itemsBuilder: (context, products) => ListView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, int index) => Container(
                        child: Column(
                          children: [
                            StockItem(product: products[index].item),
                            products.length==index+1?SizedBox(height: 20,):Container()
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    itemGrouper: (product) => int.parse(product.quantity)<int.parse(product.lowStockLevel),
                  ),
                ),
                Creds().admin()?Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Table(
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                    color: Karas.secondary
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Product', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Cost (K)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Profit (K)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Loss (K)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),),
                                  )
                                ]
                            ),
                            ...product.map((e){
                              return TableRow(
                                  children: [
                                    Text(e.productName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),),
                                    Text(_methods.formatNumber(double.parse(e.cost)), style: TextStyle(fontSize: 11),),
                                    Text('${_methods.formatNumber((double.parse(e.stock_quantity) * double.parse(e.price))-double.parse(e.cost))}', style: TextStyle(fontSize: 11),),
                                    Text('${_methods.formatNumber(double.parse(e.cost)-(double.parse(e.stock_quantity) * double.parse(e.price)))}', style: TextStyle(fontSize: 11),),
                                  ]
                              );
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                )
                    :
                Container(
                  child: Center(child: Text('Content not available', style: title2,)),
                )
              ]
          ),

        );
      }
    );
  }
}
