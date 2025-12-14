class ApiConfig {
  // Production backend URL
  static const String baseUrl = 'https://smart-placement-backend.onrender.com';
  static const String apiVersion = '/api';

  
  // Endpoints
  static const String auth = '$apiVersion/auth';
  static const String users = '$apiVersion/users';
  static const String jobs = '$apiVersion/jobs';
 


  static const String education = '$apiVersion/education';
  
  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 60); // Increased for server wake-up
  static const Duration receiveTimeout = Duration(seconds: 60); // Increased for server wake-up
  
  // Headers
  static Map<String, String> getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}