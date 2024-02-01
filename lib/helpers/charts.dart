import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rolade_pos/models/order_model.dart';
import 'package:collection/collection.dart';
import 'package:rolade_pos/styles/title_styles.dart';

class Charts {

  static Widget lineChartSales(List<OrderModel> salesData){

    // Group orders by day
    Map<String, List<OrderModel>> groupedOrders = groupBy(salesData, (OrderModel order) => order.date);

// Print the result
    groupedOrders.forEach((day, orders) {
      print('Orders for $day:');
      orders.forEach((order) {
        print('Product: ${order.products}, Quantity: ${order.quantity}, Total: ${order.total}, Tax: ${order.tax}');
      });
      print('---');
    });

// Extract data for the two lines
    List<FlSpot> quantitySpots = groupedOrders.entries.map<FlSpot>((entry) {
      final totalQuantity = entry.value.fold<int>(0, (sum, order) => sum + int.parse(order.quantity));
      return FlSpot(DateTime.parse(entry.key).millisecondsSinceEpoch.toDouble(), totalQuantity.toDouble());
    }).toList();

    List<FlSpot> totalSpots = groupedOrders.entries.map<FlSpot>((entry) {
      final total = entry.value.fold<double>(0, (sum, order) => sum + order.total);
      return FlSpot(DateTime.parse(entry.key).millisecondsSinceEpoch.toDouble(), total);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: quantitySpots,
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: totalSpots,
            isCurved: true,
            color: Colors.red, // Choose a different color for the second line
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
        ),
        minX: quantitySpots.isNotEmpty ? quantitySpots.first.x : 0,
        maxX: quantitySpots.isNotEmpty ? quantitySpots.last.x : 1,
        minY: 0,
        maxY: quantitySpots.isNotEmpty
            ? salesData
            .reduce((value, element) => value.total > element.total ? value : element)
            .total +
            10:0,
      ),
    );

  }
  static Widget barChartSales(List<OrderModel> salesData) {
    print(salesData);
    // Group orders by day
    Map<String, List<OrderModel>> groupedOrders = groupBy(salesData, (OrderModel order) => order.date);

    // Extract data for the two bars
    List<BarChartGroupData> bars = groupedOrders.entries.map<BarChartGroupData>((entry) {
      final totalQuantity = entry.value.fold<int>(0, (sum, order) => sum + int.parse(order.quantity));
      final total = entry.value.fold<double>(0, (sum, order) => sum + order.total);
      return BarChartGroupData(
        x: DateTime.parse(entry.key).millisecondsSinceEpoch.toInt(),
        barRods: [
          BarChartRodData(toY: totalQuantity.toDouble(), color: Colors.blue),
          BarChartRodData(toY: total, color: Colors.red),
        ],
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              groupsSpace: 20,
              alignment: BarChartAlignment.start,
              barGroups: bars,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double, value) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('${DateTime.fromMillisecondsSinceEpoch(double.toInt()).day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][DateTime.fromMillisecondsSinceEpoch(double.toInt()).month-1]}',
                              style: TextStyle(
                                fontSize: 9,
          
                              ),
                            ),
                          )
                  ),
          
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
              ),
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: true,
                drawVerticalLine: true,
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.blue,
                  ),
                  Text('  No. of Products', style: title3,)
                ],
              ),
              SizedBox(width: 20,),
              Row(
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  ),
                  Text('  Total Sales (K)', style: title3,)
                ],
              ),
            ],
          ),
        )
      ],
    );
  }


  static Widget pieChartSales(List<double> salesData) {
    return PieChart(
      PieChartData(
        sections: List.generate(
          salesData.length,
              (index) => PieChartSectionData(
            value: salesData[index],
            color: Colors.blue,
            title: '${salesData[index]}', // You can customize the display text here
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
      ),
    );
  }



}