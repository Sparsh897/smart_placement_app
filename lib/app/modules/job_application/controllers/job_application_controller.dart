import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/models/job_models.dart';
import '../../../data/models/user_models.dart';
import '../../../data/services/job_service.dart';
import '../../../data/services/resume_service.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../user/controllers/user_controller.dart';
import '../../placement/controllers/placement_controller.dart';

class JobApplicationController extends GetxController {
  final isLoading = false.obs;
  final currentStep = 0.obs;
  late final PageController pageController;
  
  // Job and user data
  late Job job;
  final currentUser = Rxn<User>();
  
  // Application form data
  final contactInfo = <String, dynamic>{}.obs;
  final resume = <String, dynamic>{}.obs;
  final employerQuestions = <Map<String, dynamic>>[].obs;
  final relevantExperience = <Map<String, dynamic>>[].obs;
  final supportingDocuments = <Map<String, dynamic>>[].obs;
  final coverLetter = ''.obs;
  final jobAlertPreferences = <String, dynamic>{}.obs;
  
  // Application answers for questions
  final applicationAnswers = <String, dynamic>{}.obs;
  
  // Resume upload state
  final isUploadingResume = false.obs;
  
  // Application steps
  final steps = [
    'Resume',
    'Questions', 
    'Contact Info',
    'Review'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize PageController
    pageController = PageController(initialPage: 0);
    
    // Get job from arguments
    if (Get.arguments == null) {
      Get.back();
      Get.snackbar(
        'Error',
        'No job selected for application',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }
    
    try {
      job = Get.arguments as Job;
      loadUserData();
      initializeFormData();
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Invalid job data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  void loadUserData() async {
    final authController = Get.find<AuthController>();
    currentUser.value = authController.currentUser.value;
    
    // If user data is not complete, fetch from API
    if (currentUser.value == null) {
      final userController = Get.find<UserController>();
      await userController.loadUserProfile();
      currentUser.value = userController.userProfile.value;
    }
  }

  void initializeFormData() {
    final user = currentUser.value;
    if (user != null) {
      // Initialize contact info
      contactInfo.value = {
        'fullName': user.name,
        'email': user.email,
        'phone': user.phone ?? '',
        'location': {
          'city': user.location?.city ?? '',
          'state': user.location?.state ?? '',
          'country': user.location?.country ?? 'India',
        }
      };
      
      // Initialize resume info
      if (user.profile?.resumeUrl != null) {
        resume.value = {
          'fileName': '${user.name.replaceAll(' ', '_')}_resume.pdf',
          'fileUrl': user.profile!.resumeUrl!,
        };
      }
      
      // Initialize job alert preferences
      jobAlertPreferences.value = {
        'emailUpdates': false,
        'location': job.location,
        'jobTitle': job.title,
      };
      
      // Initialize employer questions with sample questions
      employerQuestions.value = [
        {
          'question': 'Do you speak English?',
          'answer': null,
          'questionType': 'boolean'
        },
        {
          'question': 'How many years of ${job.domain} experience do you have?',
          'answer': null,
          'questionType': 'number'
        },
        {
          'question': 'How many years of programming experience do you have?',
          'answer': null,
          'questionType': 'number'
        },
        {
          'question': 'Will you be able to reliably commute or relocate to ${job.location} for this job?',
          'answer': null,
          'questionType': 'select',
          'options': [
            'Yes, I can make the commute',
            'Yes, I am willing to relocate',
            'No, I cannot commute or relocate'
          ]
        }
      ];
      
      // Initialize application answers
      applicationAnswers.clear();
      
      // Initialize relevant experience from user profile
      if (user.workExperience?.isNotEmpty == true) {
        relevantExperience.value = user.workExperience!.map((exp) => {
          'jobTitle': exp.jobTitle,
          'company': exp.company,
          'duration': '${exp.startDate} - ${exp.endDate}',
          'description': exp.description,
        }).toList();
      }
    }
  }

  // Navigation methods
  void nextStep() {
    // Validate current step before proceeding
    if (!_canProceedFromCurrentStep()) {
      _showValidationError();
      return;
    }
    
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
      // Only animate if PageController is attached to a PageView
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentStep.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      // Only animate if PageController is attached to a PageView
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentStep.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < steps.length) {
      currentStep.value = step;
      // Only animate if PageController is attached to a PageView
      if (pageController.hasClients) {
        pageController.animateToPage(
          step,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // Answer management methods
  void updateAnswer(String questionId, dynamic answer) {
    applicationAnswers[questionId] = answer;
  }

  // Step validation helper methods
  bool _canProceedFromCurrentStep() {
    switch (currentStep.value) {
      case 0: // Resume step
        return canProceedFromResume;
      case 1: // Questions step
        return canProceedFromQuestions;
      case 2: // Contact step
        return canProceedFromContact;
      case 3: // Review step
        return canSubmitApplication;
      default:
        return false;
    }
  }

  void _showValidationError() {
    String errorMessage;
    switch (currentStep.value) {
      case 0: // Resume step
        errorMessage = 'Please upload your resume to continue. Go to your profile to upload a CV.';
        break;
      case 1: // Questions step
        errorMessage = _getQuestionsValidationMessage();
        break;
      case 2: // Contact step
        errorMessage = _getContactValidationMessage();
        break;
      case 3: // Review step
        errorMessage = 'Please complete all required fields before submitting your application';
        break;
      default:
        errorMessage = 'Please complete all required fields';
    }

    Get.snackbar(
      'Required Fields Missing',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
    );
  }

  String _getQuestionsValidationMessage() {
    List<String> missingFields = [];
    
    if (applicationAnswers['question_1'] == null || applicationAnswers['question_1'].toString().isEmpty) {
      missingFields.add('English proficiency');
    }
    if (applicationAnswers['question_2'] == null || applicationAnswers['question_2'] is! int || applicationAnswers['question_2'] < 0) {
      missingFields.add('${job.domain} experience');
    }
    if (applicationAnswers['question_3'] == null || applicationAnswers['question_3'] is! int || applicationAnswers['question_3'] < 0) {
      missingFields.add('Programming experience');
    }
    if (applicationAnswers['question_4'] == null || applicationAnswers['question_4'].toString().isEmpty) {
      missingFields.add('Commute/relocation preference');
    }
    
    if (missingFields.isEmpty) {
      return 'Please answer all employer questions';
    } else if (missingFields.length == 1) {
      return 'Please answer the question about ${missingFields.first}';
    } else {
      return 'Please answer questions about: ${missingFields.join(', ')}';
    }
  }

  String _getContactValidationMessage() {
    List<String> missingFields = [];
    
    if (contactInfo['fullName']?.toString().isEmpty != false) {
      missingFields.add('full name');
    }
    if (contactInfo['email']?.toString().isEmpty != false) {
      missingFields.add('email address');
    }
    if (contactInfo['phone']?.toString().isEmpty != false) {
      missingFields.add('phone number');
    }
    
    if (missingFields.isEmpty) {
      return 'Please complete all contact information';
    } else if (missingFields.length == 1) {
      return 'Please provide your ${missingFields.first}';
    } else {
      return 'Please provide: ${missingFields.join(', ')}';
    }
  }

  // Validation methods
  bool get hasResume => resume.isNotEmpty && resume['fileUrl'] != null && resume['fileUrl'].toString().isNotEmpty;

  bool get canProceedFromResume => hasResume;

  bool get canProceedFromQuestions {
    // Check if all required questions are answered with valid values
    final q1 = applicationAnswers['question_1'];
    final q2 = applicationAnswers['question_2'];
    final q3 = applicationAnswers['question_3'];
    final q4 = applicationAnswers['question_4'];
    
    return q1 != null && q1.toString().isNotEmpty &&
           q2 != null && q2 is int && q2 >= 0 &&
           q3 != null && q3 is int && q3 >= 0 &&
           q4 != null && q4.toString().isNotEmpty;
  }

  bool get canProceedFromContact {
    final contact = contactInfo;
    return contact['fullName']?.toString().isNotEmpty == true && 
           contact['email']?.toString().isNotEmpty == true &&
           contact['phone']?.toString().isNotEmpty == true;
  }

  bool get canSubmitApplication {
    return hasResume && 
           canProceedFromQuestions && 
           canProceedFromContact;
  }

  // Application submission
  Future<void> submitApplication() async {
    if (!canSubmitApplication) {
      Get.snackbar(
        'Incomplete Application',
        'Please complete all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Prepare employer questions for submission
      final questionsForSubmission = [
        {
          'question': 'Do you speak English?',
          'answer': applicationAnswers['question_1'],
          'questionType': 'boolean',
        },
        {
          'question': 'How many years of ${job.domain} experience do you have?',
          'answer': applicationAnswers['question_2'],
          'questionType': 'number',
        },
        {
          'question': 'How many years of programming experience do you have?',
          'answer': applicationAnswers['question_3'],
          'questionType': 'number',
        },
        {
          'question': 'Will you be able to reliably commute or relocate to ${job.location} for this job?',
          'answer': applicationAnswers['question_4'],
          'questionType': 'select',
        },
      ];
      
      final response = await JobService.applyToJob(
        jobId: job.id,
        contactInfo: contactInfo,
        resume: resume,
        employerQuestions: questionsForSubmission,
        relevantExperience: relevantExperience,
        supportingDocuments: supportingDocuments,
        coverLetter: coverLetter.value.isNotEmpty ? coverLetter.value : null,
        jobAlertPreferences: jobAlertPreferences,
      );

      if (response.success) {
        // Update applied job IDs in placement controller
        final placementController = Get.find<PlacementController>();
        placementController.appliedJobIds.add(job.id);
        
        Get.snackbar(
          'Application Submitted',
          'Your application has been submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 3),
        );
        
        // Navigate back to main navigation (applied jobs tab)
        Get.offAllNamed('/main', arguments: 1); // Navigate to applied jobs tab
      } else {
        Get.snackbar(
          'Application Failed',
          response.error?.message ?? 'Failed to submit application',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while submitting your application',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Form update methods
  void updateContactInfo(String field, dynamic value) {
    contactInfo[field] = value;
  }

  void updateEmployerQuestion(int index, dynamic answer) {
    if (index < employerQuestions.length) {
      employerQuestions[index]['answer'] = answer;
      employerQuestions.refresh();
    }
  }

  void updateCoverLetter(String text) {
    coverLetter.value = text;
  }

  void updateJobAlertPreferences(String field, dynamic value) {
    jobAlertPreferences[field] = value;
  }

  void addRelevantExperience(Map<String, dynamic> experience) {
    relevantExperience.add(experience);
  }

  void removeRelevantExperience(int index) {
    if (index < relevantExperience.length) {
      relevantExperience.removeAt(index);
    }
  }

  void addSupportingDocument(Map<String, dynamic> document) {
    supportingDocuments.add(document);
  }

  void removeSupportingDocument(int index) {
    if (index < supportingDocuments.length) {
      supportingDocuments.removeAt(index);
    }
  }

  // Progress calculation
  double get progress => (currentStep.value + 1) / steps.length;

  // Resume upload functionality
  Future<bool> uploadResume() async {
    if (isUploadingResume.value) return false;
    
    isUploadingResume.value = true;
    try {
      String? resumeUrl = await ResumeService.uploadResume();
      
      if (resumeUrl != null) {
        // Update resume data in job application
        final user = currentUser.value;
        if (user != null) {
          resume.value = {
            'fileName': '${user.name.replaceAll(' ', '_')}_resume.pdf',
            'fileUrl': resumeUrl,
          };
        }
        
        // Update user data in AuthController and UserController
        final authController = Get.find<AuthController>();
        if (authController.currentUser.value != null) {
          // Update the user's profile with new resume URL
          final updatedUser = authController.currentUser.value!.copyWith(
            profile: authController.currentUser.value!.profile?.copyWith(
              resumeUrl: resumeUrl,
            ) ?? Profile(resumeUrl: resumeUrl),
          );
          authController.currentUser.value = updatedUser;
          currentUser.value = updatedUser;
        }
        
        // Also update UserController if available
        try {
          final userController = Get.find<UserController>();
          await userController.loadUserProfile();
        } catch (e) {
          // UserController might not be initialized, that's okay
        }
        
        return true;
      } else {
        return false; // User cancelled
      }
    } catch (e) {
      Get.snackbar(
        'Upload Failed',
        'Failed to upload resume: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } finally {
      isUploadingResume.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}