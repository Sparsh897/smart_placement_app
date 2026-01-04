import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type'; // 'user' or 'company'
  
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? userType, // 'user' or 'company'
  }) async {
    developer.log('Saving tokens for user: $userId, type: $userType', name: 'TokenManager');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
      developer.log('Refresh token saved', name: 'TokenManager');
    }
    
    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
      developer.log('User ID saved: $userId', name: 'TokenManager');
    }
    
    if (userType != null) {
      await prefs.setString(_userTypeKey, userType);
      developer.log('User type saved: $userType', name: 'TokenManager');
    }
    
    developer.log('Access token saved successfully', name: 'TokenManager');
  }
  
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }
  
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }
  
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }
  
  static Future<void> clearTokens() async {
    developer.log('Clearing all tokens', name: 'TokenManager');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userTypeKey);
    developer.log('All tokens cleared', name: 'TokenManager');
  }
  
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final isLoggedIn = token != null && token.isNotEmpty;
    developer.log('Login status check: $isLoggedIn', name: 'TokenManager');
    return isLoggedIn;
  }
  
  static Future<bool> isCompanyLoggedIn() async {
    final token = await getAccessToken();
    final userType = await getUserType();
    final isCompanyLoggedIn = token != null && token.isNotEmpty && userType == 'company';
    developer.log('Company login status check: $isCompanyLoggedIn', name: 'TokenManager');
    return isCompanyLoggedIn;
  }
  
  static Future<bool> isUserLoggedIn() async {
    final token = await getAccessToken();
    final userType = await getUserType();
    final isUserLoggedIn = token != null && token.isNotEmpty && userType == 'user';
    developer.log('User login status check: $isUserLoggedIn', name: 'TokenManager');
    return isUserLoggedIn;
  }
  
  static Future<Map<String, String?>> getAllTokens() async {
    return {
      'accessToken': await getAccessToken(),
      'refreshToken': await getRefreshToken(),
      'userId': await getUserId(),
      'userType': await getUserType(),
    };
  }
}