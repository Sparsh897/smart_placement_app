import 'dart:developer' as developer;
import 'package:get/get.dart';

import '../../../data/models/user_models.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/http_service.dart';
import '../../../data/services/resume_service.dart';
import '../../auth/controllers/auth_controller.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final userProfile = Rxn<User>();
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Profile Management
  Future<void> loadUserProfile() async {
    developer.log('Loading user profile', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await UserService.getProfile();
      if (response.success && response.data != null) {
        userProfile.value = response.data;
        developer.log('Profile loaded successfully for: ${response.data!.name} (${response.data!.email})', name: 'UserController');
      } else {
        developer.log('Failed to load profile: ${response.error?.message}', name: 'UserController', level: 1000);
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
      }
    } catch (e) {
      developer.log('Error loading user profile: $e', name: 'UserController', level: 1000);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    Location? location,
    Profile? profile,
    Preferences? preferences,
  }) async {
    if (isLoading.value) return false;
    
    developer.log('Updating profile - Name: $name, Phone: $phone, Profile: ${profile?.toJson()}, Preferences: ${preferences?.toJson()}', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await UserService.updateProfile(
        name: name,
        phone: phone,
        location: location,
        profile: profile,
        preferences: preferences,
      );

      if (response.success && response.data != null) {
        userProfile.value = response.data;
        developer.log('Profile updated successfully', name: 'UserController');
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        developer.log('Profile update failed: ${response.error?.message}', name: 'UserController', level: 1000);
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      developer.log('Error updating profile: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Work Experience Management
  Future<bool> addWorkExperience(WorkExperience workExperience) async {
    if (isLoading.value) return false;
    
    developer.log('Adding work experience: ${workExperience.jobTitle} at ${workExperience.company}', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await UserService.addWorkExperience(workExperience);
      if (response.success) {
        developer.log('Work experience added successfully', name: 'UserController');
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Work experience added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        developer.log('Failed to add work experience: ${response.error?.message}', name: 'UserController', level: 1000);
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      developer.log('Error adding work experience: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to add work experience. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateWorkExperience(String id, WorkExperience workExperience) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.updateWorkExperience(id, workExperience);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Work experience updated successfully',
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
      developer.log('Error updating work experience: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to update work experience. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteWorkExperience(String id) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.deleteWorkExperience(id);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Work experience deleted successfully',
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
      developer.log('Error deleting work experience: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to delete work experience. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Education Management
  Future<bool> addEducation(Education education) async {
    if (isLoading.value) return false;
    
    developer.log('Adding education: ${education.degree} from ${education.institution}', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await UserService.addEducation(education);
      if (response.success) {
        developer.log('Education added successfully', name: 'UserController');
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Education added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        developer.log('Failed to add education: ${response.error?.message}', name: 'UserController', level: 1000);
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      developer.log('Error adding education: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to add education. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateEducation(String id, Education education) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.updateEducation(id, education);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Education updated successfully',
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
      developer.log('Error updating education: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to update education. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteEducation(String id) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.deleteEducation(id);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Education deleted successfully',
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
      developer.log('Error deleting education: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to delete education. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Skills Management
  Future<bool> addSkills(List<Skill> skills) async {
    if (isLoading.value) return false;
    
    developer.log('Adding ${skills.length} skills: ${skills.map((s) => s.name).join(', ')}', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await UserService.addSkills(skills);
      if (response.success) {
        developer.log('Skills added successfully', name: 'UserController');
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Skills added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        developer.log('Failed to add skills: ${response.error?.message}', name: 'UserController', level: 1000);
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      developer.log('Error adding skills: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to add skills. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateSkill(String id, Skill skill) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.updateSkill(id, skill);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Skill updated successfully',
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
      developer.log('Error updating skill: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to update skill. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSkill(String id) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.deleteSkill(id);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Skill deleted successfully',
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
      developer.log('Error deleting skill: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to delete skill. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Certifications Management
  Future<bool> addCertification(Certification certification) async {
    if (isLoading.value) return false;
    
    developer.log('Adding certification: ${certification.name} from ${certification.issuer}', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await UserService.addCertification(certification);
      if (response.success) {
        developer.log('Certification added successfully', name: 'UserController');
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Certification added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        developer.log('Failed to add certification: ${response.error?.message}', name: 'UserController', level: 1000);
        if (response.error != null) {
          HttpService.handleApiError(response.error!);
        }
        return false;
      }
    } catch (e) {
      developer.log('Error adding certification: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to add certification. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateCertification(String id, Certification certification) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.updateCertification(id, certification);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Certification updated successfully',
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
      developer.log('Error updating certification: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to update certification. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCertification(String id) async {
    if (isLoading.value) return false;
    
    isLoading.value = true;
    try {
      final response = await UserService.deleteCertification(id);
      if (response.success) {
        await loadUserProfile(); // Refresh profile
        Get.snackbar(
          'Success',
          'Certification deleted successfully',
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
      developer.log('Error deleting certification: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to delete certification. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Resume Management
  final isUploadingResume = false.obs;

  Future<bool> uploadResume() async {
    if (isUploadingResume.value) return false;
    
    developer.log('Starting resume upload process', name: 'UserController');
    isUploadingResume.value = true;
    try {
      String? resumeUrl = await ResumeService.uploadResume();
      
      if (resumeUrl != null) {
        // Refresh user profile to get updated data
        await loadUserProfile();
        
        Get.snackbar(
          'Success',
          'Resume uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        return true;
      } else {
        developer.log('Resume upload cancelled by user', name: 'UserController');
        return false;
      }
    } catch (e) {
      developer.log('Resume upload failed: $e', name: 'UserController', level: 1000);
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



  Future<bool> deleteResume() async {
    if (isLoading.value) return false;
    
    developer.log('Deleting resume', name: 'UserController');
    isLoading.value = true;
    try {
      final response = await ResumeService.deleteResume();
      if (response.success) {
        // Refresh user profile
        await loadUserProfile();
        
        Get.snackbar(
          'Success',
          'Resume deleted successfully',
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
      developer.log('Error deleting resume: $e', name: 'UserController', level: 1000);
      Get.snackbar(
        'Error',
        'Failed to delete resume. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Utility Methods
  bool get hasProfile => userProfile.value != null;
  
  bool get hasWorkExperience => 
      userProfile.value?.workExperience?.isNotEmpty ?? false;
  
  bool get hasEducation => 
      userProfile.value?.education?.isNotEmpty ?? false;
  
  bool get hasSkills => 
      userProfile.value?.skills?.isNotEmpty ?? false;
  
  bool get hasCertifications => 
      userProfile.value?.certifications?.isNotEmpty ?? false;

  bool get hasResume {
    // Check userProfile first
    var resumeUrl = userProfile.value?.profile?.resumeUrl;
    
    // Fallback to authController's currentUser if userProfile is not loaded
    if (resumeUrl == null) {
      try {
        final authController = Get.find<AuthController>();
        resumeUrl = authController.currentUser.value?.profile?.resumeUrl;
        developer.log('Checking hasResume from authController: $resumeUrl', name: 'UserController');
      } catch (e) {
        developer.log('AuthController not found: $e', name: 'UserController');
      }
    }
    
    final hasResumeUrl = resumeUrl != null && resumeUrl.isNotEmpty;
    developer.log('Checking hasResume: $hasResumeUrl, resumeUrl: $resumeUrl', name: 'UserController');
    return hasResumeUrl;
  }
  
  String? get currentResumeUrl {
    // Check userProfile first
    var resumeUrl = userProfile.value?.profile?.resumeUrl;
    
    // Fallback to authController's currentUser if userProfile is not loaded
    if (resumeUrl == null || resumeUrl.isEmpty) {
      try {
        final authController = Get.find<AuthController>();
        resumeUrl = authController.currentUser.value?.profile?.resumeUrl;
        developer.log('Getting currentResumeUrl from authController: $resumeUrl', name: 'UserController');
      } catch (e) {
        developer.log('AuthController not found: $e', name: 'UserController');
      }
    }
    
    developer.log('Getting currentResumeUrl: $resumeUrl', name: 'UserController');
    return resumeUrl;
  }

  // Update user profile with User object (for personal info editing)
  Future<bool> updateUserProfile(User user) async {
    if (isLoading.value) return false;
    
    developer.log('Updating user profile: ${user.name} (${user.email})', name: 'UserController');
    return await updateProfile(
      name: user.name,
      phone: user.phone,
      location: user.location,
    );
  }
}