import 'package:shared_preferences/shared_preferences.dart';

class SavedCities {
  static List<String> cities = [];

  static Future<void> saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedCities', cities);
  }
}