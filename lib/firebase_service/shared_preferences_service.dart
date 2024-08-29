import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';

  // Save email and password
  Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
  }

  // Get email
  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Email:==>${_keyEmail}");
    return prefs.getString(_keyEmail);
  }

  // Get password
  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Password:==>${_keyPassword}");
    return prefs.getString(_keyPassword);
  }

  // Clear saved data
  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
  }
}
