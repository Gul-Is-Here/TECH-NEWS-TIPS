import '../Models/post.dart';
import 'api_client.dart';

class PostService {
  /// Fetch all posts, or posts filtered by [categoryId].
  static Future<List<Post>> fetchPosts({int? categoryId}) async {
    final path = (categoryId == null || categoryId == 0)
        ? '/posts/get_posts'
        : '/posts/category/$categoryId';

    final data = await ApiClient.getList(path);
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }
}
