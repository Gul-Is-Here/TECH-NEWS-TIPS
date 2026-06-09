import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Screens/home.dart';
import 'package:tnt/Services/auth_service.dart';
import 'package:tnt/widgets/status_dialog.dart';

class AuthScreenController extends GetxController {
  var isLoginScreen = true.obs;
  var isLoading = false.obs;

  // Login form controllers
  final lEmailController = TextEditingController();
  final lPasswordController = TextEditingController();

  // Signup form controllers
  final usernameController = TextEditingController();
  final sEmailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final sPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ─── Signup ─────────────────────────────────────────────────────────────────

  Future<void> signup({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    if ([username, email, firstName, lastName, password, confirmPassword]
        .any((e) => e.isEmpty)) {
      StatusDialog.show(success: false, message: 'Please fill all fields');
      return;
    }
    if (!_isValidEmail(email)) {
      StatusDialog.show(success: false, message: 'Enter a valid email address');
      return;
    }
    if (password != confirmPassword) {
      StatusDialog.show(success: false, message: 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final res = await AuthService.signup(
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
      );
      if (res['status'] == true) {
        StatusDialog.show(
          success: true,
          message: res['message'] ?? 'Registered successfully',
        );
        resetAllControllers();
        isLoginScreen.value = true;
      } else {
        StatusDialog.show(
          success: false,
          message: res['message'] ?? 'Signup failed',
        );
      }
    } catch (_) {
      StatusDialog.show(success: false, message: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Login ──────────────────────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      StatusDialog.show(success: false, message: 'Please fill all fields');
      return;
    }
    if (!_isValidEmail(email)) {
      StatusDialog.show(success: false, message: 'Enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      final res = await AuthService.login(email, password);
      if (res['status'] == true) {
        StatusDialog.show(success: true, message: res['message']);
        resetAllControllers();
        await AppSession.save(res['user'] as Map<String, dynamic>);
        Get.offAll(() => Home());
      } else {
        StatusDialog.show(success: false, message: res['message']);
      }
    } catch (_) {
      StatusDialog.show(success: false, message: 'Login failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void resetAllControllers() {
    lEmailController.clear();
    lPasswordController.clear();
    usernameController.clear();
    sEmailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    sPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    lEmailController.dispose();
    lPasswordController.dispose();
    usernameController.dispose();
    sEmailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    sPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
