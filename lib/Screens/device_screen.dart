import 'package:flutter/material.dart';
import '../main.dart'; // for kPrimaryGreen
import '../widgets/device_card.dart';
import 'package:load_monitoring_mobile_app/Screens/devices.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  // Predefined devices
  final List<Device> _devices = [
    Device(
      name: 'Light Bulb',
      icon: Icons.light_mode,
      isOn: true,
      count: 2,
      frequency: Frequency.preset('Daily'),
      rateKwh: 0.1,
    ),
    Device(
      name: 'TV',
      icon: Icons.tv,
      isOn: false,
      count: 1,
      frequency: Frequency.preset('Weekly'),
      rateKwh: 0.2,
    ),
  ];

  void _addDevice() async {
    // For simplicity, pick from a static list via a simple dialog
    final choices = ['Light Bulb', 'TV', 'Fan', 'Fridge', 'Microwave'];
    String? choice = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Add Device'),
        children: choices.map((c) {
          return SimpleDialogOption(
            child: Text(c),
            onPressed: () => Navigator.pop(ctx, c),
          );
        }).toList(),
      ),
    );
    if (choice != null) {
      setState(() {
        _devices.add(Device(
          name: choice,
          icon: Icons.power, // fallback icon
          isOn: false,
          count: 1,
          frequency: Frequency.preset('Daily'),
          rateKwh: 0.1,
        ));
      });
    }
  }

  void _removeDevice(Device device) {
    setState(() => _devices.remove(device));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Devices', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kPrimaryGreen),
            onPressed: _addDevice,
          ),
        ],
      ),
      body: _devices.isEmpty
          ? const Center(
              child: Text(
                'No devices added.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _devices.length,
              itemBuilder: (ctx, i) {
                final d = _devices[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DeviceCard(
                    device: d,
                    onToggle: (val) {
                      setState(() => d.isOn = val);
                    },
                    onCountChanged: (newCount) {
                      setState(() => d.count = newCount);
                    },
                   onFrequencyChanged: (newFreq) {
                    setState(() {
                      d.frequency = newFreq!;
                     });
                  }, 
                    onRemove: () => _removeDevice(d),
                  ),
                );
              },
            ),
    );
  }
}
