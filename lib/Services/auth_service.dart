import '../Models/profile_model.dart';
import 'api_client.dart';

class AuthService {
  /// Login with email + password.
  /// Returns the raw response map so the controller can read [status] and [user].
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) {
    return ApiClient.post('/user/loginverify', {
      'email': email,
      'password': password,
    });
  }

  /// Register a new account.
  /// Returns the raw response map so the controller can read [status] and [message].
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) {
    return ApiClient.post('/user/register', {
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    });
  }

  /// Fetch the profile for [email].
  /// Throws [Exception] if the server returns status == false or user is null.
  static Future<ProfileModel> fetchProfile(String email) async {
    final data = await ApiClient.post('/user/profile', {'email': email});
    if (data['status'] == true && data['user'] != null) {
      return ProfileModel.fromJson(data['user'] as Map<String, dynamic>);
    }
    throw Exception(data['message'] ?? 'Failed to load profile');
  }
}
