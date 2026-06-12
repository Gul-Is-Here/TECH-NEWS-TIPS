import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Controllers/profile_view_controller.dart';
import 'package:tnt/Controllers/update_profile_controller.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/widgets/app_loader.dart';
import 'package:tnt/widgets/reusable_button.dart';
import 'package:tnt/widgets/reusable_textfield.dart';

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfileController());
    final profile = Get.find<ProfileViewController>().profile.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Avatar picker ────────────────────────────────────────────────
            _AvatarPicker(controller: controller, profile: profile),

            // ── Form fields ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableTextField(
                    label: 'First Name',
                    hintText: 'Enter first name',
                    controller: controller.firstNameController,
                  ),
                  const SizedBox(height: 14),
                  ReusableTextField(
                    label: 'Last Name',
                    hintText: 'Enter last name',
                    controller: controller.lastNameController,
                  ),
                  const SizedBox(height: 14),
                  _BioField(controller: controller),
                  const SizedBox(height: 28),

                  // ── Save button ────────────────────────────────────────────
                  Obx(() => controller.isLoading.value
                      ? const Center(child: AppLoader())
                      : ReusableButton(
                          text: 'Save Changes',
                          onPressed: controller.updateProfile,
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar-only picker ────────────────────────────────────────────────────────

class _AvatarPicker extends StatelessWidget {
  final UpdateProfileController controller;
  final dynamic profile; // ProfileModel

  const _AvatarPicker({required this.controller, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Center(
        child: Stack(
          children: [
            Obx(() {
              final localPath = controller.avatarFilePath.value;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: localPath != null
                      ? FileImage(File(localPath))
                      : (profile?.avatarUrl != null &&
                              profile!.avatarUrl.isNotEmpty)
                          ? NetworkImage(profile!.avatarUrl) as ImageProvider
                          : null,
                  child: (localPath == null &&
                          (profile?.avatarUrl == null ||
                              profile!.avatarUrl.isEmpty))
                      ? const Icon(Icons.person, size: 48, color: Colors.grey)
                      : null,
                ),
              );
            }),

            // Camera badge
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: controller.pickAvatar,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: blueColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bio multiline field ───────────────────────────────────────────────────────

class _BioField extends StatelessWidget {
  final UpdateProfileController controller;
  const _BioField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller.bioController,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            hintText: 'Tell something about yourself',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
        ),
      ],
    );
  }
}
