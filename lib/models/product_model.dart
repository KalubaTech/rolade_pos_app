

class ProductModel {

  String id;
  String productName;
  String price;
  String description;
  String quantity;
  String tax;
  List images;
  String? supplierName;
  String? supplierPhone;
  String? unit;
  String category;


  ProductModel(
      {
        required this.id,
        required this.productName,
        required this.price,
        required this.description,
        required this.quantity,
        required this.images,
        required this.tax,
        required this.category,
        this.supplierName,
        this.supplierPhone,
        this.unit
      });

}