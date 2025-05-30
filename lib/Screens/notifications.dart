// lib/screens/notifications.dart
import 'package:flutter/material.dart';
import '../main.dart'; // for kPrimaryGreen

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

enum SortBy { newestFirst, oldestFirst, byDate, byWeek }

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _items = [
    _NotificationItem(
      message: 'Usual Consumption Spike',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    _NotificationItem(
      message: 'High Energy Usage Detected',
      timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 20)),
    ),
    _NotificationItem(
      message: 'Applicance Malfunctino Alert',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
    _NotificationItem(
      message: 'Energy Saving Tips',
      timestamp: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  void _sortItems(SortBy sortBy) {
    setState(() {
      switch (sortBy) {
        case SortBy.newestFirst:
          _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          break;
        case SortBy.oldestFirst:
          _items.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          break;
        case SortBy.byDate:
          // identical to newestFirst for demo
          _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          break;
        case SortBy.byWeek:
          // group by week if needed; here same as newest
          _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          break;
      }
    });
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    // more than a week: show weekday
    final weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return weekdays[time.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: kPrimaryGreen),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        actions: [
          // Sort menu
          PopupMenuButton<SortBy>(
            icon: Icon(Icons.sort, color: kPrimaryGreen),
            color: Colors.grey[900],
            onSelected: _sortItems,
            itemBuilder: (_) => [
              const PopupMenuItem(value: SortBy.newestFirst, child: Text('Newest First', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: SortBy.oldestFirst, child: Text('Oldest First', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: SortBy.byDate, child: Text('By Date', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: SortBy.byWeek, child: Text('By Week', style: TextStyle(color: Colors.white))),
            ],
          ),
          // Clear all
          IconButton(
            icon: Icon(Icons.clear_rounded, color: kPrimaryGreen),
            onPressed: () => setState(() => _items.clear()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text('No notifications.', style: TextStyle(color: Colors.grey)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final n = _items[i];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryGreen),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[900],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon box
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kPrimaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      // Message + Timestamp
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.message,
                              style: const TextStyle(
                                color: kPrimaryGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _relativeTime(n.timestamp),
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _NotificationItem {
  final String message;
  final DateTime timestamp;
  const _NotificationItem({required this.message, required this.timestamp});
}
