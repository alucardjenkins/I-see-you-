import 'package:flutter/material.dart';
import '../main.dart';
import 'package:load_monitoring_mobile_app/Screens/devices.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onCountChanged;
  final ValueChanged<Frequency?> onFrequencyChanged;
  final VoidCallback onRemove;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    required this.onCountChanged,
    required this.onFrequencyChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext ctx) {
    // Estimated daily consumption
    final daily = device.rateKwh * device.frequency.perDay * device.count;

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon, name, toggle, remove
            Row(
              children: [
                Icon(device.icon, color: kPrimaryGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(device.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
                // Switch(
                //   value: device.isOn,
                //   activeColor: kPrimaryGreen,
                //   onChanged: onToggle,
                // ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onRemove,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Count picker
            Row(
              children: [
                const Text('Count:', style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove, color: kPrimaryGreen),
                  onPressed: device.count > 1
                      ? () => onCountChanged(device.count - 1)
                      : null,
                ),
                Text('${device.count}', style: const TextStyle(color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.add, color: kPrimaryGreen),
                  onPressed: () => onCountChanged(device.count + 1),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Frequency selector
            Row(
              children: [
                const Text('Freq:', style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 8),
                DropdownButton<Frequency>(
                  dropdownColor: Colors.grey[900],
                  value: device.frequency,
                  onChanged: (Frequency? freq){
                    if (freq != null){
                      onFrequencyChanged(freq);
                    }
                  },
                   items: [
                     Frequency.hourly,
                     Frequency.daily,
                     Frequency.weekly,
                     Frequency.custom(2.0),
                    ].map((f) {
                    return DropdownMenuItem(
                    value: f,
                    child: Text(f.label, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Estimated consumption
            Text(
              'Est: ${daily.toStringAsFixed(2)} kWh/day',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
