import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/onboarding/controllers/onboarding_controller.dart';
import 'app/modules/placement/controllers/placement_controller.dart';
import 'app/modules/user/controllers/user_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize controllers globally
  Get.put(AuthController());
  Get.put(OnboardingController());
  Get.put(PlacementController());
  Get.put(UserController());
  
  // Check for existing session and determine initial route
  String initialRoute = await _determineInitialRoute();
  
  runApp(SmartPlacementApp(initialRoute: initialRoute));
}

Future<String> _determineInitialRoute() async {
  // Check if user is logged in and what type
  final isCompanyLoggedIn = await TokenManager.isCompanyLoggedIn();
  final isUserLoggedIn = await TokenManager.isUserLoggedIn();
  final accessToken = await TokenManager.getAccessToken();
  final userType = await TokenManager.getUserType();
  
  print('🔍 [MAIN] Initial route determination:');
  print('🔍 [MAIN] Access token exists: ${accessToken != null}');
  print('🔍 [MAIN] User type: $userType');
  print('🔍 [MAIN] Is company logged in: $isCompanyLoggedIn');
  print('🔍 [MAIN] Is user logged in: $isUserLoggedIn');
  
  if (isCompanyLoggedIn) {
    print('🔍 [MAIN] Routing to company dashboard');
    return Routes.companyDashboard;
  } else if (isUserLoggedIn) {
    print('🔍 [MAIN] Routing to main navigation');
    return Routes.mainNavigation;
  } else {
    print('🔍 [MAIN] Routing to user type selection');
    return Routes.userTypeSelection;
  }
}

class SmartPlacementApp extends StatelessWidget {
  final String initialRoute;
  
  const SmartPlacementApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Placement App',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      initialBinding: AppPages.initialBinding,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
