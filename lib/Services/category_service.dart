import '../Models/category_model.dart';
import '../Models/sub_category_model.dart';
import 'api_client.dart';

class CategoryService {
  /// Fetch all top-level categories.
  static Future<List<CategoryModel>> fetchCategories() async {
    final data = await ApiClient.getList('/categories/get_categories');
    return data
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch subcategories for the given [categoryId].
  static Future<List<SubCategoryModel>> fetchSubCategories(
    String categoryId,
  ) async {
    final data =
        await ApiClient.getList('/categories/get_subcategories/$categoryId');
    return data
        .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
