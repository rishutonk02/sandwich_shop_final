import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;

  ThemeModel() {
    _load();
  }

  bool get isDark => _isDark;

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDark = prefs.getBool('darkMode') ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('darkMode', value);
    } catch (_) {}
  }
}
