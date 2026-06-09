import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Controllers/favorites_controller.dart';
import 'package:tnt/Globle/app_const.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/Models/post.dart';
import 'package:tnt/Screens/Posts/post_detail_view.dart';
import 'package:tnt/widgets/app_loader.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController(), permanent: true);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: AppLoader());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_outlined, size: 52, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: controller.fetchFavorites,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.favoritePosts.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 72, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No favourites yet',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any post to save it here',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      final sw = MediaQuery.of(context).size.width;
      final sh = MediaQuery.of(context).size.height;

      return ListView.builder(
        padding: EdgeInsets.all(sw * 0.04),
        itemCount: controller.favoritePosts.length,
        itemBuilder: (context, index) {
          return _FavouriteCard(
            post: controller.favoritePosts[index],
            controller: controller,
            sw: sw,
            sh: sh,
          );
        },
      );
    });
  }
}

class _FavouriteCard extends StatelessWidget {
  final Post post;
  final FavoritesController controller;
  final double sw;
  final double sh;

  const _FavouriteCard({
    required this.post,
    required this.controller,
    required this.sw,
    required this.sh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetailView(
            post: post,
            latestThree: <Post>[],
            tag: 'all',
          )),
      child: Card(
        margin: EdgeInsets.only(bottom: sh * 0.018),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: sh * 0.22,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            Padding(
              padding: EdgeInsets.all(sw * 0.035),
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
                                fontSize: sw * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      SizedBox(width: sw * 0.02),
                      Obx(() => GestureDetector(
                            onTap: () => controller.toggleFavorite(post),
                            child: Icon(
                              controller.isFavorite(post.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: controller.isFavorite(post.id)
                                  ? Colors.red
                                  : Colors.grey,
                              size: sw * 0.055,
                            ),
                          )),
                    ],
                  ),
                  if (post.categories.isNotEmpty) ...[
                    SizedBox(height: sh * 0.005),
                    Text(
                      post.categories.first,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: blueColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                  SizedBox(height: sh * 0.008),
                  Row(
                    children: [
                      if (post.authorName.isNotEmpty) ...[
                        Icon(Icons.person_outline,
                            size: sw * 0.03, color: lightBlackColor),
                        SizedBox(width: sw * 0.01),
                        Text(
                          post.authorName,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: lightBlackColor,
                                fontSize: sw * 0.028,
                              ),
                        ),
                        SizedBox(width: sw * 0.03),
                      ],
                      Icon(Icons.calendar_today,
                          size: sw * 0.028, color: lightBlackColor),
                      SizedBox(width: sw * 0.01),
                      Text(
                        AppConst().formatDate(post.date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: lightBlackColor,
                              fontSize: sw * 0.028,
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
}
