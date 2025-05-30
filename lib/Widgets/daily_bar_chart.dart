import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyBarChart extends StatelessWidget {
  final DateTimeRange dateRange;

  const DailyBarChart({super.key, required this.dateRange});

  @override
  Widget build(BuildContext ctx) {
    // Generate dummy data: one bar per day in the range
    final days = dateRange.duration.inDays + 1;
    final data = List.generate(days, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (i + 1) * 2.0, // dummy increasing values
            color: Colors.greenAccent,
            width: 12,
          )
        ],
      );
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                final date = dateRange.start.add(Duration(days: v.toInt()));
                return Text(
                  '${date.month}/${date.day}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                );
              }),
            ),
            leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          barGroups: data,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
