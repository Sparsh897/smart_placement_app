import 'dart:developer' as developer;
import 'package:get/get.dart';

import '../../../data/models/company_models.dart';
import '../../../data/services/company_service.dart';

class CompanyJobsController extends GetxController {
  final isLoading = false.obs;
  final jobs = <CompanyJob>[].obs;
  final filteredJobs = <CompanyJob>[].obs;
  final selectedStatus = 'all'.obs;
  final searchQuery = ''.obs;

  final statusOptions = ['all', 'active', 'inactive'].obs;

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  Future<void> loadJobs() async {
    isLoading.value = true;
    try {
      developer.log('Loading company jobs', name: 'CompanyJobsController');
      
      final response = await CompanyService.getJobs(
        page: 1,
        limit: 100, // Load all jobs
        status: selectedStatus.value,
      );

      if (response.success && response.data != null) {
        jobs.value = response.data!;
        _filterJobs();
        developer.log('Jobs loaded successfully: ${jobs.length} jobs', 
            name: 'CompanyJobsController');
      } else {
        developer.log('Failed to load jobs: ${response.error?.message}', 
            name: 'CompanyJobsController', level: 1000);
        Get.snackbar(
          'Error',
          'Failed to load jobs: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Jobs loading error: $e', name: 'CompanyJobsController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while loading jobs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onStatusChanged(String status) {
    selectedStatus.value = status;
    loadJobs();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _filterJobs();
  }

  void _filterJobs() {
    if (searchQuery.value.isEmpty) {
      filteredJobs.value = jobs;
    } else {
      filteredJobs.value = jobs.where((job) {
        return job.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               job.domain.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               job.location.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  Future<void> toggleJobStatus(CompanyJob job) async {
    try {
      developer.log('Toggling job status: ${job.id}', name: 'CompanyJobsController');
      
      final response = await CompanyService.toggleJobStatus(job.id);
      if (response.success && response.data != null) {
        // Update the job in the list
        final index = jobs.indexWhere((j) => j.id == job.id);
        if (index != -1) {
          jobs[index] = response.data!;
          _filterJobs();
        }
        
        Get.snackbar(
          'Success',
          'Job status updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update job status: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Job status toggle error: $e', name: 'CompanyJobsController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while updating job status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteJob(CompanyJob job) async {
    try {
      developer.log('Deleting job: ${job.id}', name: 'CompanyJobsController');
      
      final response = await CompanyService.deleteJob(job.id);
      if (response.success) {
        // Remove the job from the list
        jobs.removeWhere((j) => j.id == job.id);
        _filterJobs();
        
        Get.snackbar(
          'Success',
          'Job deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete job: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Job deletion error: $e', name: 'CompanyJobsController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while deleting job',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void navigateToCreateJob() {
    Get.toNamed('/company-create-job');
  }

  void navigateToEditJob(CompanyJob job) {
    Get.toNamed('/company-create-job', arguments: job);
  }

  void showDeleteConfirmation(CompanyJob job) {
    // This will be handled by the view
  }

  @override
  void onClose() {
    super.onClose();
  }
}