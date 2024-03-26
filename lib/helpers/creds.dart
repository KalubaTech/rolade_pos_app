
import 'package:rolade_pos/controllers/store_controller.dart';
import 'package:rolade_pos/controllers/user_controller.dart';

class Creds {
  StoreController _storeController = StoreController();
  UserController _userController = UserController();
  bool admin(){
    print(_storeController.store.value.admins);
    print(_userController.user.value.email);
    return _storeController.store.value.email==_userController.user.value.email;
  }
}