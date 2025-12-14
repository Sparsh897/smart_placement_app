import '../models/api_response.dart';
import '../models/user_models.dart';
import 'api_config.dart';
import 'http_service.dart';

class UserService {
  // Get user profile
  static Future<ApiResponse<User>> getProfile() async {
    print('👤 [USER_SERVICE] Fetching user profile');
    final response = await HttpService.get<User>(
      '${ApiConfig.users}/profile',
      fromJson: (json) {
        print('👤 [USER_SERVICE] Parsing user data: ${json.toString()}');
        return User.fromJson(json['user']); // Extract user from nested structure
      },
      requiresAuth: true,
    );

    if (response.success && response.data != null) {
      print('👤 [USER_SERVICE] Profile fetched: ${response.data!.name} (${response.data!.email})');
    } else {
      print('👤 [USER_SERVICE] Failed to fetch profile: ${response.error?.message}');
    }

    return response;
  }

  // Update user profile
  static Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    Location? location,
    Profile? profile,
    Preferences? preferences,
  }) async {
    print('👤 [USER_SERVICE] Updating profile - Name: $name, Phone: $phone');
    if (profile != null) {
      print('👤 [USER_SERVICE] Profile update - Education: ${profile.educationLevel}, Course: ${profile.course}, Specialization: ${profile.specialization}');
    }
    if (preferences != null) {
      print('👤 [USER_SERVICE] Preferences update - Job Types: ${preferences.jobTypes}, Min Salary: ${preferences.minimumSalary}');
    }

    final body = <String, dynamic>{};
    
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (location != null) body['location'] = location.toJson();
    if (profile != null) body['profile'] = profile.toJson();
    if (preferences != null) body['preferences'] = preferences.toJson();

    final response = await HttpService.put<User>(
      '${ApiConfig.users}/profile',
      body: body,
      fromJson: (json) => User.fromJson(json),
      requiresAuth: true,
    );

    if (response.success && response.data != null) {
      print('👤 [USER_SERVICE] Profile updated successfully');
    } else {
      print('👤 [USER_SERVICE] Failed to update profile: ${response.error?.message}');
    }

    return response;
  }

  // Work Experience Management
  static Future<ApiResponse<WorkExperience>> addWorkExperience(
    WorkExperience workExperience,
  ) async {
    return await HttpService.post<WorkExperience>(
      '${ApiConfig.users}/work-experience',
      body: workExperience.toJson(),
      fromJson: (json) => WorkExperience.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<WorkExperience>> updateWorkExperience(
    String id,
    WorkExperience workExperience,
  ) async {
    return await HttpService.put<WorkExperience>(
      '${ApiConfig.users}/work-experience/$id',
      body: workExperience.toJson(),
      fromJson: (json) => WorkExperience.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> deleteWorkExperience(
    String id,
  ) async {
    return await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.users}/work-experience/$id',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );
  }

  // Education Management
  static Future<ApiResponse<Education>> addEducation(
    Education education,
  ) async {
    return await HttpService.post<Education>(
      '${ApiConfig.users}/education',
      body: education.toJson(),
      fromJson: (json) => Education.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Education>> updateEducation(
    String id,
    Education education,
  ) async {
    return await HttpService.put<Education>(
      '${ApiConfig.users}/education/$id',
      body: education.toJson(),
      fromJson: (json) => Education.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> deleteEducation(
    String id,
  ) async {
    return await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.users}/education/$id',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );
  }

  // Skills Management
  static Future<ApiResponse<List<Skill>>> addSkills(
    List<Skill> skills,
  ) async {
    return await HttpService.post<List<Skill>>(
      '${ApiConfig.users}/skills',
      body: {
        'skills': skills.map((skill) => skill.toJson()).toList(),
      },
      fromJson: (json) => (json as List).map((e) => Skill.fromJson(e)).toList(),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Skill>> updateSkill(
    String id,
    Skill skill,
  ) async {
    return await HttpService.put<Skill>(
      '${ApiConfig.users}/skills/$id',
      body: skill.toJson(),
      fromJson: (json) => Skill.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> deleteSkill(
    String id,
  ) async {
    return await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.users}/skills/$id',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );
  }

  // Certifications Management
  static Future<ApiResponse<Certification>> addCertification(
    Certification certification,
  ) async {
    return await HttpService.post<Certification>(
      '${ApiConfig.users}/certifications',
      body: certification.toJson(),
      fromJson: (json) => Certification.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Certification>> updateCertification(
    String id,
    Certification certification,
  ) async {
    return await HttpService.put<Certification>(
      '${ApiConfig.users}/certifications/$id',
      body: certification.toJson(),
      fromJson: (json) => Certification.fromJson(json),
      requiresAuth: true,
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> deleteCertification(
    String id,
  ) async {
    return await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.users}/certifications/$id',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );
  }

  // Educational Preferences Management
  static Future<ApiResponse<User>> updateEducationalPreferences({
    required String educationLevel,
    required String course,
    required String specialization,
  }) async {
    print('👤 [USER_SERVICE] Updating educational preferences - Level: $educationLevel, Course: $course, Specialization: $specialization');
    
    final body = {
      'profile': {
        'educationLevel': educationLevel,
        'course': course,
        'specialization': specialization,
      }
    };

    final response = await HttpService.put<User>(
      '${ApiConfig.users}/profile',
      body: body,
      fromJson: (json) => User.fromJson(json['user']),
      requiresAuth: true,
    );

    if (response.success && response.data != null) {
      print('👤 [USER_SERVICE] Educational preferences updated successfully');
    } else {
      print('👤 [USER_SERVICE] Failed to update educational preferences: ${response.error?.message}');
    }

    return response;
  }

  // Check if user has educational preferences set
  static bool hasEducationalPreferences(User? user) {
    if (user?.profile == null) return false;
    
    final profile = user!.profile!;
    return profile.educationLevel != null && 
           profile.educationLevel!.isNotEmpty &&
           profile.course != null && 
           profile.course!.isNotEmpty &&
           profile.specialization != null && 
           profile.specialization!.isNotEmpty;
  }
}