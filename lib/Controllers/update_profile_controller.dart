import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Controllers/profile_view_controller.dart';
import 'package:tnt/Services/auth_service.dart';
import 'package:tnt/widgets/status_dialog.dart';

class UpdateProfileController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();

  var isLoading = false.obs;

  /// Locally selected file paths — null means keep the current image
  var avatarFilePath = Rxn<String>();
  var coverFilePath = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _prefillFromCurrentProfile();
  }

  void _prefillFromCurrentProfile() {
    final profile = Get.find<ProfileViewController>().profile.value;
    if (profile == null) return;
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    bioController.text = profile.bio;
  }

  // ─── Image pickers ───────────────────────────────────────────────────────────

  Future<void> pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      avatarFilePath.value = result.files.single.path;
    }
  }

  Future<void> pickCover() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      coverFilePath.value = result.files.single.path;
    }
  }

  // ─── Submit ──────────────────────────────────────────────────────────────────

  Future<void> updateProfile() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      StatusDialog.show(
        success: false,
        message: 'First name and last name are required',
      );
      return;
    }

    isLoading.value = true;
    try {
      final res = await AuthService.updateProfile(
        userId: AppSession.userId ?? 0,
        firstName: firstName,
        lastName: lastName,
        bio: bioController.text.trim(),
        avatarPath: avatarFilePath.value,
        coverPath: coverFilePath.value,
      );

      if (res['status'] == true) {
        // Refresh the profile screen with fresh data
        await Get.find<ProfileViewController>().fetchProfile();
        StatusDialog.show(
          success: true,
          message: res['message'] ?? 'Profile updated successfully',
        );
        Get.back();
      } else {
        StatusDialog.show(
          success: false,
          message: res['message'] ?? 'Update failed',
        );
      }
    } catch (_) {
      StatusDialog.show(success: false, message: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
