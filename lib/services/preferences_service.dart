import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Thème Sombre
  static bool get isDarkMode => _prefs.getBool('isDarkMode') ?? true;
  static Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('isDarkMode', value);
  }

  // Notifications
  static bool get isNotificationsEnabled => _prefs.getBool('isNotificationsEnabled') ?? true;
  static Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool('isNotificationsEnabled', value);
  }

  // Biométrie
  static bool get isBiometricsEnabled => _prefs.getBool('isBiometricsEnabled') ?? false;
  static Future<void> setBiometricsEnabled(bool value) async {
    await _prefs.setBool('isBiometricsEnabled', value);
  }
}
