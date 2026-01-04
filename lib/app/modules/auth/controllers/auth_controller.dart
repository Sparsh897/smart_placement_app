import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/user_models.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/http_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/token_manager.dart';
import '../../onboarding/controllers/onboarding_controller.dart';
import '../../placement/controllers/placement_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../home/controllers/home_controller.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();
  final isLoading = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  @override
  void onInit() {
    super.onInit();
    // Clear any corrupted user data first
    clearCorruptedUserData();
    // Check if user is already logged in
    _checkLoginStatus();
    // Test Google Sign-In initialization
    _testGoogleSignInSetup();
  }
  
  void _testGoogleSignInSetup() async {
    try {
      // Test if Google Sign-In is properly configured
      final bool canSignIn = await _googleSignIn.canAccessScopes(['email']);
      print('Google Sign-In can access email scope: $canSignIn');
    } catch (e) {
      print('Google Sign-In setup test failed: $e');
    }
  }

  void _checkLoginStatus() async {
    try {
      // Check if this is a company session first
      final isCompanyLoggedIn = await TokenManager.isCompanyLoggedIn();
      if (isCompanyLoggedIn) {
        print('🔐 [AUTH] Company session detected, skipping user auth check');
        isLoggedIn.value = false;
        currentUser.value = null;
        return;
      }
      
      final isLoggedInStored = await AuthService.isLoggedIn();
      if (isLoggedInStored) {
        // Set logged in state immediately based on token existence
        isLoggedIn.value = true;
        
        // Try to load user data from local storage first
        await loadUserFromStorage();
        
        // If no user data in storage, try to get from API
        if (currentUser.value == null) {
          print('🔐 [AUTH] No user data in storage, fetching from API...');
          final response = await AuthService.getCurrentUser();
          if (response.success && response.data != null) {
            currentUser.value = response.data;
            // Save user data to storage for next time
            await saveUserToStorage(response.data!);
            print('🔐 [AUTH] User data fetched from API and saved: ${response.data!.name}');
          } else {
            // Token might be expired, clear it
            print('🔐 [AUTH] Failed to fetch user data, token might be expired');
            await AuthService.logout();
            await _clearUserFromStorage();
            isLoggedIn.value = false;
            currentUser.value = null;
          }
        } else {
          print('🔐 [AUTH] User data loaded from storage: ${currentUser.value!.name}');
          // Still refresh user data from API in background
          AuthService.getCurrentUser().then((response) {
            if (response.success && response.data != null) {
              currentUser.value = response.data;
              saveUserToStorage(response.data!);
            }
          });
        }
      } else {
        isLoggedIn.value = false;
        currentUser.value = null;
        await _clearUserFromStorage();
      }
    } catch (e) {
      print('Error checking login status: $e');
      // If API fails, still try to load from storage
      if (isLoggedIn.value) {
        await loadUserFromStorage();
      } else {
        isLoggedIn.value = false;
        currentUser.value = null;
      }
    }
  }

  Future<bool> login(String email, String password) async {
    if (isLoading.value) return false;
    
    print('🔐 [AUTH] Starting login for email: $email');
    isLoading.value = true;
    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        currentUser.value = response.data!.user;
        isLoggedIn.value = true;
        
        // Save user data to storage
        await saveUserToStorage(response.data!.user);
        
        // Navigate to appropriate screen after login
        await _navigateAfterLogin();
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    if (isLoading.value) return false;
    
    print('📝 [AUTH] Starting registration for: $name ($email)');
    isLoading.value = true;
    try {
      final response = await AuthService.register(
        name: name,
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        currentUser.value = response.data!.user;
        isLoggedIn.value = true;
        
        // Save user data to storage
        await saveUserToStorage(response.data!.user);
        
        // Navigate to appropriate screen after signup
        await _navigateAfterLogin();
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('Signup error: $e');
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Registration failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    if (isLoading.value) return false;
    
    print('🔍 [AUTH] Starting Google Sign-In');
    isLoading.value = true;
    try {
      // Check if Google Play Services are available
      final bool isAvailable = await _googleSignIn.isSignedIn();
      print('🔍 [AUTH] Google Sign-In available: $isAvailable');
      
      // Sign out first to ensure clean state
      await _googleSignIn.signOut();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        print('Google Sign-In: User canceled');
        return false;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Verify we have the required tokens
      if (googleAuth.idToken == null) {
        print('Google Sign-In: No ID token received');
        return false;
      }

      // Create Google user info
      final googleUserInfo = GoogleUserInfo(
        email: googleUser.email,
        name: googleUser.displayName ?? 'Google User',
        picture: googleUser.photoUrl,
        sub: googleUser.id,
      );

      // Send to backend API
      final response = await AuthService.googleLogin(
        googleToken: googleAuth.accessToken ?? '',
        userInfo: googleUserInfo,
      );

      if (response.success && response.data != null) {
        currentUser.value = response.data!.user;
        isLoggedIn.value = true;
        print('Google Sign-In successful for: ${googleUser.email}');
        
        // Save user data to storage
        await saveUserToStorage(response.data!.user);
        
        // Navigate to appropriate screen after Google sign-in
        await _navigateAfterLogin();
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      
      // Provide more specific error handling
      if (error.toString().contains('channel-error')) {
        print('Channel error - try restarting the app completely');
      } else if (error.toString().contains('network_error')) {
        print('Network error - check internet connection');
      } else if (error.toString().contains('sign_in_canceled')) {
        print('Sign in was canceled by user');
      }
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Call API logout
      await AuthService.logout();
      
      // Sign out from Google as well
      await _googleSignIn.signOut();
      
      // Clear local state
      currentUser.value = null;
      isLoggedIn.value = false;
      
      // Clear ALL local storage data
      await _clearAllLocalStorage();
      
      // Navigate to login page
      Get.offAllNamed('/auth');
    } catch (e) {
      print('Logout error: $e');
      // Even if API call fails, clear local state
      currentUser.value = null;
      isLoggedIn.value = false;
      await _clearAllLocalStorage();
      Get.offAllNamed('/auth');
    }
  }

  bool requireAuth(String action) {
    if (!isLoggedIn.value) {
      Get.toNamed('/auth', arguments: action);
      return false;
    }
    return true;
  }

  Future<void> _navigateAfterLogin() async {
    // First check if user has educational preferences in their profile
    final hasPreferences = UserService.hasEducationalPreferences(currentUser.value);
    
    if (!hasPreferences) {
      // User doesn't have educational preferences, show onboarding
      print('🔐 [AUTH] User missing educational preferences, navigating to onboarding');
      Get.offAllNamed('/onboarding');
      return;
    }
    
    // User has preferences in profile, sync to local storage and navigate to main app
    print('🔐 [AUTH] User has educational preferences in profile');
    final onboardingController = Get.find<OnboardingController>();
    final profile = currentUser.value?.profile;
    
    if (profile != null) {
      // Save user's profile preferences to local storage for consistency
      await onboardingController.saveOnboardingData(
        educationLevel: profile.educationLevel ?? '',
        course: profile.course ?? '',
        specialization: profile.specialization ?? '',
      );
      print('🔐 [AUTH] Synced preferences to local storage: ${profile.educationLevel}, ${profile.course}, ${profile.specialization}');
    }
    
    // Navigate directly to main app
    print('🔐 [AUTH] Navigating to main app');
    Get.offAllNamed('/main');
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await AuthService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (response.success) {
        if (Get.context != null) {
          Get.snackbar(
            'Success',
            'Password changed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        }
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('Change password error: $e');
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Failed to change password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAccount() async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await AuthService.deleteAccount();

      if (response.success) {
        // Clear local state
        currentUser.value = null;
        isLoggedIn.value = false;
        
        if (Get.context != null) {
          Get.snackbar(
            'Account Deleted',
            'Your account has been deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        }
        
        // Navigate to home
        Get.offAllNamed('/home');
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('Delete account error: $e');
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Failed to delete account. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods for user data storage
  Future<void> saveUserToStorage(User user) async {
    try {
      final storage = GetStorage();
      final userJson = user.toJson();
      print('🔐 [AUTH] Saving user to storage: ${user.name}');
      print('🔐 [AUTH] User JSON: $userJson');
      await storage.write('current_user', userJson);
      print('🔐 [AUTH] User data saved to storage successfully');
    } catch (e) {
      print('🔐 [AUTH] Error saving user to storage: $e');
    }
  }

  Future<void> loadUserFromStorage() async {
    try {
      final storage = GetStorage();
      final userData = storage.read('current_user');
      print('🔐 [AUTH] Raw user data from storage: $userData');
      if (userData != null) {
        currentUser.value = User.fromJson(userData);
        print('🔐 [AUTH] User data loaded from storage: ${currentUser.value?.name}');
      } else {
        print('🔐 [AUTH] No user data found in storage');
      }
    } catch (e) {
      print('🔐 [AUTH] Error loading user from storage: $e');
    }
  }

  Future<void> _clearUserFromStorage() async {
    try {
      final storage = GetStorage();
      await storage.remove('current_user');
      print('🔐 [AUTH] User data cleared from storage');
    } catch (e) {
      print('🔐 [AUTH] Error clearing user from storage: $e');
    }
  }

  // Method to clear old/corrupted user data
  Future<void> clearCorruptedUserData() async {
    try {
      final storage = GetStorage();
      final userData = storage.read('current_user');
      if (userData != null) {
        // Check if user data is corrupted (empty name/email)
        if (userData is Map && 
            (userData['name'] == null || userData['name'] == '' ||
             userData['email'] == null || userData['email'] == '')) {
          print('🔐 [AUTH] Detected corrupted user data, clearing...');
          await storage.remove('current_user');
          print('🔐 [AUTH] Corrupted user data cleared');
        }
      }
    } catch (e) {
      print('🔐 [AUTH] Error checking/clearing corrupted user data: $e');
    }
  }

  // Method to clear ALL local storage data on logout
  Future<void> _clearAllLocalStorage() async {
    try {
      print('🔐 [AUTH] Clearing all local storage data...');
      
      // Clear GetStorage data (user data, onboarding data, etc.)
      final storage = GetStorage();
      await storage.erase(); // This clears all GetStorage data
      print('🔐 [AUTH] GetStorage data cleared');
      
      // Clear SharedPreferences data (tokens)
      await AuthService.logout(); // This already clears tokens via TokenManager
      print('🔐 [AUTH] SharedPreferences tokens cleared');
      
      // Clear any other controller states (if they exist)
      try {
        if (Get.isRegistered<OnboardingController>()) {
          final onboardingController = Get.find<OnboardingController>();
          onboardingController.selectedEducationLevel.value = null;
          onboardingController.selectedCourse.value = null;
          onboardingController.selectedSpecialization.value = null;
          print('🔐 [AUTH] OnboardingController state cleared');
        }
      } catch (e) {
        print('🔐 [AUTH] OnboardingController not available: $e');
      }
      
      // Clear PlacementController data if available
      try {
        if (Get.isRegistered<PlacementController>()) {
          final placementController = Get.find<PlacementController>();
          placementController.jobs.clear();
          placementController.currentPage.value = 1;
          placementController.hasMoreJobs.value = true;
          print('🔐 [AUTH] PlacementController state cleared');
        }
      } catch (e) {
        print('🔐 [AUTH] PlacementController not available: $e');
      }
      
      // Clear UserController data if available
      try {
        if (Get.isRegistered<UserController>()) {
          final userController = Get.find<UserController>();
          userController.userProfile.value = null;
          userController.isLoading.value = false;
          print('🔐 [AUTH] UserController state cleared');
        }
      } catch (e) {
        print('🔐 [AUTH] UserController not available: $e');
      }
      
      // Clear HomeController data if available
      try {
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.searchQuery.value = '';
          homeController.selectedDomains.clear();
          print('🔐 [AUTH] HomeController state cleared');
        }
      } catch (e) {
        print('🔐 [AUTH] HomeController not available: $e');
      }
      
      print('🔐 [AUTH] All local storage data cleared successfully');
    } catch (e) {
      print('🔐 [AUTH] Error clearing local storage: $e');
      // Fallback: clear individual items
      try {
        final storage = GetStorage();
        await storage.remove('current_user');
        await storage.remove('onboarding_complete');
        await storage.remove('education_level');
        await storage.remove('course');
        await storage.remove('specialization');
        print('🔐 [AUTH] Fallback: Individual items cleared');
      } catch (fallbackError) {
        print('🔐 [AUTH] Fallback clear also failed: $fallbackError');
      }
    }
  }
}
