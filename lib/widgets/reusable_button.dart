// Reusable Button
import 'package:flutter/material.dart';
import 'package:tnt/Globle/colors.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: blueColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}