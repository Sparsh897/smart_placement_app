import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/company_models.dart';
import '../../../data/services/company_service.dart';

class CompanyApplicationsController extends GetxController {
  final isLoading = false.obs;
  final applications = <JobApplication>[].obs;
  final filteredApplications = <JobApplication>[].obs;
  final selectedStatus = 'all'.obs;
  final searchQuery = ''.obs;

  final statusOptions = ['all', 'pending', 'shortlisted', 'hired', 'rejected'].obs;

  @override
  void onInit() {
    super.onInit();
    loadApplications();
  }

  Future<void> loadApplications() async {
    isLoading.value = true;
    try {
      developer.log('Loading company applications', name: 'CompanyApplicationsController');
      
      final response = await CompanyService.getApplications(
        page: 1,
        limit: 100, // Load all applications
        status: selectedStatus.value,
      );

      if (response.success && response.data != null) {
        applications.value = response.data!;
        _filterApplications();
        developer.log('Applications loaded successfully: ${applications.length} applications', 
            name: 'CompanyApplicationsController');
      } else {
        developer.log('Failed to load applications: ${response.error?.message}', 
            name: 'CompanyApplicationsController', level: 1000);
        Get.snackbar(
          'Error',
          'Failed to load applications: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Applications loading error: $e', name: 'CompanyApplicationsController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while loading applications',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onStatusChanged(String status) {
    selectedStatus.value = status;
    loadApplications();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _filterApplications();
  }

  void _filterApplications() {
    if (searchQuery.value.isEmpty) {
      filteredApplications.value = applications;
    } else {
      filteredApplications.value = applications.where((application) {
        return application.userId.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               application.userId.email.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               application.jobId.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  Future<void> updateApplicationStatus(JobApplication application, String newStatus) async {
    try {
      developer.log('Updating application status: ${application.id} to $newStatus', 
          name: 'CompanyApplicationsController');
      
      final response = await CompanyService.updateApplicationStatus(
        applicationId: application.id,
        status: newStatus,
      );

      if (response.success && response.data != null) {
        // Update the application in the list
        final index = applications.indexWhere((app) => app.id == application.id);
        if (index != -1) {
          applications[index] = response.data!;
          _filterApplications();
        }
        
        Get.snackbar(
          'Success',
          'Application status updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update application status: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Application status update error: $e', name: 'CompanyApplicationsController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while updating application status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showStatusUpdateDialog(JobApplication application) {
    // This will be handled by the view
  }

  void showApplicationDetails(JobApplication application) {
    // This will be handled by the view
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shortlisted':
        return Colors.blue;
      case 'hired':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}