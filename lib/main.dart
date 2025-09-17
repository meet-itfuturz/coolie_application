import 'package:coolie_application/repositories/authentication_repo.dart';
import 'package:coolie_application/routes/route_name.dart';
import 'package:coolie_application/routes/route_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'utils/app_config.dart';
import 'utils/theme_constants.dart';



void main() async{
  await GetStorage.init();

  // await loadRepositories();
  await GetStorage.init();
  await loadRepositories();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      initialRoute: RouteName.splash,
      getPages: RoutePages.pages,
      defaultTransition: Transition.rightToLeftWithFade,
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
    );
  }
}

Future<void> loadRepositories() async {
  await Get.putAsync(() => AuthenticationRepo().init());
  // Get.put(FeeManagementController());
}

// Future<void> loadRepositories() async {
//   await Get.putAsync(() => AuthenticationRepo().init());
//   Get.put(FeeManagementController());
// }

