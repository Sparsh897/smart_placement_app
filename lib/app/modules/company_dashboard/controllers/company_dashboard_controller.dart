import 'dart:developer' as developer;
import 'package:get/get.dart';

import '../../../data/models/company_models.dart';
import '../../../data/services/company_service.dart';
import '../../company_auth/controllers/company_auth_controller.dart';

class CompanyDashboardController extends GetxController {
  final isLoading = false.obs;
  final dashboard = Rxn<CompanyDashboard>();
  final jobs = <CompanyJob>[].obs;
  final applications = <JobApplication>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
    loadJobs();
    loadApplications();
  }

  @override
  void onResumed() {
    // Refresh data when returning to dashboard
    refresh();
  }

  Future<void> loadDashboard() async {
    try {
      developer.log('Loading company dashboard', name: 'CompanyDashboardController');
      
      final response = await CompanyService.getDashboard();
      if (response.success && response.data != null) {
        dashboard.value = response.data;
        developer.log('Dashboard loaded successfully', name: 'CompanyDashboardController');
      } else {
        developer.log('Failed to load dashboard: ${response.error?.message}', 
            name: 'CompanyDashboardController', level: 1000);
      }
    } catch (e) {
      developer.log('Dashboard loading error: $e', name: 'CompanyDashboardController', level: 1000);
    }
  }

  Future<void> loadJobs() async {
    try {
      developer.log('Loading company jobs', name: 'CompanyDashboardController');
      
      final response = await CompanyService.getJobs(limit: 10);
      if (response.success && response.data != null) {
        jobs.value = response.data!;
        developer.log('Jobs loaded successfully: ${jobs.length} jobs', 
            name: 'CompanyDashboardController');
      } else {
        developer.log('Failed to load jobs: ${response.error?.message}', 
            name: 'CompanyDashboardController', level: 1000);
      }
    } catch (e) {
      developer.log('Jobs loading error: $e', name: 'CompanyDashboardController', level: 1000);
    }
  }

  Future<void> loadApplications() async {
    try {
      developer.log('Loading applications', name: 'CompanyDashboardController');
      
      final response = await CompanyService.getApplications(limit: 10);
      if (response.success && response.data != null) {
        applications.value = response.data!;
        developer.log('Applications loaded successfully: ${applications.length} applications', 
            name: 'CompanyDashboardController');
      } else {
        developer.log('Failed to load applications: ${response.error?.message}', 
            name: 'CompanyDashboardController', level: 1000);
      }
    } catch (e) {
      developer.log('Applications loading error: $e', name: 'CompanyDashboardController', level: 1000);
    }
  }

  @override
  Future<void> refresh() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadDashboard(),
        loadJobs(),
        loadApplications(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToJobs() {
    Get.toNamed('/company-jobs');
  }

  void navigateToApplications() {
    Get.toNamed('/company-applications');
  }

  void navigateToCreateJob() {
    Get.toNamed('/company-create-job');
  }

  void navigateToProfile() {
    Get.toNamed('/company-profile');
  }

  void logout() {
    final companyAuthController = Get.find<CompanyAuthController>();
    companyAuthController.logout();
  }
}