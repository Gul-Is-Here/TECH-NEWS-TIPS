class SubCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String parent;
  final String count;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.parent,
    required this.count,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['term_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      parent: json['parent'] ?? '',
      count: json['count'] ?? '',
    );
  }
}
