class StoreModel {
  String id;
  String email;
  String name;
  String description;
  String latitude;
  String longitude;
  String address;
  String province;
  String district;
  String status;
  String phone;
  String datetime;

  StoreModel({
    required this.id,
    required this.name,
    required this.email,
    required this.description,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.address,
    required this.district,
    required this.province,
    required this.status,
    required this.datetime,

  });
}