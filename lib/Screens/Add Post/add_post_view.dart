import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Globle/colors.dart';
import '../../Controllers/add_post_view_controller.dart';

class AddPostView extends StatelessWidget {
  const AddPostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddPostViewController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                controller: controller.nameController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: controller.emailController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Email is required";
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(val)) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Category Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                    items: controller.categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) =>
                        controller.selectedCategory.value = val ?? "",
                        style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      labelText: "Category",
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Category required" : null,
                  )),
              const SizedBox(height: 12),

              // File Picker
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.fileName.value.isEmpty
                              ? "No file chosen"
                              : controller.fileName.value,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => controller.pickFile(),
                        child: Text("Choose File",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: whiteColor)),
                      ),
                    ],
                  )),
              const SizedBox(height: 12),

              // Additional Info
              TextFormField(
                controller: controller.additionalInfoController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  labelText: "Additional Information",
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.submitForm(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: blueColor,
                  ),
                  child: Text("Submit",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: whiteColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
