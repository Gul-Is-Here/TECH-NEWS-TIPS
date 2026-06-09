import '../Models/profile_model.dart';
import 'api_client.dart';
export 'api_client.dart' show MultipartFileInput;

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

  /// Update profile fields and optionally replace avatar / cover images.
  /// [avatarPath] and [coverPath] are absolute device file paths — omit to keep current images.
  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String firstName,
    required String lastName,
    required String bio,
    String? avatarPath,
    String? coverPath,
  }) {
    return ApiClient.postMultipart(
      '/user/profile_screen',
      fields: {
        'user_id': userId.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'bio': bio,
      },
      files: [
        if (avatarPath != null)
          MultipartFileInput(field: 'avatar', path: avatarPath),
        if (coverPath != null)
          MultipartFileInput(field: 'cover', path: coverPath),
      ],
    );
  }

  /// Reset the password for [userId].
  static Future<Map<String, dynamic>> resetPassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return ApiClient.postMultipart(
      '/user/reset_password',
      fields: {
        'user_id': userId.toString(),
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }

  /// Fetch the profile for [userId].
  /// Throws [Exception] if the server returns status == false or user is null.
  static Future<ProfileModel> fetchProfile(int userId) async {
    final data = await ApiClient.get(
      '/user/profile_screen',
      queryParams: {'user_id': userId.toString()},
    );
    if (data['status'] == true && data['user'] != null) {
      return ProfileModel.fromJson(data['user'] as Map<String, dynamic>);
    }
    throw Exception(data['message'] ?? 'Failed to load profile');
  }
}
