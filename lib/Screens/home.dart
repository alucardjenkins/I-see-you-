import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // kPrimaryGreen
import '../widgets/PowerRingChart.dart';
import '../widgets/appliance_breakdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final user = FirebaseAuth.instance.currentUser;
    _username = user?.displayName ?? user?.email?.split('@').first ?? 'User';
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Welcome back, $_username!',
          style: const TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
  const _ContentView({required this.period});

  @override
  Widget build(BuildContext context) {
    final usage = {
      0: {'Fridge': 0.8, 'TV': 0.3, 'Microwave': 0.1, 'Lights': 0.4},
      1: {'Fridge': 5.6, 'TV': 2.1, 'Microwave': 0.7, 'Lights': 2.8},
      2: {'Fridge': 24.0, 'TV': 9.0, 'Microwave': 3.0, 'Lights': 12.0},
    }[period] ?? {};

    final total = usage.values.fold<double>(0, (sum, v) => sum + v);
    final maxTotals = {0: 1.6, 1: 11.2, 2: 48.0};
    final pct = (maxTotals[period]! > 0) ? (total / maxTotals[period]!).clamp(0.0, 1.0) : 0.0;
    final maxDeviceValue = usage.values.isEmpty
        ? 1.0
        : usage.values.reduce((a, b) => a > b ? a : b);
    final fractionMap = {
      for (var e in usage.entries) e.key: (e.value / maxDeviceValue).clamp(0.0, 1.0),
    };
    final labelMap = {
      for (var e in usage.entries) e.key: '${e.value.toStringAsFixed(1)} kWh',
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Center(
            child: PowerRingChart(
              key: UniqueKey(),
              consumptionValue: total,
              percentageUsed: pct,
              size: 200,
            ),
          ),
          const SizedBox(height: 24),
          ApplianceBreakdown(data: fractionMap, labels: labelMap),
        ],
      ),
    );
  }
}
