import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/api_response.dart';
import '../models/job_models.dart';
import 'api_config.dart';
import 'http_service.dart';
import 'token_manager.dart';

class JobService {
  // Get all jobs with filtering and pagination
  static Future<ApiResponse<JobsData>> getJobs({
    String? educationLevel,
    String? course,
    String? specialization,
    String? domain,
    String? location,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    print('💼 [JOB_SERVICE] Fetching jobs - Page: $page, Limit: $limit');
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (educationLevel != null && educationLevel.isNotEmpty) {
      queryParams['educationLevel'] = educationLevel;
      print('💼 [JOB_SERVICE] Filter - Education Level: $educationLevel');
    }
    if (course != null && course.isNotEmpty) {
      queryParams['course'] = course;
      print('💼 [JOB_SERVICE] Filter - Course: $course');
    }
    if (specialization != null && specialization.isNotEmpty) {
      queryParams['specialization'] = specialization;
      print('💼 [JOB_SERVICE] Filter - Specialization: $specialization');
    }
    if (domain != null && domain.isNotEmpty) {
      queryParams['domain'] = domain;
      print('💼 [JOB_SERVICE] Filter - Domain: $domain');
    }
    if (location != null && location.isNotEmpty) {
      queryParams['location'] = location;
      print('💼 [JOB_SERVICE] Filter - Location: $location');
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
      print('💼 [JOB_SERVICE] Filter - Search: "$search"');
    }

    final response = await HttpService.get<JobsData>(
      ApiConfig.jobs,
      queryParams: queryParams,
      fromJson: (json) => JobsData.fromJson(json),
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] Jobs fetched successfully - Count: ${response.data!.jobs.length}, Total Pages: ${response.data!.pagination.totalPages}');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch jobs: ${response.error?.message}');
    }

