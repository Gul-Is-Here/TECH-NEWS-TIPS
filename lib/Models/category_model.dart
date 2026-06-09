class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String count;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['term_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      count: json['count'] ?? '',
    );
  }
}
