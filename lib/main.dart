import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tnt/Screens/Auth/auth_screen.dart';
import 'package:tnt/Bindings/app_bindings.dart';
import 'package:tnt/Globle/app_const.dart';
import 'package:tnt/Globle/themes.dart';
import 'package:tnt/Screens/home.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await AppConst.loadUserData(); // load saved data

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TNT',
    //  initialBinding: GlobalAppBinding(),
      theme: Themes.lightTheme,
      home:   //LottieExample()
       AppConst.userId != null ? Home() : AuthScreen(),
    );
  }
}

