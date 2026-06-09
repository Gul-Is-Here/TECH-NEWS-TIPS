import 'package:flutter/material.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:get/get.dart';
import 'package:tnt/AppDrawer/app_drawer.dart';
import 'package:tnt/Screens/Add%20Post/add_post_web_view.dart';
import 'package:tnt/Screens/Posts/all_posts_view.dart';
import 'package:tnt/Screens/Profile/profile_view.dart';
import '../Controllers/home_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<String> titles = [
    "All Posts",
    "Add Post",
    "Favorites",
    "Profile",
  ];

  final List<Widget> pages = [
    AllPostsView(),
    AddPostWebView(),
    Center(child: Text("Favorites", style: TextStyle(fontSize: 22))),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              titles[controller.currentPage.value],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          drawer: const AppDrawer(),

          body: pages[controller.currentPage.value],

          bottomNavigationBar: DotCurvedBottomNav(
            scrollController: controller.scrollController,
            hideOnScroll: true,
            indicatorColor: Colors.blue,
            backgroundColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.ease,
            selectedIndex: controller.currentPage.value,
            indicatorSize: 5,
            borderRadius: 25,
            height: 65,
            onTap: (index) {
              controller.currentPage.value = index;
            },
            items: [
              Icon(
                Icons.list,
                color: controller.currentPage.value == 0
                    ? Colors.blue
                    : Colors.white,
              ),
              Icon(
                Icons.add_box,
                color: controller.currentPage.value == 1
                    ? Colors.blue
                    : Colors.white,
              ),
              Icon(
                Icons.favorite,
                color: controller.currentPage.value == 2
                    ? Colors.blue
                    : Colors.white,
              ),
              Icon(
                Icons.person,
                color: controller.currentPage.value == 3
                    ? Colors.blue
                    : Colors.white,
              ),
            ],
          ),
        ));
  }
}
