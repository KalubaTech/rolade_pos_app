

class UserModel {

  String uid;
  String displayName;
  String email;
  String? phone;
  String photo;
  String datetime;
  String password;

  UserModel({required this.uid,required this.email, required this.displayName, this.phone, required this.photo, required this.datetime, required this.password});

}