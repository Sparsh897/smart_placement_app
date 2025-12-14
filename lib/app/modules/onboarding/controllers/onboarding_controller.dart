import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/user_models.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/http_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../placement/controllers/placement_controller.dart';

class OnboardingController extends GetxController {
  final selectedEducationLevel = RxnString();
  final selectedCourse = RxnString();
  final selectedSpecialization = RxnString();
  final isLoading = false.obs;

  bool get isOnboardingComplete =>
      selectedEducationLevel.value != null &&
      selectedCourse.value != null &&
      selectedSpecialization.value != null;

  // Method to update preferences immediately when all selections are made
  Future<void> updatePreferencesIfComplete() async {
    if (isOnboardingComplete) {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (isLoggedIn) {
        print('📋 [ONBOARDING] All selections complete, updating preferences immediately');
        await _updatePreferencesInBackground();
      }
    }
  }

  // Background method to update preferences without blocking UI
  Future<void> _updatePreferencesInBackground() async {
    try {
      final response = await UserService.updateEducationalPreferences(
        educationLevel: selectedEducationLevel.value!,
        course: selectedCourse.value!,
        specialization: selectedSpecialization.value!,
      );
      
      if (response.success) {
        print('📋 [ONBOARDING] Background preferences update successful');
        
        // Update the current user in AuthController
        final authController = Get.find<AuthController>();
        authController.currentUser.value = response.data;
        await authController.saveUserToStorage(response.data!);
        
        // Save locally for consistency
        await saveOnboardingData();
        
        // Trigger job loading with new preferences
        final placementController = Get.find<PlacementController>();
        await placementController.loadJobs(refresh: true);
        
        print('📋 [ONBOARDING] Jobs refreshed with new preferences');
      } else {
        print('📋 [ONBOARDING] Background preferences update failed: ${response.error?.message}');
      }
    } catch (e) {
      print('📋 [ONBOARDING] Error in background preferences update: $e');
    }
  }

  // Getters for API calls
  String? get savedEducationLevel {
    final storage = GetStorage();
    return storage.read('education_level');
  }

  String? get savedCourse {
    final storage = GetStorage();
    return storage.read('course');
  }

  String? get savedSpecialization {
    final storage = GetStorage();
    return storage.read('specialization');
  }

  Future<bool> checkOnboardingStatus() async {
    print('📋 [ONBOARDING] Checking onboarding status');
    final storage = GetStorage();
    final isComplete = storage.read('onboarding_complete') ?? false;
    
    if (isComplete) {
      selectedEducationLevel.value = storage.read('education_level');
      selectedCourse.value = storage.read('course');
      selectedSpecialization.value = storage.read('specialization');
      print('📋 [ONBOARDING] Found existing onboarding data - Level: ${selectedEducationLevel.value}, Course: ${selectedCourse.value}, Specialization: ${selectedSpecialization.value}');
    } else {
      print('📋 [ONBOARDING] No existing onboarding data found');
    }
    
    return isComplete;
  }

  Future<void> saveOnboardingData({
    String? educationLevel,
    String? course,
    String? specialization,
  }) async {
    print('📋 [ONBOARDING] Saving onboarding data locally');
    final storage = GetStorage();
    
    // Use provided values or current selected values
    final levelToSave = educationLevel ?? selectedEducationLevel.value!;
    final courseToSave = course ?? selectedCourse.value!;
    final specializationToSave = specialization ?? selectedSpecialization.value!;
    
    await storage.write('onboarding_complete', true);
    await storage.write('education_level', levelToSave);
    await storage.write('course', courseToSave);
    await storage.write('specialization', specializationToSave);
    
    // Update current values if provided
    if (educationLevel != null) selectedEducationLevel.value = educationLevel;
    if (course != null) selectedCourse.value = course;
    if (specialization != null) selectedSpecialization.value = specialization;
    
    print('📋 [ONBOARDING] Saved - Level: $levelToSave, Course: $courseToSave, Specialization: $specializationToSave');
  }

  Future<void> completeOnboarding() async {
    if (!isOnboardingComplete) {
      print('📋 [ONBOARDING] Cannot complete - missing required fields');
      return;
    }
    
    print('📋 [ONBOARDING] Starting onboarding completion');
    isLoading.value = true;
    try {
      // Check if user is logged in
      final isLoggedIn = await AuthService.isLoggedIn();
      print('📋 [ONBOARDING] User logged in: $isLoggedIn');
      
      if (isLoggedIn) {
        // Update user educational preferences via API
        print('📋 [ONBOARDING] Updating educational preferences via API');
        final response = await UserService.updateEducationalPreferences(
          educationLevel: selectedEducationLevel.value!,
          course: selectedCourse.value!,
          specialization: selectedSpecialization.value!,
        );
        
        if (response.success) {
          print('📋 [ONBOARDING] Educational preferences updated successfully via API');
          await saveOnboardingData();
          
          // Update the current user in AuthController
          final authController = Get.find<AuthController>();
          authController.currentUser.value = response.data;
          await authController.saveUserToStorage(response.data!);
          
          // Trigger job loading with new preferences
          final placementController = Get.find<PlacementController>();
          await placementController.loadJobs(refresh: true);
          
          Get.snackbar(
            'Success',
            'Educational preferences updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        } else {
          print('📋 [ONBOARDING] Educational preferences update failed via API: ${response.error?.message}');
          if (response.error != null) {
            HttpService.handleApiError(response.error!);
          }
          // Still save locally even if API fails
          await saveOnboardingData();
        }
      } else {
        print('📋 [ONBOARDING] User not logged in, saving locally only');
        // Just save locally if not logged in
        await saveOnboardingData();
      }
      
      print('📋 [ONBOARDING] Navigating to main navigation screen');
      Get.offAllNamed('/main');
    } catch (e) {
      print('📋 [ONBOARDING] Error completing onboarding: $e');
      // Still save locally and proceed
      await saveOnboardingData();
      Get.offAllNamed('/main');
    } finally {
      isLoading.value = false;
    }
  }
}
