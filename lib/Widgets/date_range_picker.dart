import 'package:flutter/material.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTimeRange initialRange;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const DateRangePickerWidget({
    super.key,
    required this.initialRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext ctx) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: ctx,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: initialRange,
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.greenAccent,
                      onPrimary: Colors.black,
                      surface: Colors.grey[900]!,
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) onRangeSelected(picked);
            },
            child: Text(
              '${initialRange.start.month}/${initialRange.start.day}/${initialRange.start.year}'
              '  —  '
              '${initialRange.end.month}/${initialRange.end.day}/${initialRange.end.year}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
