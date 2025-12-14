import '../models/api_response.dart';
import '../models/education_models.dart';
import 'api_config.dart';
import 'http_service.dart';

class EducationService {
  // Get education levels
  static Future<ApiResponse<List<String>>> getEducationLevels() async {
    print('🎓 [EDUCATION_SERVICE] Fetching education levels');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.education}/levels',
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('🎓 [EDUCATION_SERVICE] Education levels fetched: ${response.data!.join(', ')}');
    } else {
      print('🎓 [EDUCATION_SERVICE] Failed to fetch education levels: ${response.error?.message}');
    }

    return response;
  }

  // Get courses by education level
  static Future<ApiResponse<List<String>>> getCoursesByLevel(
    String educationLevel,
  ) async {
    print('🎓 [EDUCATION_SERVICE] Fetching courses for level: $educationLevel');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.education}/courses',
      queryParams: {'level': educationLevel},
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('🎓 [EDUCATION_SERVICE] Courses fetched for $educationLevel: ${response.data!.join(', ')}');
    } else {
      print('🎓 [EDUCATION_SERVICE] Failed to fetch courses: ${response.error?.message}');
    }

    return response;
  }

  // Get specializations by course
  static Future<ApiResponse<List<String>>> getSpecializationsByCourse(
    String course,
  ) async {
    print('🎓 [EDUCATION_SERVICE] Fetching specializations for course: $course');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.education}/specializations',
      queryParams: {'course': course},
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('🎓 [EDUCATION_SERVICE] Specializations fetched for $course: ${response.data!.join(', ')}');
    } else {
      print('🎓 [EDUCATION_SERVICE] Failed to fetch specializations: ${response.error?.message}');
    }

    return response;
  }

  // Get domains by specialization
  static Future<ApiResponse<List<String>>> getDomainsBySpecialization(
    String specialization,
  ) async {
    print('🎓 [EDUCATION_SERVICE] Fetching domains for specialization: $specialization');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.education}/domains',
      queryParams: {'specialization': specialization},
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('🎓 [EDUCATION_SERVICE] Domains fetched for $specialization: ${response.data!.join(', ')}');
    } else {
      print('🎓 [EDUCATION_SERVICE] Failed to fetch domains: ${response.error?.message}');
    }

    return response;
  }

  // Get complete education hierarchy
  static Future<ApiResponse<EducationHierarchy>> getEducationHierarchy() async {
    return await HttpService.get<EducationHierarchy>(
      '${ApiConfig.education}/all',
      fromJson: (json) => EducationHierarchy.fromJson(json),
    );
  }
}