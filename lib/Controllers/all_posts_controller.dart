import 'package:get/get.dart';
import '../Models/post.dart';
import '../Services/post_service.dart';

class AllPostsController extends GetxController {
  var posts = <Post>[].obs;
  var latestThree = <Post>[].obs;
  var isLoading = false.obs;
  var categoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLatestThree();
  }

  // ─── Fetch posts (all or by category) ───────────────────────────────────────

  Future<void> fetchPosts({int? category}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    posts.clear();
    categoryId.value = category ?? 0;

    try {
      posts.value = await PostService.fetchPosts(categoryId: categoryId.value);
    } catch (_) {
      // Posts list stays empty; UI already shows "No posts found"
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Always keep the latest 3 posts for the sidebar ─────────────────────────

  Future<void> fetchLatestThree() async {
    try {
      final all = await PostService.fetchPosts();
      latestThree.value = all.take(3).toList();
    } catch (_) {
      // Silent — latest three is a non-critical UI enhancement
    }
  }

  // ─── Related posts ───────────────────────────────────────────────────────────

  Future<List<Post>> getRelatedPosts(Post currentPost) async {
    if (posts.isEmpty) await fetchPosts();
    if (currentPost.categories.isEmpty) return [];

    // Prefer second category (more specific) when available, otherwise first
    final String target = currentPost.categories.length > 1
        ? currentPost.categories[1]
        : currentPost.categories.first;

    final related = posts.where((p) {
      if (p.id == currentPost.id || p.categories.isEmpty) return false;
      final pCategory = p.categories.length > 1 ? p.categories[1] : p.categories.first;
      return pCategory == target;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return related.take(3).toList();
  }
}
