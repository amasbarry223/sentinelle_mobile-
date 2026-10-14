import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _accessKey = 'sentinelle_access_token';
  static const _refreshKey = 'sentinelle_refresh_token';
  static const _usernameKey = 'sentinelle_username';

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    String? username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, accessToken);
    await prefs.setString(_refreshKey, refreshToken);
    if (username != null) {
      await prefs.setString(_usernameKey, username);
    }
  }

  Future<String?> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  Future<String?> get refreshToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  Future<String?> get username async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_usernameKey);
  }
}
