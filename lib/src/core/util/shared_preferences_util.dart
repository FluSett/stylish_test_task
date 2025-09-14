import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class App$SharedPreferencesKeys {
  static const shouldShowOnboarding = 'shouldShowOnboarding';
}

@immutable
final class App$SharedPreferencesUtil {
  const App$SharedPreferencesUtil._();

  static const App$SharedPreferencesUtil _instance = App$SharedPreferencesUtil._();

  static App$SharedPreferencesUtil get instance => _instance;

  static late SharedPreferences _prefs;

  static Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  static Future<bool> saveShouldShowOnboarding(final bool value) async =>
      await _prefs.setBool(App$SharedPreferencesKeys.shouldShowOnboarding, value);
  static bool? loadShouldShowOnboarding() => _prefs.getBool(App$SharedPreferencesKeys.shouldShowOnboarding);

  static bool containsKey(final String key) => _prefs.containsKey(key);

  static Future<bool> removeKey(final String key) async => await _prefs.remove(key);

  static Future<bool> clearAll() async => await _prefs.clear();
}
