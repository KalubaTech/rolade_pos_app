import 'package:get/get.dart';
import 'package:rolade_pos/models/cart_item_model.dart';


class CartController extends GetxController{
  var cart = <CartItemModel>[].obs;

  void addToCart(CartItemModel item){
    cart.value.add(item);
    update();
  }

 void removeFromCart(CartItemModel item){
    cart.value.remove(item);
    update();
  }


}