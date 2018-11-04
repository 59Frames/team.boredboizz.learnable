import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Pretender {
  static final Pretender _instance = Pretender._internal();

  static SharedPreferences _preferences;

  factory Pretender() => _instance;

  Pretender._internal();

  Future<SharedPreferences> _initPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get preferences async {
    if (_preferences == null)
      _preferences = await _initPreferences();
    return _preferences;
  }

  void putString(String key, String value) async {
    preferences.then((prefs) {
      prefs.setString(key, value);
    });
  }

  Future<String> getString(String key) async {
    return preferences.then((prefs) {
       return prefs.getString(key);
    });
  }
}