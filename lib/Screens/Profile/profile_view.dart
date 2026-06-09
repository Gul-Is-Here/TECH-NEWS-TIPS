import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Globle/app_const.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/Models/profile_model.dart';
import 'package:tnt/Screens/Auth/auth_screen.dart';
import 'package:tnt/Screens/Profile/change_password_view.dart';
import 'package:tnt/Screens/Profile/update_profile_view.dart';
import 'package:tnt/widgets/app_loader.dart';
import '../../Controllers/profile_view_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewController());

    return Scaffold(
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

// ── Main scrollable body ──────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final ProfileModel profile;
  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Cover + Avatar header ──────────────────────────────────────────
          _ProfileHeader(profile: profile),

          // ── Name / username / bio ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              children: [
                Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName
                      : profile.username,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '@${profile.username}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey),
                ),
                if (profile.bio.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    profile.bio,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: lightBlackColor, height: 1.5),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 16),

          // ── Info rows ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: profile.email,
                ),
                if (profile.registered.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _InfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Joined',
                    value: AppConst().formatDate(profile.registered),
                  ),
                ],
                const SizedBox(height: 28),

                // ── Edit Profile button ──────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.to(() => const UpdateProfileView()),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blueColor,
                      side: const BorderSide(color: blueColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Change Password card ─────────────────────────────────────
                GestureDetector(
                  onTap: () => Get.to(() => const ChangePasswordView()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade50,
                          Colors.indigo.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: blueColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_outline_rounded,
                              color: blueColor, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Change Password',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Update your account password',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 13, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Logout button ────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await AppSession.clear();
                      Get.offAll(() => const AuthScreen());
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cover photo + overlapping avatar ─────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final hasCover =
        profile.coverUrl != null && profile.coverUrl!.isNotEmpty;
    final hasAvatar = profile.avatarUrl.isNotEmpty;

    return SizedBox(
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover photo
          Container(
            width: double.infinity,
            height: 155,
            decoration: BoxDecoration(
              color: blueColor.withValues(alpha: 0.15),
              image: hasCover
                  ? DecorationImage(
                      image: NetworkImage(profile.coverUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasCover
                ? Center(
                    child: Icon(
                      Icons.photo_camera_outlined,
                      size: 36,
                      color: blueColor.withValues(alpha: 0.3),
                    ),
                  )
                : null,
          ),

          // Avatar — overlapping the cover at the bottom-center
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      hasAvatar ? NetworkImage(profile.avatarUrl) : null,
                  child: !hasAvatar
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single info row ───────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: blueColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: lightBlackColor),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
