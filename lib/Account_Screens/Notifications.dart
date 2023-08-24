import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  _loadNotificationSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load the user's notification settings from SharedPreferences
      _pushNotificationsEnabled = _prefs.getBool('pushNotifications') ?? true;
      _emailNotificationsEnabled = _prefs.getBool('emailNotifications') ?? false;
    });
  }

  _saveNotificationSetting(String key, bool value) {
    _prefs.setBool(key, value);
  }

  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            buildNotificationSetting(
              'Receive Push Notifications',
              'Enable or disable push notifications for important updates.',
              _pushNotificationsEnabled,
                  (value) {
                setState(() {
                  _pushNotificationsEnabled = value;
                });
                _saveNotificationSetting('pushNotifications', value);
              },
            ),
            Divider(),
            buildNotificationSetting(
              'Receive Email Notifications',
              'Get notified by email for special promotions and offers.',
              _emailNotificationsEnabled,
                  (value) {
                setState(() {
                  _emailNotificationsEnabled = value;
                });
                _saveNotificationSetting('emailNotifications', value);
              },
            ),
            Divider(),
            // Add more notification settings here
          ],
        ),
      ),
    );
  }

  Widget buildNotificationSetting(
      String title,
      String description,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
