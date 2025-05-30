import 'package:flutter/material.dart';

class ExportButtonsWidget extends StatelessWidget {
  const ExportButtonsWidget({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            icon: const Icon(Icons.download, color: Colors.black),
            label: const Text('Export CSV', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // TODO: implement CSV export
            },
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
            label: const Text('Export PDF', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // TODO: implement PDF export
            },
          ),
        ],
      ),
    );
  }
}
