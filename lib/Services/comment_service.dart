import '../Models/comment.dart';
import 'api_client.dart';

class CommentService {
  static Future<List<Comment>> fetchComments(String postId) async {
    final data = await ApiClient.get(
      '/user/comments',
      queryParams: {'post_id': postId},
    );
    if (data['status'] == true) {
      final list = (data['comments'] as List<dynamic>?) ?? [];
      return list
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(data['message'] ?? 'Failed to load comments');
  }

  static Future<Comment> addComment({
    required String postId,
    required int userId,
    required String content,
  }) async {
    final data = await ApiClient.postMultipart(
      '/user/comments',
      fields: {
        'post_id': postId,
        'user_id': userId.toString(),
        'comment': content,
      },
    );
    if (data['status'] == true && data['comment'] != null) {
      return Comment.fromJson(data['comment'] as Map<String, dynamic>);
    }
    throw Exception(data['message'] ?? 'Failed to post comment');
  }

  // TODO: Connect when the edit-comment endpoint is available.
  // static Future<void> editComment({
  //   required int commentId,
  //   required String content,
  // }) async { ... }
}
