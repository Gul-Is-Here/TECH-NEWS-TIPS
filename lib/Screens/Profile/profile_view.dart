import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Globle/app_const.dart';
import 'package:tnt/Globle/colors.dart';
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
          return const Center(child: Text("No profile data found."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image with border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profile.avatarUrl.isNotEmpty
                          ? profile.avatarUrl
                          : "https://via.placeholder.com/60",
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Display Name (simple, capitalized)
                Text(
                  profile.displayName.capitalize ?? profile.displayName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 10),

                // Divider
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 60,
                  endIndent: 60,
                ),

                const SizedBox(height: 20),
                 // user name container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "Username",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        profile.username,
                        style: Theme.of(context).textTheme.bodySmall
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Joining Date container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "Joining Date",
                        style: Theme.of(context).textTheme.bodySmall
                      ),
                      Text(
                        AppConst().formatDate(profile.registered),
                         style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Email container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Flexible(
                        child: Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor, // match screenshot
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      // logout here
                    },
                    child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
