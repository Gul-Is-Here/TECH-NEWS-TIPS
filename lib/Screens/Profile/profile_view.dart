import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Globle/app_const.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/Screens/Auth/auth_screen.dart';
import 'package:tnt/Screens/ContactUs/contact_us_view.dart';
import 'package:tnt/Screens/Profile/change_password_view.dart';
import 'package:tnt/Screens/Profile/update_profile_view.dart';
import 'package:tnt/widgets/app_loader.dart';
import '../../Controllers/profile_view_controller.dart';
import '../../Models/profile_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AppLoader());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data found.'));
        }
        return _ProfileBody(profile: profile);
      }),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ProfileModel profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + name card ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            child: Column(
              children: [
                // Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: profile.avatarUrl.isNotEmpty
                        ? NetworkImage(profile.avatarUrl)
                        : null,
                    child: profile.avatarUrl.isEmpty
                        ? Text(
                            _initial(profile),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 14),

                // Display name
                Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName
                      : profile.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // Username chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: blueColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '@${profile.username}',
                    style: TextStyle(
                      fontSize: 12,
                      color: blueColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Bio
                if (profile.bio.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    profile.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Edit Profile button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.to(() => const UpdateProfileView()),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blueColor,
                      side: BorderSide(color: blueColor.withValues(alpha: 0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Account Info card ────────────────────────────────────────────────
          _sectionLabel('Account Info'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.email_outlined,
                  iconColor: Colors.blue.shade400,
                  iconBg: Colors.blue.shade50,
                  label: 'Email Address',
                  value: profile.email,
                  isFirst: true,
                  isLast: profile.registered.isEmpty,
                ),
                if (profile.registered.isNotEmpty) ...[
                  _divider(),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    iconColor: Colors.purple.shade400,
                    iconBg: Colors.purple.shade50,
                    label: 'Member Since',
                    value: AppConst().formatDate(profile.registered),
                    isFirst: false,
                    isLast: true,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Settings card ────────────────────────────────────────────────────
          _sectionLabel('Settings'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _ActionRow(
                  icon: Icons.lock_outline_rounded,
                  iconColor: Colors.orange.shade400,
                  iconBg: Colors.orange.shade50,
                  label: 'Change Password',
                  subtitle: 'Update your account password',
                  isFirst: true,
                  isLast: false,
                  onTap: () => Get.to(() => const ChangePasswordView()),
                ),
                _divider(),
                _ActionRow(
                  icon: Icons.contact_support_outlined,
                  iconColor: Colors.teal.shade400,
                  iconBg: Colors.teal.shade50,
                  label: 'Contact Us',
                  subtitle: 'info@technewstips.com',
                  isFirst: false,
                  isLast: true,
                  onTap: () => Get.to(() => const ContactUsView()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Logout ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AppSession.clear();
                  Get.offAll(() => const AuthScreen());
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initial(ProfileModel p) {
    final name = p.displayName.isNotEmpty ? p.displayName : p.username;
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        indent: 56,
        color: Colors.grey.shade100,
      );
}

// ── Info row (label stacked above value) ──────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final bool isFirst;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 16 : 12,
        16,
        isLast ? 16 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action row (navigable setting item) ──────────────────────────────────────

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String subtitle;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(14) : Radius.zero,
        bottom: isLast ? const Radius.circular(14) : Radius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, isFirst ? 14 : 12, 16, isLast ? 14 : 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
