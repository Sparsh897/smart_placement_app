import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import '../../auth/controllers/auth_controller.dart';
import '../../../data/models/job_models.dart';
import '../../../data/services/job_service.dart';

class AppliedJobsController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  var applications = <JobApplication>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var hasMoreApplications = true.obs;
  var selectedStatus = 'all'.obs;
  var summary = Rxn<ApplicationSummary>();

  // Status filter options
  final statusOptions = [
    {'value': 'all', 'label': 'All Applications'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'reviewed', 'label': 'Reviewed'},
    {'value': 'shortlisted', 'label': 'Shortlisted'},
    {'value': 'rejected', 'label': 'Rejected'},
    {'value': 'hired', 'label': 'Hired'},
    {'value': 'withdrawn', 'label': 'Withdrawn'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadApplications();
  }

  Future<void> loadApplications({bool refresh = false}) async {
    if (!_authController.isLoggedIn.value) {
      developer.log('User not logged in, cannot load applications', name: 'AppliedJobsController');
      return;
    }

    try {
      if (refresh) {
        currentPage.value = 1;
        hasMoreApplications.value = true;
        applications.clear();
      }

      isLoading.value = true;
      errorMessage.value = '';
      
      developer.log('Loading job applications for user - Page: ${currentPage.value}', name: 'AppliedJobsController');
      
      final response = await JobService.getUserApplications(
        page: currentPage.value,
        limit: 20,
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
        sortBy: 'appliedAt',
        sortOrder: 'desc',
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        
        if (refresh) {
          applications.value = data.applications;
        } else {
          applications.addAll(data.applications);
        }
        
        summary.value = data.summary;
        hasMoreApplications.value = data.pagination.hasNext;
        
        developer.log('Applications loaded successfully: ${data.applications.length} applications', name: 'AppliedJobsController');
      } else {
        errorMessage.value = response.error?.message ?? 'Failed to load applications';
        developer.log('Error loading applications: ${response.error?.message}', name: 'AppliedJobsController', level: 900);
      }
      
    } catch (e) {
      developer.log('Exception loading applications: $e', name: 'AppliedJobsController', level: 900);
      errorMessage.value = 'Failed to load applications';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreApplications() async {
    if (!hasMoreApplications.value || isLoading.value) return;
    
    currentPage.value++;
    await loadApplications();
  }

  Future<void> refreshApplications() async {
    await loadApplications(refresh: true);
  }

  void filterByStatus(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      loadApplications(refresh: true);
    }
  }

  Future<void> withdrawApplication(String applicationId) async {
    try {
      isLoading.value = true;
      
      final response = await JobService.withdrawApplication(applicationId);
      
      if (response.success) {
        // Update the application in the list
        final index = applications.indexWhere((app) => app.id == applicationId);
        if (index != -1) {
          applications[index] = response.data!;
          applications.refresh();
        }
        
        Get.snackbar(
          'Success',
          'Application withdrawn successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error?.message ?? 'Failed to withdraw application',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while withdrawing application',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'reviewed':
        return 'Under Review';
      case 'shortlisted':
        return 'Shortlisted';
      case 'rejected':
        return 'Not Selected';
      case 'hired':
        return 'Hired';
      case 'withdrawn':
        return 'Withdrawn';
      default:
        return status.toUpperCase();
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'reviewed':
        return Colors.blue;
      case 'shortlisted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'hired':
        return Colors.purple;
      case 'withdrawn':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}