    return response;
  }

  // Get job by ID
  static Future<ApiResponse<Job>> getJobById(String jobId) async {
    print('💼 [JOB_SERVICE] Fetching job details for ID: $jobId');
    final response = await HttpService.get<Job>(
      '${ApiConfig.jobs}/$jobId',
      fromJson: (json) => Job.fromJson(json),
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] Job details fetched: ${response.data!.title} at ${response.data!.company}');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch job details: ${response.error?.message}');
    }

    return response;
  }

  // Get available domains
  static Future<ApiResponse<List<String>>> getDomains() async {
    print('💼 [JOB_SERVICE] Fetching available domains');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.jobs}/meta/domains',
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] Domains fetched successfully - Count: ${response.data!.length}');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch domains: ${response.error?.message}');
    }

    return response;
  }

  // Get available locations
  static Future<ApiResponse<List<String>>> getLocations() async {
    print('💼 [JOB_SERVICE] Fetching available locations');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.jobs}/meta/locations',
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] Locations fetched successfully - Count: ${response.data!.length}');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch locations: ${response.error?.message}');
    }

    return response;
  }

  // Get available companies
  static Future<ApiResponse<List<String>>> getCompanies() async {
    print('💼 [JOB_SERVICE] Fetching available companies');
    final response = await HttpService.get<List<String>>(
      '${ApiConfig.jobs}/meta/companies',
      fromJson: (json) => List<String>.from(json),
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] Companies fetched successfully - Count: ${response.data!.length}');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch companies: ${response.error?.message}');
    }

    return response;
  }

  // Apply to job with comprehensive data
  static Future<ApiResponse<JobApplication>> applyToJob({
    required String jobId,
    required Map<String, dynamic> contactInfo,
    required Map<String, dynamic> resume,
    List<Map<String, dynamic>>? employerQuestions,
    List<Map<String, dynamic>>? relevantExperience,
    List<Map<String, dynamic>>? supportingDocuments,
    String? coverLetter,
    Map<String, dynamic>? jobAlertPreferences,
  }) async {
    print('💼 [JOB_SERVICE] Applying to job: $jobId');
    
    final body = {
      'jobId': jobId,
      'contactInfo': contactInfo,
      'resume': resume,
    };
    
    if (employerQuestions != null && employerQuestions.isNotEmpty) {
      body['employerQuestions'] = employerQuestions;
    }
    
    if (relevantExperience != null && relevantExperience.isNotEmpty) {
      body['relevantExperience'] = relevantExperience;
    }
    
    if (supportingDocuments != null && supportingDocuments.isNotEmpty) {
      body['supportingDocuments'] = supportingDocuments;
    }
    
    if (coverLetter != null && coverLetter.isNotEmpty) {
      body['coverLetter'] = coverLetter;
    }
    
    if (jobAlertPreferences != null) {
      body['jobAlertPreferences'] = jobAlertPreferences;
    }

    final response = await HttpService.post<JobApplication>(
      '/api/job-applications',
      body: body,
      fromJson: (json) => JobApplication.fromJson(json['application']),
      requiresAuth: true,
    );

    if (response.success) {
      print('💼 [JOB_SERVICE] Job application successful');
    } else {
      print('💼 [JOB_SERVICE] Job application failed: ${response.error?.message}');
    }

    return response;
  }

  // Check if user has applied to a job
  static Future<ApiResponse<bool>> hasAppliedToJob(String jobId) async {
    print('💼 [JOB_SERVICE] Checking application status for job: $jobId');
    
    final response = await HttpService.get<bool>(
      '/api/job-applications/check/$jobId',
      fromJson: (json) => json['hasApplied'] ?? false,
      requiresAuth: true,
    );

    return response;
  }

  // Get applied job IDs
  static Future<ApiResponse<List<String>>> getAppliedJobIds() async {
    print('💼 [JOB_SERVICE] Fetching applied job IDs');
    
    final response = await HttpService.get<List<String>>(
      '/api/job-applications/applied-jobs/ids',
      fromJson: (json) => List<String>.from(json['appliedJobIds'] ?? []),
      requiresAuth: true,
    );

    return response;
  }

  // Withdraw job application
  static Future<ApiResponse<JobApplication>> withdrawApplication(String applicationId) async {
    print('💼 [JOB_SERVICE] Withdrawing application: $applicationId');
    
    final response = await HttpService.put<JobApplication>(
      '/api/job-applications/$applicationId/withdraw',
      fromJson: (json) => JobApplication.fromJson(json['application']),
      requiresAuth: true,
    );

    return response;
  }

  // Get user applications with pagination and filtering
  static Future<ApiResponse<JobApplicationList>> getUserApplications({
    int page = 1,
    int limit = 20,
    String? status,
    String sortBy = 'appliedAt',
    String sortOrder = 'desc',
  }) async {
    print('💼 [JOB_SERVICE] Fetching user applications');
    
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
    
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    
    final response = await HttpService.get<JobApplicationList>(
      '/api/job-applications',
      queryParams: queryParams,
      fromJson: (json) => JobApplicationList.fromJson(json),
      requiresAuth: true,
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] User applications fetched successfully - Count: ${response.data!.applications.length}');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch user applications: ${response.error?.message}');
      // If endpoint not found, return empty list for now
      if (response.error?.code == 'NOT_FOUND') {
        print('💼 [JOB_SERVICE] Applications endpoint not implemented yet, returning empty list');
        return ApiResponse<JobApplicationList>(
          success: true,
          data: JobApplicationList(
            applications: [],
            pagination: Pagination(
              currentPage: 1,
              totalPages: 1,
              totalItems: 0,
              perPage: limit,
              hasNext: false,
              hasPrev: false,
            ),
            summary: ApplicationSummary(
              total: 0,
              statusCounts: {},
            ),
          ),
          message: 'Job applications feature not yet implemented on backend',
        );
      }
    }

    return response;
  }

  // Get application details
  static Future<ApiResponse<JobApplication>> getApplicationById(
    String applicationId,
  ) async {
    print('💼 [JOB_SERVICE] Fetching application details for ID: $applicationId');
    final response = await HttpService.get<JobApplication>(
      '/api/applications/$applicationId',
      fromJson: (json) => JobApplication.fromJson(json),
      requiresAuth: true,
    );

    if (response.success && response.data != null) {
      print('💼 [JOB_SERVICE] Application details fetched successfully');
    } else {
      print('💼 [JOB_SERVICE] Failed to fetch application details: ${response.error?.message}');
    }

    return response;
  }

  // Save job
  static Future<ApiResponse<Map<String, dynamic>>> saveJob(String jobId) async {
    print('💼 [JOB_SERVICE] Saving job: $jobId');
    final response = await HttpService.post<Map<String, dynamic>>(
      '${ApiConfig.jobs}/$jobId/save',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );

    if (response.success) {
      print('💼 [JOB_SERVICE] Job saved successfully: $jobId');
    } else {
      print('💼 [JOB_SERVICE] Failed to save job: ${response.error?.message}');
    }

    return response;
  }

  // Unsave job
  static Future<ApiResponse<Map<String, dynamic>>> unsaveJob(String jobId) async {
    print('💼 [JOB_SERVICE] Unsaving job: $jobId');
    final response = await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.jobs}/$jobId/save',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );

    if (response.success) {
      print('💼 [JOB_SERVICE] Job unsaved successfully: $jobId');
    } else {
      print('💼 [JOB_SERVICE] Failed to unsave job: ${response.error?.message}');
    }

    return response;
  }

  // Get saved jobs - Direct HTTP call to bypass parsing issues
  static Future<ApiResponse<List<SavedJob>>> getSavedJobs() async {
    print('💼 [JOB_SERVICE] Fetching saved jobs with direct HTTP call');
    
    try {
      // Get token for authentication
      final token = await TokenManager.getAccessToken();
      if (token == null) {
        print('💼 [JOB_SERVICE] No auth token available');
        return ApiResponse<List<SavedJob>>(
          success: false,
          error: ApiError(
            code: 'UNAUTHORIZED',
            message: 'Authentication required',
          ),
        );
      }

      // Make direct HTTP call
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.users}/saved-jobs');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('💼 [JOB_SERVICE] Making direct HTTP GET to: $url');
      final httpResponse = await http.get(url, headers: headers);
      
      print('💼 [JOB_SERVICE] Direct HTTP Response Status: ${httpResponse.statusCode}');
      print('💼 [JOB_SERVICE] Direct HTTP Response Body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(httpResponse.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          
          if (data.containsKey('savedJobs')) {
            final savedJobsList = data['savedJobs'] as List;
            print('💼 [JOB_SERVICE] Found ${savedJobsList.length} saved jobs');
            
            final savedJobs = <SavedJob>[];
            for (final item in savedJobsList) {
              try {
                final savedJob = SavedJob.fromJson(item as Map<String, dynamic>);
                savedJobs.add(savedJob);
                print('💼 [JOB_SERVICE] Successfully parsed saved job: ${savedJob.job?.title ?? "Unknown"}');
              } catch (e) {
                print('💼 [JOB_SERVICE] Error parsing individual saved job: $e');
              }
            }
            
            print('💼 [JOB_SERVICE] Successfully parsed ${savedJobs.length} saved jobs');
            return ApiResponse<List<SavedJob>>(
              success: true,
              data: savedJobs,
              message: 'Saved jobs loaded successfully',
            );
          } else {
            print('💼 [JOB_SERVICE] No savedJobs key in response data');
            return ApiResponse<List<SavedJob>>(
              success: true,
              data: [],
              message: 'No saved jobs found',
            );
          }
        } else {
          print('💼 [JOB_SERVICE] API response indicates failure');
          return ApiResponse<List<SavedJob>>(
            success: false,
            error: ApiError(
              code: 'API_ERROR',
              message: jsonResponse['message'] ?? 'Unknown API error',
            ),
          );
        }
      } else {
        print('💼 [JOB_SERVICE] HTTP error: ${httpResponse.statusCode}');
        return ApiResponse<List<SavedJob>>(
          success: false,
          error: ApiError(
            code: 'HTTP_ERROR',
            message: 'HTTP ${httpResponse.statusCode}: ${httpResponse.reasonPhrase}',
          ),
        );
      }
    } catch (e) {
      print('💼 [JOB_SERVICE] Exception in getSavedJobs: $e');
      return ApiResponse<List<SavedJob>>(
        success: false,
        error: ApiError(
          code: 'EXCEPTION',
          message: 'Failed to fetch saved jobs: $e',
        ),
      );
    }
  }
  

  // Admin: Create job
  static Future<ApiResponse<Job>> createJob(Job job) async {
    return await HttpService.post<Job>(
      ApiConfig.jobs,
      body: job.toJson(),
      fromJson: (json) => Job.fromJson(json),
      requiresAuth: true,
    );
  }

  // Admin: Update job
  static Future<ApiResponse<Job>> updateJob(String jobId, Job job) async {
    return await HttpService.put<Job>(
      '${ApiConfig.jobs}/$jobId',
      body: job.toJson(),
      fromJson: (json) => Job.fromJson(json),
      requiresAuth: true,
    );
  }

  // Admin: Delete job
  static Future<ApiResponse<Map<String, dynamic>>> deleteJob(String jobId) async {
    return await HttpService.delete<Map<String, dynamic>>(
      '${ApiConfig.jobs}/$jobId',
      fromJson: (json) => json as Map<String, dynamic>,
      requiresAuth: true,
    );
  }
  
}