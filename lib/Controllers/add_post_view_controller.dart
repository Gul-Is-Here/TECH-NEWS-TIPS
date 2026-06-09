import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class AddPostViewController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final additionalInfoController = TextEditingController();

  // Dropdown
  final categories = ["Technology", "Business", "Sports", "Education"].obs;
  var selectedCategory = "".obs;

  // File picker
  var fileName = "".obs;
  String? filePath;

  Future<void> pickFile() async {
    print("DEBUG: Opening file picker...");

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "doc", "docx"],
    );

    if (result != null && result.files.single.path != null) {
      filePath = result.files.single.path!;
      fileName.value = result.files.single.name;
      print("DEBUG: File selected -> $filePath");
    } else {
      print("DEBUG: No file selected.");
    }
  }

  void submitForm() {
    print("DEBUG: Submit button clicked");

    if (!formKey.currentState!.validate()) {
      print("DEBUG: Validation failed.");
      Get.snackbar("Error", "Please fill all required fields",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (filePath == null) {
      print("DEBUG: No file attached.");
      Get.snackbar("Error", "Please attach a file",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 👉 Send data to backend
    print("DEBUG: Form is valid. Submitting data...");
    print("Name: ${nameController.text}");
    print("Email: ${emailController.text}");
    print("Category: ${selectedCategory.value}");
    print("File: $filePath");
    print("Info: ${additionalInfoController.text}");

    Get.snackbar("Success", "Form submitted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}
