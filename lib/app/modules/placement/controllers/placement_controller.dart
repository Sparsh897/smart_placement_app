import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/job_models.dart';
import '../../../data/services/job_service.dart';
import '../../../data/services/education_service.dart';
import '../../../data/services/http_service.dart';
import '../../onboarding/controllers/onboarding_controller.dart';

class PlacementController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final jobs = <Job>[].obs;
  final filteredJobs = <Job>[].obs;
  // REMOVED: Saved jobs functionality
  // final savedJobs = <SavedJob>[].obs;
  final currentJob = Rxn<Job>();
  
  // Education data
  final educationLevels = <String>[].obs;
  final courses = <String>[].obs;
  final specializations = <String>[].obs;
  final domains = <String>[].obs;
  final availableDomains = <String>[].obs;
  final availableLocations = <String>[].obs;
  final availableCompanies = <String>[].obs;
  
  // Selected values
  final selectedEducationLevel = ''.obs;
  final selectedCourse = ''.obs;
  final selectedSpecialization = ''.obs;
  final selectedDomain = ''.obs;
  final selectedLocation = ''.obs;
  final searchQuery = ''.obs;
  
  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasMoreJobs = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    print('📋 [JOBS] Loading initial data');
    try {
      await Future.wait([
        loadEducationLevels(),
        loadJobs(),
        loadMetaData(),
        loadAppliedJobIds(), // Load applied job IDs for current user
      ]);
      print('📋 [JOBS] Initial data loaded successfully');
    } catch (e) {
      print('📋 [JOBS] Error loading initial data: $e');
      // Show user-friendly message for initial load failures
      if (e.toString().contains('TimeoutException')) {
        Get.snackbar(
          'Server Starting',
          'The backend server is starting up. This may take a minute on first load.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 8),
        );
      }
    }
  }

  // Education Data Methods
  Future<void> loadEducationLevels() async {
    try {
      final response = await EducationService.getEducationLevels();
      if (response.success && response.data != null) {
        educationLevels.value = response.data!;
      }
    } catch (e) {
      print('Error loading education levels: $e');
    }
  }

  Future<void> loadCoursesByLevel(String educationLevel) async {
    if (educationLevel.isEmpty) {
      courses.clear();
      return;
    }
    
    try {
      final response = await EducationService.getCoursesByLevel(educationLevel);
      if (response.success && response.data != null) {
        courses.value = response.data!;
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
  }

  Future<void> loadSpecializationsByCourse(String course) async {
    if (course.isEmpty) {
      specializations.clear();
      return;
    }
    
    try {
      final response = await EducationService.getSpecializationsByCourse(course);
      if (response.success && response.data != null) {
        specializations.value = response.data!;
      }
    } catch (e) {
      print('Error loading specializations: $e');
    }
  }

  Future<void> loadDomainsBySpecialization(String specialization) async {
    if (specialization.isEmpty) {
      domains.clear();
      return;
    }
    
    try {
      final response = await EducationService.getDomainsBySpecialization(specialization);
      if (response.success && response.data != null) {
        domains.value = response.data!;
      }
    } catch (e) {
      print('Error loading domains: $e');
    }
  }

  // Meta Data Methods
  Future<void> loadMetaData() async {
    try {
      await Future.wait([
        _loadAvailableDomains(),
        _loadAvailableLocations(),
        _loadAvailableCompanies(),
      ]);
    } catch (e) {
      print('Error loading meta data: $e');
    }
  }

  Future<void> _loadAvailableDomains() async {
    try {
      final response = await JobService.getDomains();
      if (response.success && response.data != null) {
        availableDomains.value = response.data!;
      }
    } catch (e) {
      print('📋 [JOBS] Error loading available domains: $e');
      // Silently fail for metadata - not critical for app function
    }
  }

  Future<void> _loadAvailableLocations() async {
    try {
      final response = await JobService.getLocations();
      if (response.success && response.data != null) {
        availableLocations.value = response.data!;
      }
    } catch (e) {
      print('📋 [JOBS] Error loading available locations: $e');
      // Silently fail for metadata - not critical for app function
    }
  }

  Future<void> _loadAvailableCompanies() async {
    try {
      final response = await JobService.getCompanies();
      if (response.success && response.data != null) {
        availableCompanies.value = response.data!;
      }
    } catch (e) {
      print('📋 [JOBS] Error loading available companies: $e');
      // Silently fail for metadata - not critical for app function
    }
  }

  // Job Methods
  Future<void> loadJobs({bool refresh = false}) async {
    if (isLoading.value && !refresh) return;
    
    if (refresh) {
      currentPage.value = 1;
      jobs.clear();
    }
    
    // Get saved onboarding data for API calls
    final onboardingController = Get.find<OnboardingController>();
    final savedEducationLevel = onboardingController.savedEducationLevel;
    final savedCourse = onboardingController.savedCourse;
    final savedSpecialization = onboardingController.savedSpecialization;
    
    print('📋 [JOBS] Loading jobs (page: ${currentPage.value}, refresh: $refresh)');
    print('📋 [JOBS] Filters - Education: ${selectedEducationLevel.value}, Course: ${selectedCourse.value}, Specialization: ${selectedSpecialization.value}');
    print('📋 [JOBS] Saved onboarding - Education: $savedEducationLevel, Course: $savedCourse, Specialization: $savedSpecialization');
    
    isLoading.value = true;
    try {
      final response = await JobService.getJobs(
        educationLevel: selectedEducationLevel.value.isNotEmpty 
            ? selectedEducationLevel.value 
            : savedEducationLevel,
        course: selectedCourse.value.isNotEmpty 
            ? selectedCourse.value 
            : savedCourse,
        specialization: selectedSpecialization.value.isNotEmpty 
            ? selectedSpecialization.value 
            : savedSpecialization,
        domain: selectedDomain.value.isNotEmpty 
            ? selectedDomain.value 
            : null,
        location: selectedLocation.value.isNotEmpty 
            ? selectedLocation.value 
            : null,
        search: searchQuery.value.isNotEmpty 
            ? searchQuery.value 
            : null,
        page: currentPage.value,
        limit: 20,
      );

      if (response.success && response.data != null) {
        if (refresh) {
          jobs.value = response.data!.jobs;
        } else {
          jobs.addAll(response.data!.jobs);
        }
        
        totalPages.value = response.data!.pagination.totalPages;
        hasMoreJobs.value = response.data!.pagination.hasNext;
        
        _applyFilters();
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
      }
    } catch (e) {
      print('📋 [JOBS] Error loading jobs: $e');
      
      // Handle different types of errors
      if (e.toString().contains('TimeoutException')) {
        Get.snackbar(
          'Server Starting',
          'Backend server is waking up. Please wait a moment and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else if (e.toString().contains('SocketException')) {
        Get.snackbar(
          'Network Error',
          'Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load jobs. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreJobs() async {
    if (!hasMoreJobs.value || isLoading.value) return;
    
    currentPage.value++;
    await loadJobs();
  }

  Future<void> refreshJobs() async {
    await loadJobs(refresh: true);
  }

  // Retry mechanism for server wake-up scenarios
  Future<void> retryLoadJobs({int maxRetries = 2}) async {
    print('📋 [JOBS] Retrying job load (max retries: $maxRetries)');
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('📋 [JOBS] Retry attempt $attempt of $maxRetries');
        await loadJobs(refresh: true);
        print('📋 [JOBS] Retry successful on attempt $attempt');
        return; // Success, exit retry loop
      } catch (e) {
        print('📋 [JOBS] Retry attempt $attempt failed: $e');
        
        if (attempt < maxRetries) {
          // Wait before next retry (exponential backoff)
          final waitTime = Duration(seconds: attempt * 10);
          print('📋 [JOBS] Waiting ${waitTime.inSeconds} seconds before next retry');
          
          Get.snackbar(
            'Retrying...',
            'Attempt $attempt failed. Retrying in ${waitTime.inSeconds} seconds...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: waitTime,
          );
          
          await Future.delayed(waitTime);
        } else {
          // Final attempt failed
          print('📋 [JOBS] All retry attempts failed');
          Get.snackbar(
            'Server Unavailable',
            'Unable to connect to server. Please try again later.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
      }
    }
  }

  Future<Job?> getJobById(String jobId) async {
    try {
      final response = await JobService.getJobById(jobId);
      if (response.success && response.data != null) {
        currentJob.value = response.data;
        return response.data;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
      }
    } catch (e) {
      print('Error loading job details: $e');
      Get.snackbar(
        'Error',
        'Failed to load job details. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  // Filter Methods
  void _applyFilters() {
    List<Job> filtered = List.from(jobs);
    
    // Apply search filter if not already applied by API
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((job) {
        return job.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               job.company.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               job.domain.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    
    filteredJobs.value = filtered;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    refreshJobs();
  }

  void updateEducationLevel(String level) {
    selectedEducationLevel.value = level;
    selectedCourse.value = '';
    selectedSpecialization.value = '';
    selectedDomain.value = '';
    courses.clear();
    specializations.clear();
    domains.clear();
    
    if (level.isNotEmpty) {
      loadCoursesByLevel(level);
    }
    refreshJobs();
  }

  void updateCourse(String course) {
    selectedCourse.value = course;
    selectedSpecialization.value = '';
    selectedDomain.value = '';
    specializations.clear();
    domains.clear();
    
    if (course.isNotEmpty) {
      loadSpecializationsByCourse(course);
    }
    refreshJobs();
  }

  void updateSpecialization(String specialization) {
    selectedSpecialization.value = specialization;
    selectedDomain.value = '';
    domains.clear();
    
    if (specialization.isNotEmpty) {
      loadDomainsBySpecialization(specialization);
    }
    refreshJobs();
  }

  void updateDomain(String domain) {
    selectedDomain.value = domain;
    refreshJobs();
  }

  void updateLocation(String location) {
    selectedLocation.value = location;
    refreshJobs();
  }

  void clearFilters() {
    selectedEducationLevel.value = '';
    selectedCourse.value = '';
    selectedSpecialization.value = '';
    selectedDomain.value = '';
    selectedLocation.value = '';
    searchQuery.value = '';
    
    courses.clear();
    specializations.clear();
    domains.clear();
    
    refreshJobs();
  }

  // Saved Jobs Methods - DISABLED FOR NOW
  /*
  Future<void> loadSavedJobs() async {
    print('📋 [JOBS] Loading saved jobs (TEMPORARY WORKAROUND)');
    
    // TEMPORARY: Skip API call and show empty state
    // TODO: Fix API parsing issue and re-enable
    try {
      print('📋 [JOBS] Using temporary empty state for saved jobs');
      savedJobs.value = [];
      print('📋 [JOBS] Saved jobs loaded (empty state) - Count: 0');
      
      // Uncomment below when API parsing is fixed:
      final response = await JobService.getSavedJobs();
      if (response.success && response.data != null) {
        savedJobs.value = response.data!;
        print('📋 [JOBS] Saved jobs loaded successfully - Count: ${response.data!.length}');
      } else {
        print('📋 [JOBS] Failed to load saved jobs: ${response.error?.message}');
        if (response.error != null && response.error!.code != 'NOT_FOUND') {
          HttpService.handleApiError(response.error!);
        }
      }
    } catch (e) {
      print('📋 [JOBS] Error in temporary saved jobs handler: $e');
      savedJobs.value = [];
    }
  }
  */

  // DISABLED: Save job functionality
  /*
  Future<bool> saveJob(String jobId) async {
    print('📋 [JOBS] Saving job: $jobId (TEMPORARY LOCAL STORAGE)');
    
    // TEMPORARY: Use local storage instead of API
    try {
      // Find the job in current jobs list
      final job = jobs.where((j) => j.id == jobId).isNotEmpty 
          ? jobs.where((j) => j.id == jobId).first 
          : null;
      if (job != null) {
        // Create a SavedJob object
        final savedJob = SavedJob(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          jobId: jobId,
          userId: 'temp_user',
          savedAt: DateTime.now(),
          job: job,
        );
        
        // Add to local saved jobs list
        savedJobs.add(savedJob);
        
        Get.snackbar(
          'Success',
          'Job saved locally (temporary)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Job not found in current list',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      
      // TODO: Re-enable API call when parsing is fixed
      final response = await JobService.saveJob(jobId);
      if (response.success) {
        Get.snackbar(
          'Success',
          'Job saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        loadSavedJobs(); // Refresh saved jobs
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('📋 [JOBS] Error saving job locally: $e');
      Get.snackbar(
        'Error',
        'Failed to save job. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
  */

  // REMOVED: Saved jobs functionality
  /*
  Future<bool> unsaveJob(String jobId) async {
    print('📋 [JOBS] Unsaving job: $jobId (TEMPORARY LOCAL STORAGE)');
    
    // TEMPORARY: Use local storage instead of API
    try {
      // Remove from local saved jobs list
      savedJobs.removeWhere((savedJob) => savedJob.jobId == jobId);
      
      Get.snackbar(
        'Success',
        'Job removed from saved jobs (temporary)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      return true;
      
      // TODO: Re-enable API call when parsing is fixed
      final response = await JobService.unsaveJob(jobId);
      if (response.success) {
        Get.snackbar(
          'Success',
          'Job removed from saved jobs',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        loadSavedJobs(); // Refresh saved jobs
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('📋 [JOBS] Error unsaving job locally: $e');
      Get.snackbar(
        'Error',
        'Failed to remove job from saved jobs. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
  */

  // REMOVED: Saved jobs functionality
  /*
  bool isJobSaved(String jobId) {
    return savedJobs.any((savedJob) => savedJob.jobId == jobId);
  }
  */

  // Job Application Methods
  Future<bool> applyToJob({
    required String jobId,
    required Map<String, dynamic> contactInfo,
    required Map<String, dynamic> resume,
    List<Map<String, dynamic>>? employerQuestions,
    List<Map<String, dynamic>>? relevantExperience,
    String? coverLetter,
    Map<String, dynamic>? jobAlertPreferences,
  }) async {
    try {
      final response = await JobService.applyToJob(
        jobId: jobId,
        contactInfo: contactInfo,
        resume: resume,
        employerQuestions: employerQuestions,
        relevantExperience: relevantExperience,
        coverLetter: coverLetter,
        jobAlertPreferences: jobAlertPreferences,
      );

      if (response.success) {
        Get.snackbar(
          'Success',
          'Application submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      print('Error applying to job: $e');
      Get.snackbar(
        'Error',
        'Failed to submit application. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Utility Methods
  List<String> get allDomains {
    final Set<String> allDomainsSet = {};
    allDomainsSet.addAll(domains);
    allDomainsSet.addAll(availableDomains);
    return allDomainsSet.toList()..sort();
  }

  List<String> get allLocations {
    final Set<String> allLocationsSet = {};
    allLocationsSet.addAll(availableLocations);
    // Add locations from current jobs
    for (final job in jobs) {
      allLocationsSet.add(job.location);
    }
    return allLocationsSet.toList()..sort();
  }

  // Getters for UI
  List<Job> get displayJobs => filteredJobs.isNotEmpty ? filteredJobs : jobs;
  
  bool get hasFilters => 
      selectedEducationLevel.value.isNotEmpty ||
      selectedCourse.value.isNotEmpty ||
      selectedSpecialization.value.isNotEmpty ||
      selectedDomain.value.isNotEmpty ||
      selectedLocation.value.isNotEmpty ||
      searchQuery.value.isNotEmpty;

  // Application status tracking
  final appliedJobIds = <String>[].obs;

  // Check if user has applied to a specific job
  Future<bool> hasAppliedToJob(String jobId) async {
    try {
      final response = await JobService.hasAppliedToJob(jobId);
      if (response.success) {
        return response.data ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking application status: $e');
      return false;
    }
  }

  // Load applied job IDs for current user
  Future<void> loadAppliedJobIds() async {
    try {
      final response = await JobService.getAppliedJobIds();
      if (response.success && response.data != null) {
        appliedJobIds.value = response.data!;
        print('📋 [JOBS] Loaded ${appliedJobIds.length} applied job IDs');
      }
    } catch (e) {
      print('Error loading applied job IDs: $e');
    }
  }

  // Check if job ID is in applied list (for quick local check)
  bool isJobApplied(String jobId) {
    return appliedJobIds.contains(jobId);
  }
}