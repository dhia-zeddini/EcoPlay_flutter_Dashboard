import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/services/CartService.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late Future<List<dynamic>> _payments;

  @override
  void initState() {
    super.initState();
    _payments = CartService().fetchMonthlyPayments(2023, 12);
  }

  // This function will convert your payments into BarChartGroupData for the BarChart.
  List<BarChartGroupData> getBarsFromPayments(List<dynamic> payments) {
    return payments.asMap().entries.map((entry) {
      int idx = entry.key;
      dynamic payment = entry.value;
      return BarChartGroupData(
        x: idx,
        barRods: [
          BarChartRodData(y: payment['amount'] / 100.0, colors: [Colors.blueAccent]),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  // The mainChartData function is now changed to return BarChartData.
  BarChartData mainBarChartData(List<BarChartGroupData> bars) {
    return BarChartData(
      barGroups: bars,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            // Here, you might want to format the value to represent the day of the month.
            return 'Day ${value.toInt()}';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            // Left side titles will show the payment amount.
            return '\$${value.toInt()}';
          },
          margin: 8,
          reservedSize: 40,
        ),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
            return BarTooltipItem(
              '${group.x.toInt()}: \$${rod.y.toInt()}',
              TextStyle(color: Colors.white),
            );
          },
        ),
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Monthly Payments'),
    ),
    body: FutureBuilder<List<dynamic>>(
      future: _payments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<BarChartGroupData> bars = getBarsFromPayments(snapshot.data!);
          List<PieChartSectionData> sections = getSectionsFromPayments(snapshot.data!); // You will need to implement this
          if (bars.isEmpty) {
            return Center(child: Text('No payments data available for this period'));
          }
          return Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(mainBarChartData(bars)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      // Additional PieChart configuration
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('No payments found'));
        }
      },
    ),
  );
}

// Implement this function based on how you want to represent your data in the PieChart.
List<PieChartSectionData> getSectionsFromPayments(List<dynamic> payments) {
  // Your logic to convert payments to PieChart sections
  // Example (you should replace this with your actual data mapping):
  double total = payments.fold(0, (sum, item) => sum + item['amount']);
  return payments.map((payment) {
    final value = payment['amount'];
    final percentage = (value / total) * 100;
    return PieChartSectionData(
      color: Colors.blueAccent, // Choose color based on payment type or other property
      value: percentage,
      title: '${percentage.toStringAsFixed(1)}%',
      radius: 50,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
      ),
    );
  }).toList();
}}