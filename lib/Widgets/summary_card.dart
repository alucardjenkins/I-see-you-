import 'package:flutter/material.dart';

class SummaryCardsWidget extends StatelessWidget {
  final DateTimeRange dateRange;

  const SummaryCardsWidget({super.key, required this.dateRange});

  @override
  Widget build(BuildContext ctx) {
    // Dummy values; replace with real calculations
    final total = 123.4;
    final average = 17.6;
    final peakDay = '2025-05-22';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildCard('Total kWh', total.toStringAsFixed(1), ctx),
          const SizedBox(width: 8),
          _buildCard('Avg/Day', average.toStringAsFixed(1), ctx),
          const SizedBox(width: 8),
          _buildCard('Peak Day', peakDay, ctx),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, BuildContext ctx) {
    return Expanded(
      child: Card(
        color: Colors.grey[900],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
