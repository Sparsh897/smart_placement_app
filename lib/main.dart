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
  final authController = Get.put(AuthController());
  final onboardingController = Get.put(OnboardingController());
  Get.put(PlacementController());
  Get.put(UserController());
  
  // NEW FLOW: Login first, then onboarding, then main navigation
  String initialRoute;
  
  // Check if user is logged in by checking stored tokens
  final isUserLoggedIn = await TokenManager.isLoggedIn();
  
  // If user is logged in, make sure AuthController loads user data immediately
  if (isUserLoggedIn) {
    print('🚀 [MAIN] User is logged in, loading user data from storage...');
    // Force load user data from storage before app starts
    await authController.loadUserFromStorage();
    authController.isLoggedIn.value = true;
    print('🚀 [MAIN] User data loaded: ${authController.currentUser.value?.name}');
  } else {
    print('🚀 [MAIN] User is not logged in');
  }
  
  if (!isUserLoggedIn) {
    // User not logged in - go to auth screen
    initialRoute = Routes.auth;
  } else {
    // User is logged in - check onboarding status
    final isOnboardingComplete = await onboardingController.checkOnboardingStatus();
    if (!isOnboardingComplete) {
      initialRoute = Routes.onboarding;
    } else {
      initialRoute = Routes.mainNavigation;
    }
  }
  
  runApp(SmartPlacementApp(initialRoute: initialRoute));
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
