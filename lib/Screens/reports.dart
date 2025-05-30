import 'package:flutter/material.dart';
import 'package:load_monitoring_mobile_app/Widgets/daily_bar_chart.dart';
import 'package:load_monitoring_mobile_app/Widgets/summary_card.dart';
import 'package:load_monitoring_mobile_app/Widgets/date_range_picker.dart';
import 'package:load_monitoring_mobile_app/Widgets/weekly_line_chart.dart';
import 'package:load_monitoring_mobile_app/Widgets/export_button.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onRangeSelected(DateTimeRange range) {
    setState(() => _selectedRange = range);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Energy Reports'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.greenAccent,
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Day'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Step 4: Custom date range picker
          Padding(
            padding: const EdgeInsets.all(8),
            child: DateRangePickerWidget(
              initialRange: _selectedRange!,
              onRangeSelected: _onRangeSelected,
            ),
          ),

          // Step 5: Summary cards
          SummaryCardsWidget(dateRange: _selectedRange!),

          // Tab views for charts
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Day: daily bar chart
                DailyBarChart(dateRange: _selectedRange!),
                // Week: weekly line chart
                WeeklyLineChart(dateRange: _selectedRange!),
                // Month: you could reuse weekly_line_chart or create a Monthly view
                WeeklyLineChart(dateRange: _selectedRange!),
              ],
            ),
          ),

          // Step 6: Export buttons
          const ExportButtonsWidget(),
        ],
      ),
    );
  }
}
