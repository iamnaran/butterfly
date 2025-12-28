import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceKeys {
  static const _isLoggedIn = 'isLoggedIn';
  static const _tokenKey = 'auth_token';
  static const _isModernHome = 'is_modern_home';
}

class PreferenceManager {
  late SharedPreferences _prefs;

  PreferenceManager(this._prefs);

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(SharedPreferenceKeys._isLoggedIn, value);
  }

  bool getLoggedIn() {
    return _prefs.getBool(SharedPreferenceKeys._isLoggedIn) ?? false;
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(SharedPreferenceKeys._tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(SharedPreferenceKeys._tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(SharedPreferenceKeys._tokenKey);
  }

  Future<bool> setModernHome(bool value) async {
    return await _prefs.setBool(SharedPreferenceKeys._isModernHome, value);
  }

  bool getModernHome() {
    return _prefs.getBool(SharedPreferenceKeys._isModernHome) ?? true;
  }
}
