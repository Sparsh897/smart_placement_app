import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/company_models.dart';
import '../../../data/services/company_service.dart';
import '../../company_auth/controllers/company_auth_controller.dart';

class CompanyProfileController extends GetxController {
  final isLoading = false.obs;
  final isEditing = false.obs;
  final company = Rxn<Company>();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteController = TextEditingController();
  final industryController = TextEditingController();
  final sizeController = TextEditingController();
  final foundedController = TextEditingController();
  
  // Contact info controllers
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  
  // HR contact controllers
  final hrNameController = TextEditingController();
  final hrEmailController = TextEditingController();
  final hrPhoneController = TextEditingController();
  final hrDesignationController = TextEditingController();

  final companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '201-500 employees',
    '501-1000 employees',
    '1000+ employees',
  ].obs;

  final industries = [
    'Information Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Manufacturing',
    'Retail',
    'Consulting',
    'Real Estate',
    'Media & Entertainment',
    'Transportation',
    'Energy',
    'Government',
    'Non-profit',
    'Others',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadCompanyProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    websiteController.dispose();
    industryController.dispose();
    sizeController.dispose();
    foundedController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    hrNameController.dispose();
    hrEmailController.dispose();
    hrPhoneController.dispose();
    hrDesignationController.dispose();
    super.onClose();
  }

  Future<void> loadCompanyProfile() async {
    isLoading.value = true;
    try {
      // First try to get from CompanyAuthController
      final companyAuthController = Get.find<CompanyAuthController>();
      if (companyAuthController.currentCompany.value != null) {
        company.value = companyAuthController.currentCompany.value;
        _populateControllers();
        isLoading.value = false;
        return;
      }

      // If not available, fetch from API
      developer.log('Loading company profile from API', name: 'CompanyProfileController');
      
      final response = await CompanyService.getProfile();
      if (response.success && response.data != null) {
        company.value = response.data;
        _populateControllers();
        developer.log('Company profile loaded successfully', name: 'CompanyProfileController');
      } else {
        developer.log('Failed to load company profile: ${response.error?.message}', 
            name: 'CompanyProfileController', level: 1000);
        Get.snackbar(
          'Error',
          'Failed to load company profile: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Company profile loading error: $e', name: 'CompanyProfileController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while loading company profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _populateControllers() {
    final comp = company.value;
    if (comp == null) return;

    nameController.text = comp.name;
    descriptionController.text = comp.description ?? '';
    websiteController.text = comp.website ?? '';
    industryController.text = comp.industry ?? '';
    sizeController.text = comp.size ?? '';
    foundedController.text = comp.founded?.toString() ?? '';

    // Contact info
    phoneController.text = comp.contactInfo?.phone ?? '';
    streetController.text = comp.contactInfo?.address?.street ?? '';
    cityController.text = comp.contactInfo?.address?.city ?? '';
    stateController.text = comp.contactInfo?.address?.state ?? '';
    countryController.text = comp.contactInfo?.address?.country ?? '';
    pincodeController.text = comp.contactInfo?.address?.pincode ?? '';

    // HR contact
    hrNameController.text = comp.hrContact?.name ?? '';
    hrEmailController.text = comp.hrContact?.email ?? '';
    hrPhoneController.text = comp.hrContact?.phone ?? '';
    hrDesignationController.text = comp.hrContact?.designation ?? '';
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Reset controllers if canceling edit
      _populateControllers();
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      developer.log('Saving company profile', name: 'CompanyProfileController');

      final contactInfo = ContactInfo(
        phone: phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
        address: Address(
          street: streetController.text.trim().isNotEmpty ? streetController.text.trim() : null,
          city: cityController.text.trim().isNotEmpty ? cityController.text.trim() : null,
          state: stateController.text.trim().isNotEmpty ? stateController.text.trim() : null,
          country: countryController.text.trim().isNotEmpty ? countryController.text.trim() : null,
          pincode: pincodeController.text.trim().isNotEmpty ? pincodeController.text.trim() : null,
        ),
      );

      final hrContact = HrContact(
        name: hrNameController.text.trim().isNotEmpty ? hrNameController.text.trim() : null,
        email: hrEmailController.text.trim().isNotEmpty ? hrEmailController.text.trim() : null,
        phone: hrPhoneController.text.trim().isNotEmpty ? hrPhoneController.text.trim() : null,
        designation: hrDesignationController.text.trim().isNotEmpty ? hrDesignationController.text.trim() : null,
      );

      final response = await CompanyService.updateProfile(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        website: websiteController.text.trim().isNotEmpty ? websiteController.text.trim() : null,
        industry: industryController.text.trim().isNotEmpty ? industryController.text.trim() : null,
        size: sizeController.text.trim().isNotEmpty ? sizeController.text.trim() : null,
        founded: foundedController.text.trim().isNotEmpty ? int.tryParse(foundedController.text.trim()) : null,
        contactInfo: contactInfo,
        hrContact: hrContact,
      );

      if (response.success && response.data != null) {
        company.value = response.data;
        isEditing.value = false;
        
        // Update the company in CompanyAuthController
        final companyAuthController = Get.find<CompanyAuthController>();
        companyAuthController.currentCompany.value = response.data;
        
        developer.log('Company profile saved successfully', name: 'CompanyProfileController');
        
        Get.snackbar(
          'Success',
          'Company profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile: ${response.error?.message ?? 'Unknown error'}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Company profile save error: $e', name: 'CompanyProfileController', level: 1000);
      Get.snackbar(
        'Error',
        'An error occurred while saving profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Form validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    if (value.length < 2) {
      return 'Company name must be at least 2 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company description is required';
    }
    if (value.length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isURL(value)) {
        return 'Please enter a valid website URL';
      }
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isEmail(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!GetUtils.isPhoneNumber(value)) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value != null && value.isNotEmpty) {
      final year = int.tryParse(value);
      if (year == null) {
        return 'Please enter a valid year';
      }
      final currentYear = DateTime.now().year;
      if (year < 1800 || year > currentYear) {
        return 'Please enter a year between 1800 and $currentYear';
      }
    }
    return null;
  }
}