import '../models/api_response.dart';
import '../models/user_models.dart';
import 'api_config.dart';
import 'http_service.dart';
import 'token_manager.dart';

class AuthService {
  // Register with email/password
  static Future<ApiResponse<AuthData>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    print('🔐 [AUTH_SERVICE] Starting registration for: $name ($email)');
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };
    
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
      print('🔐 [AUTH_SERVICE] Including phone number in registration');
    }

    final response = await HttpService.post<AuthData>(
      '${ApiConfig.auth}/register',
      body: body,
      fromJson: (json) => AuthData.fromJson(json),
    );

    // Save tokens if successful
    if (response.success && response.data != null) {
      print('🔐 [AUTH_SERVICE] Registration successful, saving tokens');
      await TokenManager.saveTokens(
        accessToken: response.data!.tokens.accessToken,
        refreshToken: response.data!.tokens.refreshToken,
        userId: response.data!.user.id,
      );
      print('🔐 [AUTH_SERVICE] Tokens saved for user: ${response.data!.user.id}');
    } else {
      print('🔐 [AUTH_SERVICE] Registration failed: ${response.error?.message}');
    }

    return response;
  }

  // Login with email/password
  static Future<ApiResponse<AuthData>> login({
    required String email,
    required String password,
  }) async {
    print('🔐 [AUTH_SERVICE] Starting login for: $email');
    final response = await HttpService.post<AuthData>(
      '${ApiConfig.auth}/login',
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => AuthData.fromJson(json),
    );

    // Save tokens if successful
    if (response.success && response.data != null) {
      print('🔐 [AUTH_SERVICE] Login successful, saving tokens');
      await TokenManager.saveTokens(
        accessToken: response.data!.tokens.accessToken,
        refreshToken: response.data!.tokens.refreshToken,
        userId: response.data!.user.id,
      );
      print('🔐 [AUTH_SERVICE] Tokens saved for user: ${response.data!.user.id}');
    } else {
      print('🔐 [AUTH_SERVICE] Login failed: ${response.error?.message}');
    }

    return response;
  }

  // Google OAuth login
  static Future<ApiResponse<AuthData>> googleLogin({
    required String googleToken,
    required GoogleUserInfo userInfo,
    String? firebaseUid,
  }) async {
    print('🔐 [AUTH_SERVICE] Starting Google OAuth login for: ${userInfo.email}');
    final body = {
      'googleToken': googleToken,
      'userInfo': userInfo.toJson(),
    };
    
    if (firebaseUid != null) {
      body['firebaseUid'] = firebaseUid;
      print('🔐 [AUTH_SERVICE] Including Firebase UID in Google login');
    }

    final response = await HttpService.post<AuthData>(
      '${ApiConfig.auth}/google/mobile',
      body: body,
      fromJson: (json) => AuthData.fromJson(json),
    );

    // Save tokens if successful
    if (response.success && response.data != null) {
      print('🔐 [AUTH_SERVICE] Google login successful, saving tokens');
      await TokenManager.saveTokens(
        accessToken: response.data!.tokens.accessToken,
        refreshToken: response.data!.tokens.refreshToken,
        userId: response.data!.user.id,
      );
      print('🔐 [AUTH_SERVICE] Tokens saved for Google user: ${response.data!.user.id}');
    } else {
      print('🔐 [AUTH_SERVICE] Google login failed: ${response.error?.message}');
    }

    return response;
  }

  // Get current user info
  static Future<ApiResponse<User>> getCurrentUser() async {
    return await HttpService.get<User>(
      '${ApiConfig.auth}/me',
      fromJson: (json) => User.fromJson(json['user']),
      requiresAuth: true,
    );
  }

  // Change password
  static Future<ApiResponse<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await HttpService.post<Map<String, dynamic>>(
      '${ApiConfig.auth}/change-password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );
  }

  // Logout
  static Future<ApiResponse<Map<String, dynamic>>> logout() async {
    print('🔐 [AUTH_SERVICE] Starting logout process');
    final response = await HttpService.post<Map<String, dynamic>>(
      '${ApiConfig.auth}/logout',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );

    // Clear local tokens regardless of API response
    print('🔐 [AUTH_SERVICE] Clearing local tokens');
    await TokenManager.clearTokens();
    print('🔐 [AUTH_SERVICE] Logout completed');

    return response;
  }

  // Delete account
  static Future<ApiResponse<Map<String, dynamic>>> deleteAccount() async {
    final response = await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.auth}/account',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );

    // Clear local tokens if successful
    if (response.success) {
      await TokenManager.clearTokens();
    }

    return response;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await TokenManager.isLoggedIn();
  }

  // Get stored user ID
  static Future<String?> getUserId() async {
    return await TokenManager.getUserId();
  }
}