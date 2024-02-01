import 'package:rolade_pos/models/product_model.dart';

class CartItemModel{

  Map<String,String> product;
  int qty;
  int price;
  double tax;
  String datetime;

  CartItemModel({
    required this.product,
    required this.qty,
    required this.price,
    required this.tax,
    required this.datetime
  });

}