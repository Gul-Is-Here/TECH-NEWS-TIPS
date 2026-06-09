class Post {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String date;
  final String? imageUrl;
  final String authorName;
  final List<String> categories;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.date,
    required this.authorName,
    this.imageUrl,
    required this.categories,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['ID'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      date: json['date'] ?? '',
      authorName: json['author']?['display_name'] ?? '',
      imageUrl: json['featured_image'],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((c) => c['name'].toString())
              .toList() ??
          [],
    );
  }
}
