import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Globle/themes.dart';
import 'package:tnt/Screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNT',
      theme: Themes.lightTheme,
      home: const SplashScreen(),
    );
  }
}
