
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceKeys {
  static const String isLoggedIn = 'isLoggedIn';
}

class PreferenceManager {
  late SharedPreferences _prefs;

  PreferenceManager(this._prefs);

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(SharedPreferenceKeys.isLoggedIn, value);
  }

  bool getLoggedIn() {
    return _prefs.getBool(SharedPreferenceKeys.isLoggedIn) ?? false;
  }
}