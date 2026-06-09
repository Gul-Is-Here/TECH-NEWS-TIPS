import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusDialog {
  static void show({
    required bool success,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Close any existing dialog
    if (Get.isDialogOpen ?? false) Get.back();

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.cancel,
                  color: success ? Colors.green : Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? (success ? "Done" : "Failed"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: success ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Auto close after duration
    Future.delayed(duration, () {
      // Make sure Navigator can pop (dialog is in stack)
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      }
    });
  }
}
