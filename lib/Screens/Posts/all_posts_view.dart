import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/AppDrawer/drawer_controller.dart';
import 'package:tnt/Globle/app_const.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/Controllers/all_posts_controller.dart';
import 'package:tnt/Controllers/favorites_controller.dart';
import 'package:tnt/Models/post.dart';
import 'package:tnt/Screens/Posts/post_detail_view.dart';
import 'package:tnt/widgets/app_loader.dart';

class AllPostsView extends StatefulWidget {
  final String? categoryName;
  final int? categoryId;

  const AllPostsView({super.key, this.categoryName, this.categoryId});

  @override
  State<AllPostsView> createState() => _AllPostsViewState();
}

class _AllPostsViewState extends State<AllPostsView> {
  late AllPostsController postsController;
  late DrawerControllerX drawerController;
  late FavoritesController favoritesController;
  late RxString selectedCategoryId;
  late RxString selectedSubCategoryId;

  @override
  void initState() {
    super.initState();

    postsController = Get.put(
      AllPostsController(),
      tag: widget.categoryId?.toString() ?? 'all',
      permanent: true,
    );
    drawerController = Get.put(DrawerControllerX());
    favoritesController = Get.put(FavoritesController(), permanent: true);

    selectedCategoryId = (widget.categoryId?.toString() ?? '').obs;
    selectedSubCategoryId = ''.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.categoryId != null) {
        postsController.fetchPosts(category: widget.categoryId);
      } else {
        postsController.fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: (widget.categoryName != null && widget.categoryName!.isNotEmpty)
          ? AppBar(title: Text(widget.categoryName!))
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories row
          (widget.categoryName == null || widget.categoryName!.isEmpty)
              ? Obx(() {
                  if (drawerController.isLoading.value) {
                    return SizedBox(
                      height: screenHeight * 0.06,
                      child: const Center(child: AppLoader()),
                    );
                  }

                  final categories = drawerController.categories.skip(1).toList();

                  return SizedBox(
                    height: screenHeight * 0.05,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.02),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Obx(() {
                          final isSelected = selectedCategoryId.value == cat.id;
                          return GestureDetector(
                            onTap: () {
                              selectedCategoryId.value = cat.id;
                              selectedSubCategoryId.value = '';
                              drawerController.fetchSubCategories(cat.id);
                              postsController.fetchPosts(
                                category: int.tryParse(cat.id),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? yellowColor : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? yellowColor : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  cat.name,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        fontSize: screenWidth * 0.03,
                                      ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  );
                })
              : const SizedBox.shrink(),

          SizedBox(height: screenHeight * 0.005),

          // Subcategories row
          Obx(() {
            if (selectedCategoryId.value.isEmpty) return const SizedBox();

            final subs = drawerController.subCategories[selectedCategoryId.value] ?? [];

            if (drawerController.subLoading[selectedCategoryId.value] ?? false) {
              return SizedBox(
                height: screenHeight * 0.05,
                child: const Center(child: AppLoader()),
              );
            }

            if (subs.isEmpty) return const SizedBox();

            return SizedBox(
              height: screenHeight * 0.045,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                scrollDirection: Axis.horizontal,
                itemCount: subs.length,
                separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.02),
                itemBuilder: (context, index) {
                  final sub = subs[index];
                  return Obx(() {
                    final isSelected = selectedSubCategoryId.value == sub.id;
                    return GestureDetector(
                      onTap: () {
                        selectedSubCategoryId.value = sub.id;
                        postsController.fetchPosts(category: int.tryParse(sub.id));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.007,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? purpleColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? purpleColor : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            sub.name,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: screenWidth * 0.028,
                                ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            );
          }),

          SizedBox(height: screenHeight * 0.007),
          Divider(height: screenHeight * 0.001),
          SizedBox(height: screenHeight * 0.007),

          // Posts list
          Expanded(
            child: Obx(() {
              if (postsController.isLoading.value) {
                return const Center(child: AppLoader());
              }
              if (postsController.posts.isEmpty) {
                return const Center(child: Text("No posts found"));
              }

              if (selectedCategoryId.value.isNotEmpty || selectedSubCategoryId.value.isNotEmpty) {
                return ListView.builder(
                  itemCount: postsController.posts.length,
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  itemBuilder: (context, index) {
                    final post = postsController.posts[index];
                    return _buildFeaturedPost(context, post, postsController, screenHeight, screenWidth);
                  },
                );
              }

              return _buildGroupedPostsView(context, postsController, screenHeight, screenWidth);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedPostsView(BuildContext context, AllPostsController controller, double screenHeight, double screenWidth) {
    final Map<String, List<Post>> postsByCategory = {};

    for (final post in controller.posts) {
      if (post.categories.isNotEmpty) {
        final category = post.categories[0];
        if (!postsByCategory.containsKey(category)) {
          postsByCategory[category] = [];
        }
        postsByCategory[category]!.add(post);
      }
    }

    return ListView.builder(
      itemCount: postsByCategory.length,
      padding: EdgeInsets.all(screenWidth * 0.03),
      itemBuilder: (context, categoryIndex) {
        final category = postsByCategory.keys.elementAt(categoryIndex);
        final categoryPosts = postsByCategory[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.015),
              child: Text(
                category,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
              ),
            ),
            if (categoryPosts.isNotEmpty)
              _buildFeaturedPost(context, categoryPosts[0], controller, screenHeight, screenWidth),
            if (categoryPosts.length > 1)
              Column(
                children: categoryPosts.skip(1).take(3).map((post) {
                  return _buildSimplePostItem(context, post, screenHeight, screenWidth);
                }).toList(),
              ),
            if (categoryIndex < postsByCategory.length - 1)
              SizedBox(height: screenHeight * 0.03),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedPost(BuildContext context, Post post, AllPostsController controller, double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetailView(
            post: post,
            latestThree: controller.latestThree,
            tag: widget.categoryId?.toString() ?? 'all',
          )),
      child: Card(
        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: screenHeight * 0.25,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: screenWidth * 0.04,
                              ),
                        ),
                      ),
                      Obx(() => GestureDetector(
                            onTap: () => favoritesController.toggleFavorite(post),
                            child: Icon(
                              favoritesController.isFavorite(post.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoritesController.isFavorite(post.id)
                                  ? Colors.red
                                  : Colors.grey,
                              size: screenWidth * 0.055,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: screenWidth * 0.03, color: lightBlackColor),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        AppConst().formatDate(post.date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: lightBlackColor,
                              fontSize: screenWidth * 0.03,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplePostItem(BuildContext context, Post post, double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetailView(
            post: post,
            latestThree: Get.find<AllPostsController>(tag: widget.categoryId?.toString() ?? 'all').latestThree,
            tag: widget.categoryId?.toString() ?? 'all',
          )),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: screenWidth * 0.04,
                        ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: screenWidth * 0.03, color: lightBlackColor),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        AppConst().formatDate(post.date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: lightBlackColor,
                              fontSize: screenWidth * 0.03,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Obx(() => GestureDetector(
                  onTap: () => favoritesController.toggleFavorite(post),
                  child: Icon(
                    favoritesController.isFavorite(post.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoritesController.isFavorite(post.id)
                        ? Colors.red
                        : Colors.grey,
                    size: screenWidth * 0.05,
                  ),
                )),
            SizedBox(width: screenWidth * 0.02),
            Icon(Icons.arrow_forward_ios, size: screenWidth * 0.035, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
