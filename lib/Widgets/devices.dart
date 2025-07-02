import 'package:flutter/material.dart';

/// Encapsulates frequency: either a preset or a custom numeric value per day
class Frequency {
  final String label;
  final double? customValue;

  const Frequency._(this.label, [this.customValue]);

  static const hourly = Frequency._('Hourly');
  static const daily = Frequency._('Daily');
  static const weekly = Frequency._('Weekly');

  factory Frequency.preset(String label) {
    switch (label) {
      case 'Hourly':
        return hourly;
      case 'Daily':
        return daily;
      case 'Weekly':
        return weekly;
      default:
        return Frequency._(label);
    }
  }

  factory Frequency.custom(double value) {
    return Frequency._('Custom', value);
  }
    double get perDay {
    switch (label) {
      case 'Hourly':
        return 24.0;
      case 'Daily':
        return 1.0;
      case 'Weekly':
        return 1.0 / 7.0;
      case 'Custom':
        return customValue ?? 0.0;
      default:
        return 0.0; // fallback if label unknown
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Frequency &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          customValue == other.customValue;

  @override
  int get hashCode => label.hashCode ^ (customValue?.hashCode ?? 0);

  @override
  String toString() => 'Frequency(label: $label, customValue: $customValue)';
}


/// A device entry
class Device {
  final String name;
  final IconData icon;
  bool isOn;
  int count;
  Frequency frequency;
  final double rateKwh; // kWh per cycle

  Device({
    required this.name,
    required this.icon,
    this.isOn = false,
    this.count = 1,
    required this.frequency,
    required this.rateKwh,
  });
}
