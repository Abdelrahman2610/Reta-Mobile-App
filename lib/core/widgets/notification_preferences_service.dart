import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferencesService {
  static const _key = 'notifications_enabled';

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to true — notifications on by default
    return prefs.getBool(_key) ?? true;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
