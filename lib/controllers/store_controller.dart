

import 'package:get/get.dart';
import 'package:rolade_pos/models/store_model.dart';

class StoreController extends GetxController{
  var store = StoreModel(id: '', name: '', email: '', description: '', datetime: '').obs;
}