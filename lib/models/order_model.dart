class OrderModel {
  String ordID;
  double total;
  double tax;
  List<Map> products; // Assuming productName is a list of strings
  String quantity;
  String date;
  String customer;
  String user;
  String storeId;
  double cash;
  double change;
  double subtotal;

  OrderModel({
    required this.ordID,
    required this.products,
    required this.quantity,
    required this.total,
    required this.tax,
    required this.date,
    required this.customer,
    required this.user,
    required this.storeId,
    required this.cash,
    required this.change,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderNo': ordID,
      'products': products,
      'datetime': date,
      'quantity': quantity,
      'total': total,
      'tax': tax,
      'customer': customer,
      'user': user,
      'storeId': storeId,
      'cash': cash,
      'change': change,
      'subtotal': subtotal,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      ordID: map['orderNo'],
      products: List<Map>.from(map['products']),
      date: map['datetime'],
      quantity: map['quantity'],
      total: double.parse(map['total']),
      tax: double.parse(map['tax']),
      customer: map['customer'],
      user: map['user'],
      storeId: map['storeId'],
      cash: double.parse(map['cash']),
      change: double.parse(map['change']),
      subtotal: double.parse(map['subtotal']),
    );
  }
}
