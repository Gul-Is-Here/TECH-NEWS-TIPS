import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tnt/Controllers/auth_screen_controller.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/widgets/app_loader.dart';
import 'package:tnt/widgets/reusable_button.dart';
import 'package:tnt/widgets/reusable_textfield.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  
var authController = Get.put(AuthScreenController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Logo at top
                Image.asset(
                  "assets/images/tnt_logo.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),

                
         // Toggle Buttons
Obx(() => Container(
  decoration: BoxDecoration(
    color: greyColor,
    borderRadius: BorderRadius.circular(30),
  ),
  child: Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
  authController.resetAllControllers(); // ✅ clear old data
  authController.isLoginScreen.value = true;
},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: authController.isLoginScreen.value ? blueColor : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: authController.isLoginScreen.value ? whiteColor : blackColor,
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTap: () {
  authController.resetAllControllers(); // ✅ clear old data
  authController.isLoginScreen.value = false;
},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: !authController.isLoginScreen.value ? blueColor : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "Registration",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: !authController.isLoginScreen.value ? whiteColor : blackColor,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
)),

const SizedBox(height: 20),

// Forms
Obx(() => authController.isLoginScreen.value
    ? _buildLoginForm(context)
    : _buildSignupForm(context),
),


                const SizedBox(height: 20),

                // // Forms
                // if (authController.isLoginScreen.value) _buildLoginForm(context) else _buildSignupForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildLoginForm(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ReusableTextField(
        label: "E-mail Address",
        hintText: "Enter your email",
        controller: authController.lEmailController, // ✅ use from controller
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 10),

      ReusableTextField(
        label: "Password",
        hintText: "Enter your password",
        controller: authController.lPasswordController, // ✅
        isPassword: true,
      ),
      const SizedBox(height: 20),

      Obx(() => authController.isLoading.value ? AppLoader() : ReusableButton(
            text:  "Login",
            onPressed: () {
              authController.login(
                authController.lEmailController.text,
                authController.lPasswordController.text,
              );
            },
          )),
    ],
  );
}

Widget _buildSignupForm(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ReusableTextField(
        label: "Username",
        hintText: "Enter username",
        controller: authController.usernameController, // ✅
      ),
      const SizedBox(height: 10),

      ReusableTextField(
        label: "E-mail Address",
        hintText: "Enter email",
        controller: authController.sEmailController, // ✅
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 10),

      ReusableTextField(
        label: "First Name",
        hintText: "Enter first name",
        controller: authController.firstNameController, // ✅
      ),
      const SizedBox(height: 10),

      ReusableTextField(
        label: "Last Name",
        hintText: "Enter last name",
        controller: authController.lastNameController, // ✅
      ),
      const SizedBox(height: 10),

      ReusableTextField(
        label: "Password",
        hintText: "Enter password",
        controller: authController.sPasswordController, // ✅
        isPassword: true,
      ),
      const SizedBox(height: 10),

      ReusableTextField(
        label: "Confirm Password",
        hintText: "Re-enter password",
        controller: authController.confirmPasswordController, // ✅
        isPassword: true,
      ),
      const SizedBox(height: 20),

      Obx(() =>authController.isLoading.value ? AppLoader() : ReusableButton(
            text:"Register",
            onPressed: () {
              authController.signup(
                username: authController.usernameController.text,
                email: authController.sEmailController.text,
                firstName: authController.firstNameController.text,
                lastName: authController.lastNameController.text,
                password: authController.sPasswordController.text,
                confirmPassword: authController.confirmPasswordController.text,
              );
            },
          )),
    ],
  );
}

}

