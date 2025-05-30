import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyLineChart extends StatelessWidget {
  final DateTimeRange dateRange;

  const WeeklyLineChart({super.key, required this.dateRange});

  @override
  Widget build(BuildContext ctx) {
    // Dummy: one point per day
    final days = dateRange.duration.inDays + 1;
    final spots = List.generate(days, (i) {
      return FlSpot(i.toDouble(), (days - i) * 1.5);
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(spots: spots, color: Colors.greenAccent, isCurved: true),
          ],
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
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
