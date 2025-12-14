import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/job_application_controller.dart';

class ApplicationQuestionsStep extends GetView<JobApplicationController> {
  const ApplicationQuestionsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Questions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please answer the following questions from the employer',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sample questions - these would come from the job posting
                  _buildQuestion(
                    'Do you speak English?',
                    'question_1',
                    QuestionType.yesNo,
                  ),
                  const SizedBox(height: 20),
                  _buildQuestion(
                    'How many years of ${controller.job.domain} experience do you have?',
                    'question_2',
                    QuestionType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildQuestion(
                    'How many years of programming experience do you have?',
                    'question_3',
                    QuestionType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildQuestion(
                    'Will you be able to reliably commute or relocate to ${controller.job.location} for this job?',
                    'question_4',
                    QuestionType.custom,
                    customOptions: [
                      'Yes, I can make the commute',
                      'Yes, I am willing to relocate',
                      'No, I cannot commute or relocate',
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRelevantExperience(),
                  const SizedBox(height: 20),
                  _buildSupportingDocuments(),
                  const SizedBox(height: 20),
                  _buildEmailUpdates(),
                ],
              ),
            ),
          ),
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => ElevatedButton(
                  onPressed: controller.canProceedFromQuestions 
                      ? controller.nextStep 
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(
    String question,
    String questionId,
    QuestionType type, {
    List<String>? customOptions,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final currentAnswer = controller.applicationAnswers[questionId];
            
            switch (type) {
              case QuestionType.yesNo:
                return _buildYesNoAnswer(questionId, currentAnswer);
              case QuestionType.number:
                return _buildNumberAnswer(questionId, currentAnswer);
              case QuestionType.custom:
                return _buildCustomAnswer(questionId, currentAnswer, customOptions!);
              case QuestionType.text:
                return _buildTextAnswer(questionId, currentAnswer);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildYesNoAnswer(String questionId, dynamic currentAnswer) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Yes'),
            value: 'Yes',
            groupValue: currentAnswer,
            onChanged: (value) => controller.updateAnswer(questionId, value),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('No'),
            value: 'No',
            groupValue: currentAnswer,
            onChanged: (value) => controller.updateAnswer(questionId, value),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberAnswer(String questionId, dynamic currentAnswer) {
    return TextFormField(
      initialValue: currentAnswer?.toString() ?? '',
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final number = int.tryParse(value);
        controller.updateAnswer(questionId, number);
      },
      decoration: InputDecoration(
        hintText: 'Enter number of years',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildCustomAnswer(String questionId, dynamic currentAnswer, List<String> options) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: currentAnswer,
          onChanged: (value) => controller.updateAnswer(questionId, value),
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildTextAnswer(String questionId, dynamic currentAnswer) {
    return TextFormField(
      initialValue: currentAnswer?.toString() ?? '',
      maxLines: 3,
      onChanged: (value) => controller.updateAnswer(questionId, value),
      decoration: InputDecoration(
        hintText: 'Enter your answer',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildRelevantExperience() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Relevant experience',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to add experience
                },
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Show user's relevant experience from profile
          Obx(() {
            final user = controller.currentUser.value;
            if (user?.workExperience?.isNotEmpty == true) {
              final relevantExp = user!.workExperience!.first;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      relevantExp.jobTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      relevantExp.company,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text(
                'No relevant experience added',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSupportingDocuments() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Supporting documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add supporting documents
                },
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'No cover letter or additional documents included (optional)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailUpdates() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(() => Checkbox(
            value: controller.applicationAnswers['email_updates'] ?? false,
            onChanged: (value) => controller.updateAnswer('email_updates', value),
          )),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Get email updates for the latest ${controller.job.domain.toLowerCase()} jobs in ${controller.job.location}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum QuestionType {
  yesNo,
  number,
  custom,
  text,
}