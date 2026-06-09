import '../Models/post.dart';
import 'api_client.dart';

class FavoritesService {
  static Future<List<Post>> fetchFavorites(int userId) async {
    final data = await ApiClient.get(
      '/user/favorites',
      queryParams: {'user_id': userId.toString()},
    );
    if (data['status'] == true) {
      final list = (data['favorites'] as List<dynamic>?) ?? [];
      return list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception(data['message'] ?? 'Failed to fetch favourites');
  }

  static Future<void> toggleFavorite({
    required int userId,
    required String postId,
    required bool add,
  }) async {
    final data = await ApiClient.postMultipart(
      '/user/favorites',
      fields: {
        'user_id': userId.toString(),
        'post_id': postId,
        'action': add ? 'add' : 'remove',
      },
    );
    if (data['status'] != true) {
      throw Exception(data['message'] ?? 'Failed to update favourite');
    }
  }
}
