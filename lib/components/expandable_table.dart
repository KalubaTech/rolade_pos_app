import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easy_table/flutter_easy_table.dart';
import '../models/order_model.dart';



class DataPage extends StatefulWidget {
  List<OrderModel> data;
  // Method to refresh data

  DataPage(this.data);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {


  @override
  Widget build(BuildContext context) {
    return EasyPaginatedTable(
      height: 300,
      width: 600,
      rowTail: true,
      rowsPerPage: 3,
      columnStyle: ColumnStyle(
        columnLabel: 'name',
        columnStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        rowCellLabel: 'Taha',
        rowCellStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onEdit: (index) {},
      onDelete: (index) {},
      columns: const ['Order No.', 'Total Amount'],
      rows:  widget.data.map<Map<String,String>>((e) =>
      {'Order No.':e.ordID, 'Total Amount': '${e.total}'}
      ).toList(),
    );
  }
}
