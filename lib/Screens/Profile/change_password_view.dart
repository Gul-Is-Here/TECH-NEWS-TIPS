import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Controllers/change_password_controller.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/widgets/app_loader.dart';
import 'package:tnt/widgets/reusable_button.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Gradient header ──────────────────────────────────────────────
            _PasswordHeader(),

            // ── Form ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PasswordField(
                    label: 'Current Password',
                    hint: 'Enter your current password',
                    controller: controller.oldPasswordController,
                    visibleObs: controller.oldVisible,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    label: 'New Password',
                    hint: 'At least 6 characters',
                    controller: controller.newPasswordController,
                    visibleObs: controller.newVisible,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    label: 'Confirm New Password',
                    hint: 'Repeat new password',
                    controller: controller.confirmPasswordController,
                    visibleObs: controller.confirmVisible,
                  ),

                  // ── Password hint ──────────────────────────────────────────
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 13, color: Colors.grey.shade400),
                      const SizedBox(width: 6),
                      Text(
                        'Minimum 6 characters',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Submit ─────────────────────────────────────────────────
                  Obx(() => controller.isLoading.value
                      ? const Center(child: AppLoader())
                      : ReusableButton(
                          text: 'Update Password',
                          onPressed: controller.changePassword,
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

// ── Gradient header ───────────────────────────────────────────────────────────

class _PasswordHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            blueColor.withValues(alpha: 0.85),
            Colors.indigo.shade600,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: Colors.white, size: 36),
          ),
          const SizedBox(height: 14),
          Text(
            'Secure Your Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a strong password you haven\'t used before',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Password text field with visibility toggle ────────────────────────────────

class _PasswordField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final RxBool visibleObs;

  const _PasswordField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.visibleObs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 6),
        Obx(() => TextField(
              controller: controller,
              obscureText: !visibleObs.value,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: blueColor, width: 1.5),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => visibleObs.value = !visibleObs.value,
                  child: Icon(
                    visibleObs.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
