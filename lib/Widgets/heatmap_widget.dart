import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../main.dart';

class HeatmapWidget extends StatelessWidget {
  final Map<DateTime, int> data;
  final DateTime firstDate;
  final DateTime lastDate;
  final double cellSize; // NEW: allow resizing cells

  const HeatmapWidget({
    super.key,
    required this.data,
    required this.firstDate,
    required this.lastDate,
    this.cellSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: HeatMap(
          startDate: firstDate,
          endDate: lastDate,
          datasets: data,
          colorsets: const {
            1: kPrimaryGreen,
          },
          defaultColor: Colors.grey.shade800,
          textColor: Colors.white,
          colorMode: ColorMode.opacity,
          size: cellSize,// uses the passed-in cellSize
        ),
      ),
    );
  }
}

