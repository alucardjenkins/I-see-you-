import 'package:flutter/material.dart';
import '../main.dart'; // for kPrimaryGreen

class PowerRingChart extends StatefulWidget {
  final double consumptionValue;
  final double percentageUsed;
  final double size; // NEW: allow resizing

  const PowerRingChart({
    super.key,
    required this.consumptionValue,
    required this.percentageUsed,
    this.size = 140,
  });

  @override
  State<PowerRingChart> createState() => _PowerRingChartState();
}

class _PowerRingChartState extends State<PowerRingChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _percentAnim;
  late final Animation<double> _numberAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _percentAnim = Tween(begin: 0.0, end: widget.percentageUsed).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _numberAnim = Tween(begin: 0.0, end: widget.consumptionValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Card(
        color: Colors.black87,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (ctx, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: widget.size - 40,
                    height: widget.size - 40,
                    child: CircularProgressIndicator(
                      value: _percentAnim.value,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[800],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryGreen),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Total',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(
                        '${_numberAnim.value.toStringAsFixed(1)} kWh',
                        style: const TextStyle(
                            color: kPrimaryGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text('Usage',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

