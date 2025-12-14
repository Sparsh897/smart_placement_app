import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../models/api_response.dart';
import 'api_config.dart';
import 'token_manager.dart';

class HttpService {
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final finalUri = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;

      String? token;
      if (requiresAuth) {
        token = await TokenManager.getAccessToken();

        if (token == null) {
          print('❌ [API] GET $endpoint - No auth token available');
          return ApiResponse<T>(
            success: false,
            error: ApiError(
              code: 'UNAUTHORIZED',
              message: 'Authentication required',
            ),
          );
        }
      }
debugPrint("JWT TOKEN${token}");
      final headers = ApiConfig.getHeaders(token: token);
      
      // Log request details
      print('🚀 [API] GET Request:');
      print('   URL: $finalUri');
      print('   Headers: ${_sanitizeHeaders(headers)}');
      if (queryParams != null && queryParams.isNotEmpty) {
        print('   Query Params: $queryParams');
      }

      final response = await http.get(
        finalUri,
        headers: headers,
      ).timeout(ApiConfig.receiveTimeout);

      // Log response details
      print('📥 [API] GET Response:');
      print('   Status: ${response.statusCode}');
      print('   Body: ${_truncateBody(response.body)}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('💥 [API] GET Error for $endpoint: $e');
      return _handleError<T>(e);
    }
  }

  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await TokenManager.getAccessToken();
        if (token == null) {
          print('❌ [API] POST $endpoint - No auth token available');
          return ApiResponse<T>(
            success: false,
            error: ApiError(
              code: 'UNAUTHORIZED',
              message: 'Authentication required',
            ),
          );
        }
      }

      final headers = ApiConfig.getHeaders(token: token);
      final requestBody = body != null ? jsonEncode(body) : null;
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      // Log request details
      print('🚀 [API] POST Request:');
      print('   URL: $url');
      print('   Headers: ${_sanitizeHeaders(headers)}');
      if (requestBody != null) {
        print('   Body: ${_sanitizeBody(requestBody)}');
      }

      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      ).timeout(ApiConfig.receiveTimeout);

      // Log response details
      print('📥 [API] POST Response:');
      print('   Status: ${response.statusCode}');
      print('   Body: ${_truncateBody(response.body)}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('💥 [API] POST Error for $endpoint: $e');
      return _handleError<T>(e);
    }
  }

  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await TokenManager.getAccessToken();
        if (token == null) {
          print('❌ [API] PUT $endpoint - No auth token available');
          return ApiResponse<T>(
            success: false,
            error: ApiError(
              code: 'UNAUTHORIZED',
              message: 'Authentication required',
            ),
          );
        }
      }

      final headers = ApiConfig.getHeaders(token: token);
      final requestBody = body != null ? jsonEncode(body) : null;
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      // Log request details
      print('🚀 [API] PUT Request:');
      print('   URL: $url');
      print('   Headers: ${_sanitizeHeaders(headers)}');
      if (requestBody != null) {
        print('   Body: ${_sanitizeBody(requestBody)}');
      }

      final response = await http.put(
        url,
        headers: headers,
        body: requestBody,
      ).timeout(ApiConfig.receiveTimeout);

      // Log response details
      print('📥 [API] PUT Response:');
      print('   Status: ${response.statusCode}');
      print('   Body: ${_truncateBody(response.body)}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('💥 [API] PUT Error for $endpoint: $e');
      return _handleError<T>(e);
    }
  }

  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
    bool requiresAuth = false,
  }) async {
    try {
      String? token;
      if (requiresAuth) {
        token = await TokenManager.getAccessToken();
        if (token == null) {
          print('❌ [API] DELETE $endpoint - No auth token available');
          return ApiResponse<T>(
            success: false,
            error: ApiError(
              code: 'UNAUTHORIZED',
              message: 'Authentication required',
            ),
          );
        }
      }

      final headers = ApiConfig.getHeaders(token: token);
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      // Log request details
      print('🚀 [API] DELETE Request:');
      print('   URL: $url');
      print('   Headers: ${_sanitizeHeaders(headers)}');

      final response = await http.delete(
        url,
        headers: headers,
      ).timeout(ApiConfig.receiveTimeout);

      // Log response details
      print('📥 [API] DELETE Response:');
      print('   Status: ${response.statusCode}');
      print('   Body: ${_truncateBody(response.body)}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('💥 [API] DELETE Error for $endpoint: $e');
      return _handleError<T>(e);
    }
  }

  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>.fromJson(jsonData, fromJson);
      } else {
        // Handle error responses
        return ApiResponse<T>(
          success: false,
          message: jsonData['message'] ?? 'Request failed',
          error: jsonData['error'] != null 
              ? ApiError.fromJson(jsonData['error'])
              : ApiError(
                  code: 'HTTP_ERROR',
                  message: jsonData['message'] ?? 'Request failed with status ${response.statusCode}',
                ),
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        error: ApiError(
          code: 'PARSE_ERROR',
          message: 'Failed to parse response: $e',
        ),
      );
    }
  }

  static ApiResponse<T> _handleError<T>(dynamic error) {
    String message = 'An unexpected error occurred';
    String code = 'UNKNOWN_ERROR';

    if (error is SocketException) {
      message = 'No internet connection';
      code = 'NETWORK_ERROR';
    } else if (error is HttpException) {
      message = 'HTTP error: ${error.message}';
      code = 'HTTP_ERROR';
    } else if (error is FormatException) {
      message = 'Invalid response format';
      code = 'FORMAT_ERROR';
    } else {
      message = error.toString();
    }

    return ApiResponse<T>(
      success: false,
      error: ApiError(code: code, message: message),
    );
  }

  static void handleApiError(ApiError error) {
    // Check if context is available before showing snackbars
    if (Get.context == null) return;
    
    switch (error.code) {
      case 'GOOGLE_USER_EXISTS':
        Get.snackbar(
          'Account Exists',
          'This email is registered with Google. Please use Google Sign-In.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
      case 'EMAIL_USER_EXISTS':
        Get.snackbar(
          'Account Exists',
          'This email is registered with email/password. Please use email login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
      case 'GOOGLE_USER':
        Get.snackbar(
          'Google Account',
          'This account uses Google Sign-In. Please use Google login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
      case 'VALIDATION_ERROR':
        String validationMessage = 'Please check your input';
        if (error.details != null) {
          final errors = error.details!.values.expand((e) => e).toList();
          validationMessage = errors.isNotEmpty ? errors.first : validationMessage;
        }
        Get.snackbar(
          'Validation Error',
          validationMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
      case 'UNAUTHORIZED':
        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        // Clear tokens and redirect to login
        TokenManager.clearTokens();
        Get.offAllNamed('/auth');
        break;
      case 'NETWORK_ERROR':
        Get.snackbar(
          'Network Error',
          'Please check your internet connection',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
      default:
        Get.snackbar(
          'Error',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
    }
  }

  // Helper methods for logging
  static Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    final sanitized = Map<String, String>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      final token = sanitized['Authorization']!;
      if (token.startsWith('Bearer ')) {
        final tokenValue = token.substring(7);
        sanitized['Authorization'] = 'Bearer ${tokenValue.substring(0, 10)}...';
      }
    }
    return sanitized;
  }

  static String _sanitizeBody(String body) {
    try {
      final Map<String, dynamic> jsonBody = jsonDecode(body);
      final sanitized = Map<String, dynamic>.from(jsonBody);
      
      // Hide sensitive fields
      if (sanitized.containsKey('password')) {
        sanitized['password'] = '***';
      }
      if (sanitized.containsKey('googleToken')) {
        final token = sanitized['googleToken'].toString();
        sanitized['googleToken'] = '${token.substring(0, 10)}...';
      }
      
      return jsonEncode(sanitized);
    } catch (e) {
      // If not JSON, just truncate
      return _truncateBody(body);
    }
  }

  static String _truncateBody(String body) {
    if (body.length > 500) {
      return '${body.substring(0, 500)}... [truncated]';
    }
    return body;
  }
}