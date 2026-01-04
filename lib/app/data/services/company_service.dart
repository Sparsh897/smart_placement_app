import 'dart:developer' as developer;

import '../models/api_response.dart';
import '../models/company_models.dart';
import 'http_service.dart';
import 'token_manager.dart';

class CompanyService {
  static const String _baseUrl = '/api/companies';

  /// Register a new company
  static Future<ApiResponse<CompanyAuthData>> register({
    required String name,
    required String email,
    required String password,
    required String description,
    String? website,
    String? industry,
  }) async {
    try {
      developer.log('Registering company: $email', name: 'CompanyService');
      
      final response = await HttpService.post<CompanyAuthData>(
        '$_baseUrl/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'description': description,
          if (website != null) 'website': website,
          if (industry != null) 'industry': industry,
        },
        fromJson: (json) {
          // Handle case where response might be empty or have different structure
          if (json == null) {
            developer.log('Registration response is null, creating empty auth data', name: 'CompanyService');
            // Return a minimal CompanyAuthData with empty values
            return CompanyAuthData(
              company: Company(
                id: '',
                name: name,
                email: email,
                description: description,
                website: website,
                industry: industry,
                isVerified: false,
                isActive: true,
                totalJobsPosted: 0,
                activeJobs: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              tokens: CompanyTokens(
                accessToken: '',
                tokenType: 'Bearer',
                expiresIn: '7d',
              ),
            );
          }
          
          // Check if data exists in the expected structure
          if (json['data'] != null) {
            return CompanyAuthData.fromJson(json['data']);
          } else if (json['company'] != null && json['tokens'] != null) {
            // Alternative structure where company and tokens are at root level
            return CompanyAuthData.fromJson(json);
          } else {
            developer.log('Unexpected response structure: $json', name: 'CompanyService');
            // Return a minimal CompanyAuthData with empty values
            return CompanyAuthData(
              company: Company(
                id: '',
                name: name,
                email: email,
                description: description,
                website: website,
                industry: industry,
                isVerified: false,
                isActive: true,
                totalJobsPosted: 0,
                activeJobs: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              tokens: CompanyTokens(
                accessToken: '',
                tokenType: 'Bearer',
                expiresIn: '7d',
              ),
            );
          }
        },
        requiresAuth: false,
      );

      if (response.success) {
        developer.log('Company registration successful', name: 'CompanyService');
      } else {
        developer.log('Company registration failed: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Company registration error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyAuthData>(
        success: false,
        error: ApiError(
          code: 'REGISTRATION_ERROR',
          message: 'Failed to register company: $e',
        ),
      );
    }
  }

  /// Login company
  static Future<ApiResponse<CompanyAuthData>> login({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('Company login attempt: $email', name: 'CompanyService');
      
      final response = await HttpService.post<CompanyAuthData>(
        '$_baseUrl/login',
        body: {
          'email': email,
          'password': password,
        },
        fromJson: (json) => CompanyAuthData.fromJson(json),
        requiresAuth: false,
      );

      if (response.success) {
        developer.log('Company login successful', name: 'CompanyService');
        
        // Save company tokens with user type
        if (response.data != null) {
          await TokenManager.saveTokens(
            accessToken: response.data!.tokens.accessToken,
            userId: response.data!.company.id,
            userType: 'company',
          );
        }
      } else {
        developer.log('Company login failed: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Company login error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyAuthData>(
        success: false,
        error: ApiError(
          code: 'LOGIN_ERROR',
          message: 'Failed to login: $e',
        ),
      );
    }
  }

  /// Get company profile
  static Future<ApiResponse<Company>> getProfile() async {
    try {
      developer.log('Fetching company profile', name: 'CompanyService');
      
      final response = await HttpService.get<Company>(
        '$_baseUrl/me',
        fromJson: (json) => Company.fromJson(json['company']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Company profile fetched successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to fetch company profile: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
        
        // Handle UNAUTHORIZED errors for company context without auto-redirect
        if (response.error?.code == 'UNAUTHORIZED') {
          HttpService.handleApiError(response.error!, autoRedirect: false);
        } else {
          HttpService.handleApiError(response.error!);
        }
      }

      return response;
    } catch (e) {
      developer.log('Company profile fetch error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<Company>(
        success: false,
        error: ApiError(
          code: 'PROFILE_ERROR',
          message: 'Failed to fetch profile: $e',
        ),
      );
    }
  }

  /// Update company profile
  static Future<ApiResponse<Company>> updateProfile({
    String? name,
    String? description,
    String? website,
    String? logo,
    String? industry,
    String? size,
    int? founded,
    ContactInfo? contactInfo,
    HrContact? hrContact,
  }) async {
    try {
      developer.log('Updating company profile', name: 'CompanyService');
      
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (website != null) body['website'] = website;
      if (logo != null) body['logo'] = logo;
      if (industry != null) body['industry'] = industry;
      if (size != null) body['size'] = size;
      if (founded != null) body['founded'] = founded;
      if (contactInfo != null) body['contactInfo'] = contactInfo.toJson();
      if (hrContact != null) body['hrContact'] = hrContact.toJson();

      final response = await HttpService.put<Company>(
        '$_baseUrl/profile',
        body: body,
        fromJson: (json) => Company.fromJson(json['company']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Company profile updated successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to update company profile: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Company profile update error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<Company>(
        success: false,
        error: ApiError(
          code: 'UPDATE_ERROR',
          message: 'Failed to update profile: $e',
        ),
      );
    }
  }

  /// Get company dashboard
  static Future<ApiResponse<CompanyDashboard>> getDashboard() async {
    try {
      developer.log('Fetching company dashboard', name: 'CompanyService');
      
      final response = await HttpService.get<CompanyDashboard>(
        '$_baseUrl/dashboard',
        fromJson: (json) => CompanyDashboard.fromJson(json),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Company dashboard fetched successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to fetch company dashboard: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
        
        // Handle UNAUTHORIZED errors for company context without auto-redirect
        if (response.error?.code == 'UNAUTHORIZED') {
          HttpService.handleApiError(response.error!, autoRedirect: false);
        } else {
          HttpService.handleApiError(response.error!);
        }
      }

      return response;
    } catch (e) {
      developer.log('Company dashboard fetch error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyDashboard>(
        success: false,
        error: ApiError(
          code: 'DASHBOARD_ERROR',
          message: 'Failed to fetch dashboard: $e',
        ),
      );
    }
  }

  /// Create job posting
  static Future<ApiResponse<CompanyJob>> createJob({
    required String title,
    required String location,
    required String domain,
    required String salary,
    required String description,
    required String eligibility,
    required String educationLevel,
    required String course,
    required String specialization,
    required List<String> skills,
    String? applyLink,
  }) async {
    try {
      developer.log('Creating job: $title', name: 'CompanyService');
      
      final response = await HttpService.post<CompanyJob>(
        '$_baseUrl/jobs',
        body: {
          'title': title,
          'location': location,
          'domain': domain,
          'salary': salary,
          'description': description,
          'eligibility': eligibility,
          'educationLevel': educationLevel,
          'course': course,
          'specialization': specialization,
          'skills': skills,
          if (applyLink != null) 'applyLink': applyLink,
        },
        fromJson: (json) => CompanyJob.fromJson(json['job']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Job created successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to create job: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
        
        // Handle UNAUTHORIZED errors for company context without auto-redirect
        if (response.error?.code == 'UNAUTHORIZED') {
          HttpService.handleApiError(response.error!, autoRedirect: false);
        } else {
          HttpService.handleApiError(response.error!);
        }
      }

      return response;
    } catch (e) {
      developer.log('Job creation error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyJob>(
        success: false,
        error: ApiError(
          code: 'JOB_CREATE_ERROR',
          message: 'Failed to create job: $e',
        ),
      );
    }
  }

  /// Get company jobs
  static Future<ApiResponse<List<CompanyJob>>> getJobs({
    int page = 1,
    int limit = 20,
    String status = 'all',
  }) async {
    try {
      developer.log('Fetching company jobs - Page: $page, Status: $status', name: 'CompanyService');
      
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'status': status,
      };

      final response = await HttpService.get<List<CompanyJob>>(
        '$_baseUrl/jobs',
        queryParams: queryParams,
        fromJson: (json) => (json['jobs'] as List)
            .map((job) => CompanyJob.fromJson(job))
            .toList(),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Company jobs fetched successfully: ${response.data?.length ?? 0} jobs', 
            name: 'CompanyService');
      } else {
        developer.log('Failed to fetch company jobs: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
        
        // Handle UNAUTHORIZED errors for company context without auto-redirect
        if (response.error?.code == 'UNAUTHORIZED') {
          HttpService.handleApiError(response.error!, autoRedirect: false);
        } else {
          HttpService.handleApiError(response.error!);
        }
      }

      return response;
    } catch (e) {
      developer.log('Company jobs fetch error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<List<CompanyJob>>(
        success: false,
        error: ApiError(
          code: 'JOBS_FETCH_ERROR',
          message: 'Failed to fetch jobs: $e',
        ),
      );
    }
  }

  /// Get specific job
  static Future<ApiResponse<CompanyJob>> getJob(String jobId) async {
    try {
      developer.log('Fetching job: $jobId', name: 'CompanyService');
      
      final response = await HttpService.get<CompanyJob>(
        '$_baseUrl/jobs/$jobId',
        fromJson: (json) => CompanyJob.fromJson(json['job']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Job fetched successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to fetch job: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Job fetch error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyJob>(
        success: false,
        error: ApiError(
          code: 'JOB_FETCH_ERROR',
          message: 'Failed to fetch job: $e',
        ),
      );
    }
  }

  /// Update job
  static Future<ApiResponse<CompanyJob>> updateJob({
    required String jobId,
    String? title,
    String? location,
    String? domain,
    String? salary,
    String? description,
    String? eligibility,
    String? educationLevel,
    String? course,
    String? specialization,
    List<String>? skills,
    String? applyLink,
  }) async {
    try {
      developer.log('Updating job: $jobId', name: 'CompanyService');
      
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (location != null) body['location'] = location;
      if (domain != null) body['domain'] = domain;
      if (salary != null) body['salary'] = salary;
      if (description != null) body['description'] = description;
      if (eligibility != null) body['eligibility'] = eligibility;
      if (educationLevel != null) body['educationLevel'] = educationLevel;
      if (course != null) body['course'] = course;
      if (specialization != null) body['specialization'] = specialization;
      if (skills != null) body['skills'] = skills;
      if (applyLink != null) body['applyLink'] = applyLink;

      final response = await HttpService.put<CompanyJob>(
        '$_baseUrl/jobs/$jobId',
        body: body,
        fromJson: (json) => CompanyJob.fromJson(json['job']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Job updated successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to update job: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Job update error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyJob>(
        success: false,
        error: ApiError(
          code: 'JOB_UPDATE_ERROR',
          message: 'Failed to update job: $e',
        ),
      );
    }
  }

  /// Delete job
  static Future<ApiResponse<void>> deleteJob(String jobId) async {
    try {
      developer.log('Deleting job: $jobId', name: 'CompanyService');
      
      final response = await HttpService.delete<void>(
        '$_baseUrl/jobs/$jobId',
        fromJson: (json) {}, // Return void instead of null
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Job deleted successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to delete job: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Job delete error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<void>(
        success: false,
        error: ApiError(
          code: 'JOB_DELETE_ERROR',
          message: 'Failed to delete job: $e',
        ),
      );
    }
  }

  /// Toggle job status
  static Future<ApiResponse<CompanyJob>> toggleJobStatus(String jobId) async {
    try {
      developer.log('Toggling job status: $jobId', name: 'CompanyService');
      
      final response = await HttpService.patch<CompanyJob>(
        '$_baseUrl/jobs/$jobId/toggle-status',
        fromJson: (json) => CompanyJob.fromJson(json['job']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Job status toggled successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to toggle job status: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Job status toggle error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<CompanyJob>(
        success: false,
        error: ApiError(
          code: 'JOB_STATUS_ERROR',
          message: 'Failed to toggle job status: $e',
        ),
      );
    }
  }

  /// Get applications for company jobs
  static Future<ApiResponse<List<JobApplication>>> getApplications({
    int page = 1,
    int limit = 20,
    String status = 'all',
    String? jobId,
  }) async {
    try {
      developer.log('Fetching applications - Page: $page, Status: $status', name: 'CompanyService');
      
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'status': status,
        if (jobId != null) 'jobId': jobId,
      };

      final response = await HttpService.get<List<JobApplication>>(
        '$_baseUrl/applications',
        queryParams: queryParams,
        fromJson: (json) => (json['applications'] as List)
            .map((app) => JobApplication.fromJson(app))
            .toList(),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Applications fetched successfully: ${response.data?.length ?? 0} applications', 
            name: 'CompanyService');
      } else {
        developer.log('Failed to fetch applications: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
        
        // Handle UNAUTHORIZED errors for company context without auto-redirect
        if (response.error?.code == 'UNAUTHORIZED') {
          HttpService.handleApiError(response.error!, autoRedirect: false);
        } else {
          HttpService.handleApiError(response.error!);
        }
      }

      return response;
    } catch (e) {
      developer.log('Applications fetch error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<List<JobApplication>>(
        success: false,
        error: ApiError(
          code: 'APPLICATIONS_FETCH_ERROR',
          message: 'Failed to fetch applications: $e',
        ),
      );
    }
  }

  /// Update application status
  static Future<ApiResponse<JobApplication>> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? notes,
  }) async {
    try {
      developer.log('Updating application status: $applicationId to $status', name: 'CompanyService');
      
      final response = await HttpService.patch<JobApplication>(
        '$_baseUrl/applications/$applicationId/status',
        body: {
          'status': status,
          if (notes != null) 'notes': notes,
        },
        fromJson: (json) => JobApplication.fromJson(json['application']),
        requiresAuth: true,
      );

      if (response.success) {
        developer.log('Application status updated successfully', name: 'CompanyService');
      } else {
        developer.log('Failed to update application status: ${response.error?.message}', 
            name: 'CompanyService', level: 1000);
      }

      return response;
    } catch (e) {
      developer.log('Application status update error: $e', name: 'CompanyService', level: 1000);
      return ApiResponse<JobApplication>(
        success: false,
        error: ApiError(
          code: 'APPLICATION_UPDATE_ERROR',
          message: 'Failed to update application status: $e',
        ),
      );
    }
  }
}