class Comment {
  final int id;
  final int postId;
  final String author;
  final String date;
  final String content;
  final bool approved;
  final int userId;

  Comment({
    required this.id,
    required this.postId,
    required this.author,
    required this.date,
    required this.content,
    required this.approved,
    required this.userId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: (json['ID'] as num?)?.toInt() ?? 0,
      postId: (json['post_id'] as num?)?.toInt() ?? 0,
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      content: json['content'] ?? '',
      approved: (json['approved']?.toString()) == '1',
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
    );
  }
}
