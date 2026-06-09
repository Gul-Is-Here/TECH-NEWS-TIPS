import 'package:get/get.dart';
import '../Config/app_config.dart';
import '../Models/post.dart';
import '../Services/favorites_service.dart';

class FavoritesController extends GetxController {
  final favoriteIds = <String>[].obs;
  final favoritePosts = <Post>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  bool isFavorite(String postId) => favoriteIds.contains(postId);

  Future<void> fetchFavorites() async {
    if (AppSession.userId == null) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final posts = await FavoritesService.fetchFavorites(AppSession.userId!);
      favoritePosts.assignAll(posts);
      favoriteIds.assignAll(posts.map((p) => p.id));
    } catch (_) {
      errorMessage.value = 'Failed to load favourites. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(Post post) async {
    if (AppSession.userId == null) return;

    final adding = !favoriteIds.contains(post.id);

    // Optimistic update — UI responds instantly
    if (adding) {
      favoriteIds.add(post.id);
      favoritePosts.add(post);
    } else {
      favoriteIds.remove(post.id);
      favoritePosts.removeWhere((p) => p.id == post.id);
    }

    try {
      await FavoritesService.toggleFavorite(
        userId: AppSession.userId!,
        postId: post.id,
        add: adding,
      );
    } catch (_) {
      // Roll back on API failure
      if (adding) {
        favoriteIds.remove(post.id);
        favoritePosts.removeWhere((p) => p.id == post.id);
      } else {
        favoriteIds.add(post.id);
        favoritePosts.add(post);
      }
    }
  }
}
