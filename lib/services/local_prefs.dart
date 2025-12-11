import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefs {
  Future<void> saveFacultyName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('faculty_name', name);
  }

  Future<String?> loadFacultyName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('faculty_name');
  }
}
