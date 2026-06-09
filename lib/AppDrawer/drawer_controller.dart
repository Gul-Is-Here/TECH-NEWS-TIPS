import 'package:get/get.dart';
import 'package:tnt/Services/category_service.dart';
import 'package:tnt/widgets/status_dialog.dart';
import '../Models/category_model.dart';
import '../Models/sub_category_model.dart';

class DrawerControllerX extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var categories = <CategoryModel>[].obs;

  /// Index of the currently expanded category row (-1 = all collapsed)
  var expandedIndex = (-1).obs;

  /// Subcategory lists keyed by category id
  var subCategories = <String, List<SubCategoryModel>>{}.obs;

  /// Per-category subcategory loading flags
  var subLoading = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // ─── Categories ──────────────────────────────────────────────────────────────

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';
    categories.clear();
    try {
      categories.value = await CategoryService.fetchCategories();
    } catch (_) {
      errorMessage.value = 'Failed to load categories';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Subcategories ───────────────────────────────────────────────────────────

  void toggleCategory(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
      final categoryId = categories[index].id;
      if (!subCategories.containsKey(categoryId)) {
        fetchSubCategories(categoryId);
      }
    }
  }

  Future<void> fetchSubCategories(String categoryId) async {
    subLoading[categoryId] = true;
    subLoading.refresh();
    try {
      subCategories[categoryId] =
          await CategoryService.fetchSubCategories(categoryId);
    } catch (_) {
      StatusDialog.show(
        success: false,
        message: 'Failed to load subcategories',
      );
    } finally {
      subLoading[categoryId] = false;
      subLoading.refresh();
    }
  }
}
