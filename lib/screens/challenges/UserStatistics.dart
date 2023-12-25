import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle statLabelStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 14,
    );

    final TextStyle statValueStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Color(0xFF1E1E2D), // Dark card background
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Statistics',
              style: TextStyle(
                color: Colors.tealAccent[400], // Bright color for the heading
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey[700]),
            SizedBox(height: 8),
            StatisticItem(
              label: 'Total Users',
              value: '100',
              labelStyle: statLabelStyle,
              valueStyle: statValueStyle,
            ),
            StatisticItem(
              label: 'Active Users',
              value: '50',
              labelStyle: statLabelStyle,
              valueStyle: statValueStyle,
            ),
            StatisticItem(
              label: 'Engagement Rate',
              value: '80.00%',
              labelStyle: statLabelStyle,
              valueStyle: statValueStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const StatisticItem({
    Key? key,
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
