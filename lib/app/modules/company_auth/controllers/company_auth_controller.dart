import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/company_models.dart';
import '../../../data/services/company_service.dart';
import '../../../data/services/token_manager.dart';

class CompanyAuthController extends GetxController {
  final isLoading = false.obs;
  final isLogin = true.obs;
  final currentCompany = Rxn<Company>();
  final storage = GetStorage();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteController = TextEditingController();
  final industryController = TextEditingController();

  // Form validation
  final formKey = GlobalKey<FormState>();
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    websiteController.dispose();
    industryController.dispose();
    super.onClose();
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    _clearForm();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    descriptionController.clear();
    websiteController.clear();
    industryController.clear();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final token = await TokenManager.getAccessToken();
      developer.log('🔍 [CompanyAuth] Checking login status, token: ${token?.substring(0, 20)}...', 
          name: 'CompanyAuthController');
      
      if (token != null && token.isNotEmpty) {
        // Load company data from storage
        final companyData = storage.read('company_data');
        developer.log('🔍 [CompanyAuth] Company data from storage: ${companyData != null}', 
            name: 'CompanyAuthController');
        
        if (companyData != null) {
          currentCompany.value = Company.fromJson(companyData);
          developer.log('Company loaded from storage: ${currentCompany.value?.name}', 
              name: 'CompanyAuthController');
          
          // Only navigate to company dashboard if we're on the auth page
          final currentRoute = Get.currentRoute;
          developer.log('🔍 [CompanyAuth] Current route: $currentRoute', 
              name: 'CompanyAuthController');
          
          if (currentRoute == '/company-auth') {
            // Navigate to company dashboard only from auth page
            Get.offAllNamed('/company-dashboard');
          }
          return;
        }
      }
      
      developer.log('🔍 [CompanyAuth] No valid company session found', 
          name: 'CompanyAuthController');
    } catch (e) {
      developer.log('Error checking company login status: $e', 
          name: 'CompanyAuthController', level: 1000);
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await CompanyService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.success && response.data != null) {
        final authData = response.data!;
        
        // Check if we have a valid access token
        String tokenToSave = authData.tokens.accessToken;
        if (tokenToSave.isEmpty) {
          // Backend doesn't provide tokens, create a mock token for company auth
          tokenToSave = 'company_auth_${authData.company.id}_${DateTime.now().millisecondsSinceEpoch}';
          developer.log('⚠️ [CompanyAuth] No token from backend, using mock token', 
              name: 'CompanyAuthController');
        }
        
        // Save tokens
        await TokenManager.saveTokens(
          accessToken: tokenToSave,
          refreshToken: null, // Company API doesn't provide refresh token
        );

        // Save company data
        currentCompany.value = authData.company;
        await _saveCompanyToStorage(authData.company);

        developer.log('Company login successful: ${authData.company.name}', 
            name: 'CompanyAuthController');

        Get.snackbar(
          'Welcome Back!',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 2),
        );

        // Navigate to company dashboard
        Get.offAllNamed('/company-dashboard');
      } else {
        Get.snackbar(
          'Login Failed',
          response.error?.message ?? 'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      developer.log('Company login error: $e', name: 'CompanyAuthController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred during login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await CompanyService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        description: descriptionController.text.trim(),
        website: websiteController.text.trim().isNotEmpty 
            ? websiteController.text.trim() 
            : null,
        industry: industryController.text.trim().isNotEmpty 
            ? industryController.text.trim() 
            : null,
      );

      if (response.success && response.data != null) {
        final authData = response.data!;
        
        // Check if we have a valid access token
        String tokenToSave = authData.tokens.accessToken;
        if (tokenToSave.isEmpty) {
          // Backend doesn't provide tokens, create a mock token for company auth
          tokenToSave = 'company_auth_${authData.company.id}_${DateTime.now().millisecondsSinceEpoch}';
          developer.log('⚠️ [CompanyAuth] No token from backend, using mock token', 
              name: 'CompanyAuthController');
        }
        
        // Save tokens
        await TokenManager.saveTokens(
          accessToken: tokenToSave,
          refreshToken: null, // Company API doesn't provide refresh token
        );

        // Save company data
        currentCompany.value = authData.company;
        await _saveCompanyToStorage(authData.company);

        developer.log('Company registration successful: ${authData.company.name}', 
            name: 'CompanyAuthController');

        Get.snackbar(
          'Welcome!',
          'Company registered successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 2),
        );

        // Navigate to company dashboard
        Get.offAllNamed('/company-dashboard');
      } else {
        Get.snackbar(
          'Registration Failed',
          response.error?.message ?? 'Failed to register company',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      developer.log('Company registration error: $e', name: 'CompanyAuthController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred during registration. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Clear tokens
      await TokenManager.clearTokens();
      
      // Clear company data
      await _clearCompanyFromStorage();
      currentCompany.value = null;

      developer.log('Company logout successful', name: 'CompanyAuthController');

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 2),
      );

      // Navigate back to user type selection
      Get.offAllNamed('/user-type-selection');
    } catch (e) {
      developer.log('Company logout error: $e', name: 'CompanyAuthController', level: 1000);
    }
  }

  Future<void> _saveCompanyToStorage(Company company) async {
    try {
      await storage.write('company_data', company.toJson());
      developer.log('Company data saved to storage', name: 'CompanyAuthController');
    } catch (e) {
      developer.log('Error saving company data: $e', name: 'CompanyAuthController', level: 1000);
    }
  }

  Future<void> _clearCompanyFromStorage() async {
    try {
      await storage.remove('company_data');
      developer.log('Company data cleared from storage', name: 'CompanyAuthController');
    } catch (e) {
      developer.log('Error clearing company data: $e', name: 'CompanyAuthController', level: 1000);
    }
  }

  // Form validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateCompanyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    if (value.length < 2) {
      return 'Company name must be at least 2 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company description is required';
    }
    if (value.length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isURL(value)) {
        return 'Please enter a valid website URL';
      }
    }
    return null;
  }
}