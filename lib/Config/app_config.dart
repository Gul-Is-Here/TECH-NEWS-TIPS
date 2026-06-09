import 'package:shared_preferences/shared_preferences.dart';

// ─── API ──────────────────────────────────────────────────────────────────────

/// Single source of truth for the backend base URL.
/// All service classes import this constant — never hardcode the URL elsewhere.
const String kBaseUrl = 'https://technewstips.com/api';

// ─── Session ──────────────────────────────────────────────────────────────────

/// Manages the logged-in user's data.
///
/// Usage:
///   - App start  → await AppSession.load()
///   - After login → await AppSession.save(responseUser)
///   - On logout  → await AppSession.clear()
///   - Anywhere   → AppSession.userId, AppSession.email, AppSession.isLoggedIn
class AppSession {
  AppSession._(); // prevent instantiation

  static int? userId;
  static String? username;
  static String? email;
  static String? displayName;

  /// True when a user is currently logged in.
  static bool get isLoggedIn => userId != null;

  /// Persists user data from a login response and caches it in memory.
  ///
  /// Expected [user] keys: id, username, email, display_name
  static Future<void> save(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user['id'] as int);
    await prefs.setString('username', user['username'] as String);
    await prefs.setString('email', user['email'] as String);
    await prefs.setString('displayName', user['display_name'] as String);

    userId = user['id'] as int;
    username = user['username'] as String;
    email = user['email'] as String;
    displayName = user['display_name'] as String;
  }

  /// Restores session from SharedPreferences on app start.
  /// Call once inside [main()] before [runApp].
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    username = prefs.getString('username');
    email = prefs.getString('email');
    displayName = prefs.getString('displayName');
  }

  /// Wipes session from both memory and SharedPreferences on logout.
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userId = null;
    username = null;
    email = null;
    displayName = null;
  }
}
