class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      message: json['message'],
      error: json['error'] != null 
          ? ApiError.fromJson(json['error']) 
          : null,
    );
  }
}

class ApiError {
  final String code;
  final String message;
  final Map<String, List<String>>? details;

  ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An unknown error occurred',
      details: json['details'] != null 
          ? Map<String, List<String>>.from(
              json['details'].map((key, value) => 
                MapEntry(key, List<String>.from(value))
              )
            )
          : null,
    );
  }
}