import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:rolade_pos/components/cart_item_container.dart';
import 'package:rolade_pos/components/stock_item.dart';
import 'package:rolade_pos/styles/colors.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';
import 'package:get/get.dart';
import '../../controllers/products_controller.dart';

class Stock extends StatelessWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (products) {
        return DraggableHome(
          appBarColor: Karas.primary,
          alwaysShowTitle: true,
          alwaysShowLeadingAndAction: true,
          headerExpandedHeight: 0.1,
          title: Text('Stock'),
          body: [
              GroupedListView(
                itemsCrossAxisAlignment: CrossAxisAlignment.start,
                itemsMainAxisAlignment: MainAxisAlignment.start,
                physics: NeverScrollableScrollPhysics(),
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
                  child: StockItem(product: products[index].item),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                itemGrouper: (product) => int.parse(product.quantity)<int.parse(product.lowStockLevel),
              ),
              SizedBox(height: 30,)
          ],
          headerWidget: Container(
            color: Karas.primary,
          ),
        );
      }
    );
  }
}
