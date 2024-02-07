import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' show AssetImage;
import 'package:rolade_pos/controllers/products_controller.dart';
import 'package:rolade_pos/helpers/date_formater.dart';
import 'package:rolade_pos/helpers/methods.dart';
import 'package:rolade_pos/models/order_model.dart';
import 'package:rolade_pos/models/store_model.dart';
import 'package:rolade_pos/models/user_model.dart';

import '../models/product_model.dart';

class ReceiptProduct {
  String name;
  int qty;
  String unityPrice;
  String totalPrice;

  ReceiptProduct({
    required this.name,
    required this.qty,
    required this.unityPrice,
    required this.totalPrice,
  });
}

pdfGen(
    StoreModel store,
    UserModel user,
    OrderModel order,
    total,
    subtotal,
    cash,
    change,
    tax,
    ProductsController productsController,
    ) async {
  Methods _methods = Methods();
  final Document pdf = Document(deflate: zlib.encode);

  pdf.addPage(
    Page(
      pageFormat:
      PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      margin: EdgeInsets.all(20),
      orientation: PageOrientation.portrait,
      build: (Context context) {
        return ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Text(
                "${store.name}",
                style: TextStyle(
                  color: PdfColors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              child: Text(
                "RECEIPT",
                style: TextStyle(
                  color: PdfColors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 1.0,
              width: 600.0,
              color: PdfColors.red,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text("${store.name}",
                          style: TextStyle(color: PdfColors.red)),
                    ),
                    Container(
                      child: Text("${store.address}"),
                    ),
                  ],
                ),
                SizedBox(height: 30, width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(child: Text("Date / Time")),
                    Container(child: Text("Order No.")),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(
                        child: Text(
                            "${formatDate(DateTime.now().toString())}")),
                    Container(child: Text("${order.ordID}")),
                  ],
                ),
              ],
            ),
            Container(
              height: 1.0,
              width: 600.0,
              color: PdfColors.red,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                child: Text("Total items: ${order.products.length} ")),
            Container(
              height: 1.0,
              width: 600.0,
              color: PdfColors.red,
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            Container(
              color: PdfColors.yellow200,
              padding: EdgeInsets.all(20),
              child: Table(
                border: TableBorder(),
                tableWidth: TableWidth.max,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(
                          child: Text("Product"),
                          padding:
                          EdgeInsetsDirectional.symmetric(vertical: 5)),
                      Container(
                          child: Text("Qty"),
                          padding:
                          EdgeInsetsDirectional.symmetric(vertical: 5)),
                      Container(
                          child: Text("Unit Price"),
                          padding:
                          EdgeInsetsDirectional.symmetric(vertical: 5)),
                      Container(
                          child: Text("Total"),
                          padding:
                          EdgeInsetsDirectional.symmetric(vertical: 5)),
                    ],
                  ),
                  ...generateTableRows(
                      order.products, productsController.products.value)
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Table(
                      children: [
                        TableRow(
                          children: <Widget>[
                            SizedBox(),
                            Container(
                                child: Text("Subtotal",
                                    textAlign: TextAlign.right)),
                            SizedBox(width: 15),
                            Container(
                                child: Text("K${subtotal}",
                                    textAlign: TextAlign.right)),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            SizedBox(),
                            Container(
                                child: Text("Tax",
                                    textAlign: TextAlign.right)),
                            SizedBox(width: 15),
                            Container(
                                child: Text("K${tax}", textAlign: TextAlign.right)),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            SizedBox(),
                            Container(
                                child: Text("Grand Total",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right)),
                            SizedBox(width: 15),
                            Container(
                                child: Text("K${total}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Table(
                        children: [
                          TableRow(
                            children: <Widget>[
                              SizedBox(),
                              Container(
                                  child: Text("Cash", textAlign: TextAlign.right)),
                              SizedBox(width: 15),
                              Container(
                                  child: Text("K${cash}",
                                      textAlign: TextAlign.right)),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              SizedBox(),
                              Container(
                                  child: Text("Change",
                                      textAlign: TextAlign.right)),
                              SizedBox(width: 15),
                              Container(
                                  child: Text("K${change}",
                                      textAlign: TextAlign.right)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  color: PdfColors.grey200,
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(child: Text("${store.name}")),
                    Container(child: Text('${user.displayName}')),
                    Container(child: Text("Sales Attendant")),
                  ],
                )
              ],
            ),
            Container(
              height: 1.0,
              width: 600.0,
              color: PdfColors.black,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Text("THANK YOU! CALL AGAIN."),
          ],
        );
      },
    ),
  );
  final output = await getApplicationDocumentsDirectory();
  final Uint8List data = await pdf.save();

  // Print the PDF
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => data);
}

List<TableRow> generateTableRows(
    List<Map<dynamic, dynamic>> orderProducts, List<ProductModel> allProducts) {
  List<TableRow> tableRows = [];
  Methods _methods = Methods();
  for (var productData in orderProducts) {
    String productId = productData['productId'];
    int qty = int.parse(productData['quantity']);

    // Find the product using productId
    var product = allProducts
        .firstWhere((element) => element.id == productId);

    if (product != null) {
      // Calculate total price
      double totalPrice = double.parse(product.price.toString()) * qty;

      // Create a ReceiptProduct instance
      ReceiptProduct receiptProduct = ReceiptProduct(
        name: product.productName,
        qty: qty,
        unityPrice:
        "K${_methods.formatNumber(double.parse(product.price.toString()))}",
        totalPrice: "K${_methods.formatNumber(totalPrice)}",
      );

      // Create a TableRow
      TableRow tableRow = TableRow(
        children: <Widget>[
          Container(
              child: Text("${receiptProduct.name}"),
              padding: EdgeInsetsDirectional.symmetric(vertical: 4)),
          Container(
              child: Text("${receiptProduct.qty}"),
              padding: EdgeInsetsDirectional.symmetric(vertical: 4)),
          Container(
              child: Text("${receiptProduct.unityPrice}"),
              padding: EdgeInsetsDirectional.symmetric(vertical: 4)),
          Container(
              child: Text("${receiptProduct.totalPrice}"),
              padding: EdgeInsetsDirectional.symmetric(vertical: 4)),
        ],
      );

      // Add the TableRow to the list
      tableRows.add(tableRow);
    }
  }

  return tableRows;
}
