import 'package:flutter/material.dart';
import '../main.dart'; // for kPrimaryGreen
import '../widgets/PowerRingChart.dart';
import '../widgets/appliance_breakdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Day / Week / Month tabs
            TabBar(
              controller: _tabController,
              indicatorColor: kPrimaryGreen,
              labelColor: kPrimaryGreen,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Day'),
                Tab(text: 'Week'),
                Tab(text: 'Month'),
              ],
            ),
            // Content below tabs
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _ContentView(period: 0),
                  _ContentView(period: 1),
                  _ContentView(period: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final int period;
  // ignore: unused_element_parameter
  const _ContentView({required this.period, super.key});

  @override
  Widget build(BuildContext context) {
    // 1) Raw kWh usage per device
    final usage = {
      0: {'Fridge': 0.8, 'TV': 0.3, 'Microwave': 0.1, 'Lights': 0.4},
      1: {'Fridge': 5.6, 'TV': 2.1, 'Microwave': 0.7, 'Lights': 2.8},
      2: {'Fridge': 24.0, 'TV': 9.0, 'Microwave': 3.0, 'Lights': 12.0},
    }[period] ?? {};

    // 2) Compute total consumption
    final total = usage.values.fold<double>(0.0, (sum, v) => sum + v);

    // 3) Define a fixed "maximum" total per period so percentage varies
    const maxTotals = {
      0: 1.6,   // sum of day dummy data (0.8+0.3+0.1+0.4)
      1: 11.2,  // sum of week
      2: 48.0,  // sum of month
    };
    final maxTotal = maxTotals[period] ?? total;

    // 4) Calculate percentageUsed in [0.0, 1.0]
    final pct = maxTotal > 0 ? (total / maxTotal).clamp(0.0, 1.0) : 0.0;

    // 5) Prepare fraction map & labels for the breakdown bars
    final maxDeviceValue = usage.values.isEmpty
        ? 1.0
        : usage.values.reduce((a, b) => a > b ? a : b);

    final fractionMap = {
      for (var e in usage.entries)
        e.key: (e.value / maxDeviceValue).clamp(0.0, 1.0),
    };

    final labelMap = {
      for (var e in usage.entries) e.key: '${e.value.toStringAsFixed(1)} kWh'
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Centered, animated ring chart
          Center(
            child: PowerRingChart(
              key: UniqueKey(),          // avoids key conflicts
              consumptionValue: total,   
              percentageUsed: pct,       // dynamic [0..1]
              size: 200,                 // make it big
            ),
          ),
          const SizedBox(height: 24),
          // Animated appliance breakdown bars
          ApplianceBreakdown(
            data: fractionMap,
            labels: labelMap,
          ),
        ],
      ),
    );
  }
}
