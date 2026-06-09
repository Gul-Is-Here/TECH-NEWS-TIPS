import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Screens/AboutUs/about_us.dart';
import 'package:tnt/Controllers/all_posts_controller.dart';
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

                  // Row of 4 circle buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      _buildCircleIcon("assets/images/Facebook.png", () {
                        _launchUrl(Uri.parse('https://www.facebook.com'));
                      }),
                      _buildCircleIcon("assets/images/Twitter.png", () {
                        _launchUrl(Uri.parse('https://www.twitter.com'));
                      }),
                      _buildCircleIcon("assets/images/Linkedin.png", () {
                        _launchUrl(Uri.parse('https://www.linkedin.com'));
                      }),
                      _buildCircleIcon("assets/images/Readit.png",  () {
                        _launchUrl(Uri.parse('https://www.reddit.com'));
                      }),
                    ],
                  ),
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
                    final subs =
                        controller.subCategories[category.id] ?? <dynamic>[];

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextButton(
                onPressed: (){
                  Get.to(()=> AboutUs());
                },
                child: Text('About Us'),
              ),
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
