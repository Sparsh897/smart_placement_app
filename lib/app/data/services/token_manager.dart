import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
  }) async {
    print('🔑 [TOKEN_MANAGER] Saving tokens for user: $userId');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
      print('🔑 [TOKEN_MANAGER] Refresh token saved');
    }
    
    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
      print('🔑 [TOKEN_MANAGER] User ID saved: $userId');
    }
    
    print('🔑 [TOKEN_MANAGER] Access token saved successfully');
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
  
  static Future<void> clearTokens() async {
    print('🔑 [TOKEN_MANAGER] Clearing all tokens');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    print('🔑 [TOKEN_MANAGER] All tokens cleared');
  }
  
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final isLoggedIn = token != null && token.isNotEmpty;
    print('🔑 [TOKEN_MANAGER] Login status check: $isLoggedIn');
    return isLoggedIn;
  }
  
  static Future<Map<String, String?>> getAllTokens() async {
    return {
      'accessToken': await getAccessToken(),
      'refreshToken': await getRefreshToken(),
      'userId': await getUserId(),
    };
  }
}