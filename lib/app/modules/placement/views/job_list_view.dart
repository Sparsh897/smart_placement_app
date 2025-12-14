import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
// REMOVED: Saved jobs functionality
// import '../../auth/controllers/auth_controller.dart';
import '../controllers/placement_controller.dart';

class JobListView extends GetView<PlacementController> {
  const JobListView({super.key});

  Color _getCompanyColor(String company) {
    final colors = [
      Colors.blue[600]!,
      Colors.purple[600]!,
      Colors.green[600]!,
      Colors.orange[600]!,
      Colors.red[600]!,
      Colors.teal[600]!,
      Colors.indigo[600]!,
      Colors.pink[600]!,
    ];
    return colors[company.hashCode % colors.length];
  }

  Widget _buildTag(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Job Listings'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
        actions: [
          // REMOVED: Saved jobs functionality
          // Container(
          //   margin: const EdgeInsets.only(right: 8),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          //     shape: BoxShape.circle,
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.bookmark_rounded,
          //       color: Theme.of(context).colorScheme.primary,
          //     ),
          //     onPressed: () => Get.toNamed(Routes.savedJobs),
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Get.toNamed(Routes.profile),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final jobs = controller.jobs;
        if (jobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_off_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No jobs available',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new opportunities',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (_, index) {
            final job = jobs[index];
            // REMOVED: Saved jobs functionality
            // final isSaved = controller.savedJobs.contains(job);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 80)),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    Routes.jobDetail,
                    arguments: job,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with logo, title, company and bookmark
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Company logo
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: _getCompanyColor(job.company),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  job.company.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Title and company
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    job.company,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // REMOVED: Bookmark button functionality
                            // IconButton(
                            //   icon: Icon(
                            //     isSaved
                            //         ? Icons.bookmark
                            //         : Icons.bookmark_border,
                            //     color: isSaved
                            //         ? Theme.of(context).colorScheme.primary
                            //         : Colors.grey[400],
                            //   ),
                            //   onPressed: () {
                            //     final authController = Get.find<AuthController>();
                            //     if (authController.requireAuth('Sign in to save jobs')) {
                            //       if (controller.isJobSaved(job.id)) {
                            //         controller.unsaveJob(job.id);
                            //       } else {
                            //         controller.saveJob(job.id);
                            //       }
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Salary and Applicants row
                        Row(
                          children: [
                            // Salary section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Salary/Monthly',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    job.salary,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // Applicants section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Applicant',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 12,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${(index + 1) * 234 + 1000}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Tags row
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildTag('Remote', Colors.blue[50]!, Colors.blue[700]!),
                            _buildTag('Full-time', Colors.green[50]!, Colors.green[700]!),
                            _buildTag(job.location, Colors.purple[50]!, Colors.purple[700]!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          },
        );
      }),
    );
  }
}
