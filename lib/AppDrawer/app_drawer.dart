import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Screens/AboutUs/about_us.dart';
import 'package:tnt/Screens/ContactUs/contact_us_view.dart';
import 'package:tnt/Screens/Posts/all_posts_view.dart';
import 'package:tnt/widgets/app_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DrawerControllerX());

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // 🔹 Header with logo + icons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Logo
                  SizedBox(
                    height: 80,
                    child: Image.asset(
                      "assets/images/tnt_logo_black.png", // 🔹 replace with your logo path
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Social media links — loaded from API
                  Obx(() {
                    final links = controller.socialMediaLinks;
                    if (links.isEmpty) return const SizedBox.shrink();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: links.map((sm) {
                        return _buildCircleIcon(
                          _iconForPlatform(sm.platformName),
                          () => _launchUrl(Uri.parse(sm.link)),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),

            // Divider
            const Divider(),

            // 🔹 Expanded List with categories
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: AppLoader());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                return ListView.builder(
                  itemCount: controller.categories.length - 1,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index + 1];
                    final isExpanded = controller.expandedIndex.value == index;

                    return ExpansionTile(
                      key: Key(category.id),
                      title: Text(
                        category.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 12),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (_) {
                        controller.toggleCategory(index + 1);
                      },
                      children: [
                        Obx(() {
                          final subs =
                              controller.subCategories[category.id] ?? [];
                          final isSubLoading =
                              controller.subLoading[category.id] ?? false;

                          if (isSubLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: AppLoader(),
                            );
                          } else if (subs.isEmpty) {
                            return ListTile(
                              title: Text(
                                "No subcategories",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            );
                          } else {
                            return Column(
                              children: subs.map<Widget>((sub) {
                                return ListTile(
                                  title: Text(
                                    sub.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 11),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);

                                    Get.to(() => AllPostsView(
                                          categoryName: sub.name,
                                          categoryId: int.tryParse(
                                              sub.id.toString()), // pass id
                                        ));
                                  },
                                );
                              }).toList(),
                            );
                          }
                        }),
                      ],
                    );
                  },
                );
              }),
            ),
            const Divider(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => AboutUs()),
                  child: const Text('About Us'),
                ),
                Container(width: 1, height: 20, color: Colors.grey.shade300),
                TextButton(
                  onPressed: () => Get.to(() => const ContactUsView()),
                  child: const Text('Contact Us'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

// 
Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

  String _iconForPlatform(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('facebook')) return 'assets/images/Facebook.png';
    if (lower.contains('twitter') || lower.contains('x ')) return 'assets/images/Twitter.png';
    if (lower.contains('linkedin')) return 'assets/images/Linkedin.png';
    return 'assets/images/Readit.png';
  }

  // 🔹 Reusable circle icon button
  Widget _buildCircleIcon(String imagePath, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey.shade200,
            child:Image.asset(
                      imagePath, // 🔹 replace with your logo path
                      fit: BoxFit.contain,
                    ),
          ),
        ),
        // const SizedBox(height: 6),
        // Text(
        //   label,
        //   style: const TextStyle(fontSize: 11),
        // ),
      ],
    );
  }
}
