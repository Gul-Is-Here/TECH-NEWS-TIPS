import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Services/auth_service.dart';
import 'package:tnt/widgets/status_dialog.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final oldVisible = false.obs;
  final newVisible = false.obs;
  final confirmVisible = false.obs;

  Future<void> changePassword() async {
    final old = oldPasswordController.text.trim();
    final newPwd = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (old.isEmpty || newPwd.isEmpty || confirm.isEmpty) {
      StatusDialog.show(success: false, message: 'All fields are required');
      return;
    }
    if (newPwd.length < 6) {
      StatusDialog.show(
          success: false, message: 'New password must be at least 6 characters');
      return;
    }
    if (newPwd != confirm) {
      StatusDialog.show(
          success: false, message: 'New passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final res = await AuthService.resetPassword(
        userId: AppSession.userId ?? 0,
        oldPassword: old,
        newPassword: newPwd,
        confirmPassword: confirm,
      );
      if (res['status'] == true) {
        StatusDialog.show(
            success: true,
            message: res['message'] ?? 'Password updated successfully');
        Get.back();
      } else {
        StatusDialog.show(
            success: false,
            message: res['message'] ?? 'Failed to update password');
      }
    } catch (_) {
      StatusDialog.show(success: false, message: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
