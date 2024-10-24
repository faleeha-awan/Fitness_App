import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ReminderProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Care Reminders'),
        backgroundColor: Colors.grey,
      ),
      body: ListView(
        children: [
          ReminderTile(
            title: 'Drink Water',
            icon: Icons.local_drink,
            interval: const Duration(hours: 3),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Take a Nap',
            icon: Icons.hotel,
            interval: const Duration(hours: 4),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Walk',
            icon: Icons.directions_walk,
            interval: const Duration(hours: 1),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Milk',
            icon: Icons.directions_walk,
            interval: const Duration(hours: 6),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Stretching',
            icon: Icons.accessibility,
            interval: const Duration(hours: 3),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Eye Rest',
            icon: Icons.visibility_off,
            interval: const Duration(hours: 2),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Posture Check',
            icon: Icons.accessibility_new,
            interval: const Duration(hours: 1),
            plugin: flutterLocalNotificationsPlugin,
          ),
          ReminderTile(
            title: 'Healthy Snack',
            icon: Icons.fastfood,
            interval: const Duration(hours: 3),
            plugin: flutterLocalNotificationsPlugin,
          ),
        ],
      ),
    );
  }
}

class ReminderTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Duration interval;
  final FlutterLocalNotificationsPlugin plugin;

  const ReminderTile({super.key, 
    required this.title,
    required this.icon,
    required this.interval,
    required this.plugin,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context);
    return SwitchListTile(
      title: Text(title),
      secondary: Icon(icon),
      value: provider.reminders.contains(title),
      onChanged: (bool value) {
        if (value) {
          provider.addReminder(title);
          _scheduleNotification(title, interval, plugin);
        } else {
          provider.removeReminder(title);
          _cancelNotification(title, plugin);
        }
      },
    );
  }

  Future<void> _scheduleNotification(
    String title,
    Duration interval,
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
      'your_channel_id', // Channel ID
      'your_channel_name', // Channel name
      channelDescription: 'your_channel_description', // Channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

  const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

  await plugin.periodicallyShow(
    title.hashCode,
    'Reminder',
    title,
    RepeatInterval.everyMinute,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

  Future<void> _cancelNotification(String title,
      FlutterLocalNotificationsPlugin plugin) async {
    await plugin.cancel(title.hashCode);
  }
}

class ReminderProvider extends ChangeNotifier {
  final List<String> _reminders = [];

  List<String> get reminders => _reminders;

  void addReminder(String reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(String reminder) {
    _reminders.remove(reminder);
    notifyListeners();
  }
}
