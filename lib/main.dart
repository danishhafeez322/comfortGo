import 'package:comfort_go/config/app_config.dart';
import 'package:comfort_go/constants/app_routes.dart';
import 'package:comfort_go/constants/app_strings.dart';
import 'package:comfort_go/firebase_options.dart';
import 'package:comfort_go/views/comfortGo_app/initial_binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppConfigurations.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: GetMaterialApp(
        title: AppInfo.appName,
        initialRoute: AppRoutes.initial,
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
        getPages: AppRoutes.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
