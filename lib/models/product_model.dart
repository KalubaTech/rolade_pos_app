

class ProductModel {

  String id;
  String productName;
  String price;
  String description;
  String quantity;
  String cost;
  String tax;
  List images;
  String? supplierName;
  String? supplierPhone;
  String? unit;
  String category;
  String lowStockLevel;
  String stock_quantity;

  ProductModel(
      {
        required this.id,
        required this.productName,
        required this.price,
        required this.description,
        required this.quantity,
        required this.stock_quantity,
        required this.cost,
        required this.images,
        required this.tax,
        required this.category,
        required this.lowStockLevel,
        this.supplierName,
        this.supplierPhone,
        this.unit
      });

}