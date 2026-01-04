import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/company_auth_controller.dart';

class CompanyAuthView extends GetView<CompanyAuthController> {
  const CompanyAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Back button
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.business,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(() => Text(
                        controller.isLogin.value 
                            ? 'Welcome Back!' 
                            : 'Create Company Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        controller.isLogin.value 
                            ? 'Sign in to your company account' 
                            : 'Register your company to start hiring',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Form Fields
                  Obx(() => Column(
                    children: [
                      // Company Name (only for registration)
                      if (!controller.isLogin.value) ...[
                        _buildTextField(
                          controller: controller.nameController,
                          label: 'Company Name',
                          hint: 'Enter your company name',
                          icon: Icons.business_outlined,
                          validator: controller.validateCompanyName,
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Email
                      _buildTextField(
                        controller: controller.emailController,
                        label: 'Email Address',
                        hint: 'Enter company email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      
                      // Password
                      Obx(() => _buildTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        hint: 'Enter password',
                        icon: Icons.lock_outlined,
                        obscureText: controller.obscurePassword.value,
                        validator: controller.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.obscurePassword.value 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      )),
                      
                      // Registration-only fields
                      if (!controller.isLogin.value) ...[
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.descriptionController,
                          label: 'Company Description',
                          hint: 'Describe your company',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                          validator: controller.validateDescription,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.websiteController,
                          label: 'Website (Optional)',
                          hint: 'https://yourcompany.com',
                          icon: Icons.language_outlined,
                          keyboardType: TextInputType.url,
                          validator: controller.validateWebsite,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: controller.industryController,
                          label: 'Industry (Optional)',
                          hint: 'e.g., Information Technology',
                          icon: Icons.category_outlined,
                        ),
                      ],
                    ],
                  )),
                  
                  const SizedBox(height: 40),
                  
                  // Submit Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value 
                          ? null 
                          : (controller.isLogin.value 
                              ? controller.login 
                              : controller.register),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              controller.isLogin.value ? 'Sign In' : 'Create Account',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Toggle Auth Mode
                  Center(
                    child: Obx(() => TextButton(
                      onPressed: controller.toggleAuthMode,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: controller.isLogin.value 
                                  ? "Don't have an account? " 
                                  : "Already have an account? ",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextSpan(
                              text: controller.isLogin.value ? 'Sign Up' : 'Sign In',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Get.theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}