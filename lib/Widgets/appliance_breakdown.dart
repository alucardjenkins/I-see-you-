import 'package:flutter/material.dart';
import '../main.dart';

class ApplianceBreakdown extends StatefulWidget {
  final Map<String, double> data; // fraction-per-device
  final Map<String, String> labels; // usage string per device

  const ApplianceBreakdown({
    super.key,
    required this.data,
    required this.labels,
  });

  @override
  State<ApplianceBreakdown> createState() => _ApplianceBreakdownState();
}

class _ApplianceBreakdownState extends State<ApplianceBreakdown>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appliance Breakdown',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...widget.data.entries.map((e) => _AnimatedRow(
                  name: e.key,
                  value: e.value,
                  label: widget.labels[e.key] ?? '',
                  animation: _anim,
                )),
          ],
        ),
      ),
    );
  }
}

class _AnimatedRow extends StatelessWidget {
  final String name, label;
  final double value;
  final Animation<double> animation;

  const _AnimatedRow({
    // ignore: unused_element_parameter
    super.key,
    required this.name,
    required this.value,
    required this.label,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(color: Colors.grey[400])),
              const SizedBox(height: 4),
              Stack(children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4)),
                ),
                FractionallySizedBox(
                  widthFactor: value * animation.value,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                        color: kPrimaryGreen,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          );
        },
      ),
    );
  }
}
