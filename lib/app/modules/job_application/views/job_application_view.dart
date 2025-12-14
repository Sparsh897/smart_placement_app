import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/job_application_controller.dart';
import 'widgets/resume_selection_step.dart';
import 'widgets/application_questions_step.dart';
import 'widgets/contact_information_step.dart';
import 'widgets/application_review_step.dart';

class JobApplicationView extends GetView<JobApplicationController> {
  const JobApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Apply to ${controller.job.company}',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job info
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          controller.job.company.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.job.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${controller.job.company} • ${controller.job.location}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Progress bar
                Obx(() => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: controller.steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        final isActive = index <= controller.currentStep.value;
                        final isCurrent = index == controller.currentStep.value;
                        
                        return Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 4,
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 0 : 4,
                                  right: index == controller.steps.length - 1 ? 0 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive 
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                                  color: isActive ? Colors.black87 : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )),
              ],
            ),
          ),
          // Content
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (index) => controller.currentStep.value = index,
              children: const [
                ResumeSelectionStep(),
                ApplicationQuestionsStep(),
                ContactInformationStep(),
                ApplicationReviewStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}