import 'package:get/get.dart';
import 'package:rolade_pos/models/user_model.dart';

class UserController extends GetxController{
  var user = UserModel(uid: '', email: '', displayName: '', phone: '', photo:'', datetime: '', password: '').obs;
}