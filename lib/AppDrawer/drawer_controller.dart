import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tnt/Models/sub_category_model.dart';
import 'package:tnt/widgets/status_dialog.dart';
import '../Models/category_model.dart';

class DrawerControllerX extends GetxController {
  var isLoading = true.obs; // 🔹 For categories only
  var errorMessage = ''.obs;
  var categories = <CategoryModel>[].obs;

  /// Which category index is expanded
  var expandedIndex = (-1).obs;

  /// Store subcategories per categoryId
  var subCategories = <String, List<SubCategoryModel>>{}.obs;

  /// Track loading per category (subcategory loader per id)
  var subLoading = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      categories.clear();

      final response = await http.get(
        Uri.parse('https://technewstips.com/api/categories/get_categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          categories.value =
              data.map((e) => CategoryModel.fromJson(e)).toList();
        } else {
          errorMessage.value = "Invalid response format.";
        }
      } else {
        errorMessage.value = "Server error: ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage.value = "Error: Something went wrong";
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCategory(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // collapse if same tapped
    } else {
      expandedIndex.value = index;
      final categoryId = categories[index].id;
      if (!subCategories.containsKey(categoryId)) {
        fetchSubCategories(categoryId);
      }
    }
  }

  Future<void> fetchSubCategories(String categoryId) async {
    try {
      subLoading[categoryId] = true; // 🔹 Only this category shows loader
      subLoading.refresh();

      final response = await http.get(
        Uri.parse(
            "https://technewstips.com/api/categories/get_subcategories/$categoryId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          subCategories[categoryId] =
              data.map((e) => SubCategoryModel.fromJson(e)).toList();
        }
      } else {
        // Get.snackbar("Error", "Failed to load subcategories");
        StatusDialog.show(success:false, message:" Failed to load subcategories");
      }
    } catch (e) {
      StatusDialog.show(success:false, message:" Something went wrong");
    } finally {
      subLoading[categoryId] = false;
      subLoading.refresh();
    }
  }
}
