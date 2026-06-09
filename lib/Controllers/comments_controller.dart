import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/comment.dart';
import '../Services/comment_service.dart';

class CommentsController extends GetxController {
  final String postId;
  CommentsController(this.postId);

  final comments = <Comment>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final inputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await CommentService.fetchComments(postId);
      comments.assignAll(result);
    } catch (_) {
      errorMessage.value = 'Failed to load comments';
    } finally {
      isLoading.value = false;
    }
  }

  // Wired up once the add-comment API is available.
  Future<void> submitComment() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    // TODO: await CommentService.addComment(postId: postId, userId: AppSession.userId!, content: text);
    inputController.clear();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
