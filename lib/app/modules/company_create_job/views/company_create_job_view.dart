import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/company_create_job_controller.dart';

class CompanyCreateJobView extends GetView<CompanyCreateJobController> {
  const CompanyCreateJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Job Posting',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Card
              _buildCard(
                context: context,
                title: 'Basic Information',
                icon: Icons.info_outline,
                children: [
                  _buildTextField(
                    controller: controller.titleController,
                    label: 'Job Title',
                    hint: 'e.g., Senior Software Engineer',
                    validator: controller.validateTitle,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.locationController,
                    label: 'Location',
                    hint: 'e.g., Bangalore, Mumbai, Remote',
                    validator: controller.validateLocation,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.salaryController,
                    label: 'Salary',
                    hint: 'e.g., ₹8-12 LPA, ₹50,000-80,000/month',
                    validator: controller.validateSalary,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Domain Selection Card
              _buildCard(
                context: context,
                title: 'Domain & Category',
                icon: Icons.category_outlined,
                children: [
                  _buildDropdown(
                    label: 'Domain',
                    hint: 'Select job domain',
                    value: controller.selectedDomain.value.isEmpty 
                        ? null 
                        : controller.selectedDomain.value,
                    items: controller.domains,
                    onChanged: (value) => controller.selectedDomain.value = value ?? '',
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Education Requirements Card
              _buildCard(
                context: context,
                title: 'Education Requirements',
                icon: Icons.school_outlined,
                children: [
                  Obx(() => _buildDropdown(
                    label: 'Education Level',
                    hint: 'Select education level',
                    value: controller.selectedEducationLevel.value.isEmpty 
                        ? null 
                        : controller.selectedEducationLevel.value,
                    items: controller.educationLevels,
                    onChanged: controller.onEducationLevelChanged,
                  )),
                  const SizedBox(height: 16),
                  Obx(() => _buildDropdown(
                    label: 'Course',
                    hint: 'Select course',
                    value: controller.selectedCourse.value.isEmpty 
                        ? null 
                        : controller.selectedCourse.value,
                    items: controller.availableCourses,
                    onChanged: controller.onCourseChanged,
                    enabled: controller.selectedEducationLevel.value.isNotEmpty,
                  )),
                  const SizedBox(height: 16),
                  Obx(() => _buildDropdown(
                    label: 'Specialization',
                    hint: 'Select specialization',
                    value: controller.selectedSpecialization.value.isEmpty 
                        ? null 
                        : controller.selectedSpecialization.value,
                    items: controller.availableSpecializations,
                    onChanged: controller.onSpecializationChanged,
                    enabled: controller.selectedCourse.value.isNotEmpty,
                  )),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Skills Card
              _buildCard(
                context: context,
                title: 'Required Skills',
                icon: Icons.build_outlined,
                children: [
                  Text(
                    'Select relevant skills for this position:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.availableSkills.map((skill) {
                      final isSelected = controller.selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (_) => controller.toggleSkill(skill),
                        selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
                  )),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    '${controller.selectedSkills.length} skills selected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Job Details Card
              _buildCard(
                context: context,
                title: 'Job Details',
                icon: Icons.description_outlined,
                children: [
                  _buildTextField(
                    controller: controller.descriptionController,
                    label: 'Job Description',
                    hint: 'Describe the role, responsibilities, and what you\'re looking for...',
                    maxLines: 5,
                    validator: controller.validateDescription,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.eligibilityController,
                    label: 'Eligibility Criteria',
                    hint: 'e.g., 2+ years experience, strong problem-solving skills...',
                    maxLines: 3,
                    validator: controller.validateEligibility,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.applyLinkController,
                    label: 'Application Link (Optional)',
                    hint: 'https://yourcompany.com/careers/apply',
                    validator: controller.validateApplyLink,
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Submit Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value 
                      ? null 
                      : controller.createJob,
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
                      : const Text(
                          'Post Job',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
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
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool enabled = true,
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
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.theme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}