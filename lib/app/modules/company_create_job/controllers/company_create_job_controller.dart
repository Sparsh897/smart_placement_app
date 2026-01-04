import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/company_service.dart';
import '../../company_dashboard/controllers/company_dashboard_controller.dart';

class CompanyCreateJobController extends GetxController {
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final salaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final eligibilityController = TextEditingController();
  final applyLinkController = TextEditingController();

  // Dropdown selections
  final selectedDomain = ''.obs;
  final selectedEducationLevel = ''.obs;
  final selectedCourse = ''.obs;
  final selectedSpecialization = ''.obs;
  final selectedSkills = <String>[].obs;

  // Available options
  final domains = [
    'Software Development',
    'Web Development',
    'Mobile Development',
    'Data Science',
    'AI / ML',
    'DevOps',
    'Cybersecurity',
    'UI/UX Design',
    'Digital Marketing',
    'Business Analysis',
    'Project Management',
    'Quality Assurance',
    'Cloud Computing',
    'Database Administration',
    'Network Administration',
  ].obs;

  final educationLevels = ['Graduate', 'Post Graduate'].obs;
  
  final courses = <String, List<String>>{
    'Graduate': ['B.Tech / B.E', 'B.Sc', 'BBA', 'BCA', 'B.Com', 'Others'],
    'Post Graduate': ['M.Tech / M.E', 'M.Sc', 'MBA', 'MCA', 'M.Com', 'Others'],
  };

  final specializations = <String, List<String>>{
    'B.Tech / B.E': ['CSE', 'IT', 'ECE', 'EEE', 'Mechanical', 'Civil', 'Others'],
    'M.Tech / M.E': ['CSE', 'IT', 'ECE', 'EEE', 'Mechanical', 'Civil', 'Others'],
    'B.Sc': ['Computer Science', 'IT', 'Mathematics', 'Physics', 'Chemistry', 'Others'],
    'M.Sc': ['Computer Science', 'IT', 'Mathematics', 'Physics', 'Chemistry', 'Others'],
    'BBA': ['General', 'Finance', 'Marketing', 'HR', 'Operations', 'Others'],
    'MBA': ['General', 'Finance', 'Marketing', 'HR', 'Operations', 'Others'],
    'BCA': ['General', 'Software Development', 'Web Development', 'Others'],
    'MCA': ['General', 'Software Development', 'Web Development', 'Others'],
    'B.Com': ['General', 'Accounting', 'Finance', 'Others'],
    'M.Com': ['General', 'Accounting', 'Finance', 'Others'],
    'Others': ['General'],
  };

  final availableSkills = [
    'Python', 'Java', 'JavaScript', 'React', 'Angular', 'Vue.js', 'Node.js',
    'Express.js', 'Django', 'Flask', 'Spring Boot', 'HTML', 'CSS', 'Bootstrap',
    'Tailwind CSS', 'MongoDB', 'MySQL', 'PostgreSQL', 'Redis', 'AWS', 'Azure',
    'Google Cloud', 'Docker', 'Kubernetes', 'Git', 'GitHub', 'GitLab',
    'Machine Learning', 'Deep Learning', 'TensorFlow', 'PyTorch', 'Pandas',
    'NumPy', 'Scikit-learn', 'Data Analysis', 'Data Visualization', 'Tableau',
    'Power BI', 'Excel', 'SQL', 'NoSQL', 'REST APIs', 'GraphQL', 'Microservices',
    'Agile', 'Scrum', 'JIRA', 'Confluence', 'Figma', 'Adobe XD', 'Photoshop',
    'Illustrator', 'UI Design', 'UX Design', 'Wireframing', 'Prototyping',
  ].obs;

  @override
  void onClose() {
    titleController.dispose();
    locationController.dispose();
    salaryController.dispose();
    descriptionController.dispose();
    eligibilityController.dispose();
    applyLinkController.dispose();
    super.onClose();
  }

  List<String> get availableCourses {
    if (selectedEducationLevel.value.isEmpty) return [];
    return courses[selectedEducationLevel.value] ?? [];
  }

  List<String> get availableSpecializations {
    if (selectedCourse.value.isEmpty) return [];
    return specializations[selectedCourse.value] ?? [];
  }

  void onEducationLevelChanged(String? value) {
    selectedEducationLevel.value = value ?? '';
    selectedCourse.value = '';
    selectedSpecialization.value = '';
  }

  void onCourseChanged(String? value) {
    selectedCourse.value = value ?? '';
    selectedSpecialization.value = '';
  }

  void onSpecializationChanged(String? value) {
    selectedSpecialization.value = value ?? '';
  }

  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
  }

  Future<void> createJob() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDomain.value.isEmpty) {
      Get.snackbar(
        'Domain Required',
        'Please select a domain',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    if (selectedEducationLevel.value.isEmpty) {
      Get.snackbar(
        'Education Level Required',
        'Please select an education level',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    if (selectedCourse.value.isEmpty) {
      Get.snackbar(
        'Course Required',
        'Please select a course',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    if (selectedSpecialization.value.isEmpty) {
      Get.snackbar(
        'Specialization Required',
        'Please select a specialization',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await CompanyService.createJob(
        title: titleController.text.trim(),
        location: locationController.text.trim(),
        domain: selectedDomain.value,
        salary: salaryController.text.trim(),
        description: descriptionController.text.trim(),
        eligibility: eligibilityController.text.trim(),
        educationLevel: selectedEducationLevel.value,
        course: selectedCourse.value,
        specialization: selectedSpecialization.value,
        skills: selectedSkills.toList(),
        applyLink: applyLinkController.text.trim().isNotEmpty 
            ? applyLinkController.text.trim() 
            : null,
      );

      if (response.success && response.data != null) {
        developer.log('Job created successfully: ${response.data!.title}', 
            name: 'CompanyCreateJobController');

        Get.snackbar(
          'Success!',
          'Job posted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 2),
        );

        // Navigate back to dashboard and refresh data
        Get.back();
        
        // Refresh dashboard data if controller exists
        try {
          final dashboardController = Get.find<CompanyDashboardController>();
          dashboardController.refresh();
        } catch (e) {
          developer.log('Dashboard controller not found, data will refresh on next visit', 
              name: 'CompanyCreateJobController');
        }
      } else {
        Get.snackbar(
          'Failed to Create Job',
          response.error?.message ?? 'Failed to create job posting',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      developer.log('Job creation error: $e', name: 'CompanyCreateJobController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while creating the job. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Form validators
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Job title is required';
    }
    if (value.length < 3) {
      return 'Job title must be at least 3 characters';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? validateSalary(String? value) {
    if (value == null || value.isEmpty) {
      return 'Salary is required';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Job description is required';
    }
    if (value.length < 50) {
      return 'Description must be at least 50 characters';
    }
    return null;
  }

  String? validateEligibility(String? value) {
    if (value == null || value.isEmpty) {
      return 'Eligibility criteria is required';
    }
    if (value.length < 10) {
      return 'Eligibility must be at least 10 characters';
    }
    return null;
  }

  String? validateApplyLink(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isURL(value)) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }
}