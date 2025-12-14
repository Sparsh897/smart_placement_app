import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';
// REMOVED: Saved jobs functionality
// import '../../placement/controllers/placement_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Obx(() {
                    final user = authController.currentUser.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null ? 'Hello, ${authController.currentUser.value?.name}' : 'Hello!',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Find your dream job',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    );
                  }),
                  const Spacer(),
                  // REMOVED: Saved jobs functionality
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: Colors.grey[200]!),
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.bookmark_outline),
                  //     onPressed: () => Get.toNamed(Routes.savedJobs),
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: Colors.grey[200]!),
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.person_outline),
                  //     onPressed: () => Get.toNamed(Routes.profile),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search jobs...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Obx(() => controller.selectedDomains.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.filter_list_off),
                          onPressed: controller.clearFilters,
                        )
                      : const SizedBox()),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Filter Chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.availableDomains.length,
                itemBuilder: (_, index) {
                  final domain = controller.availableDomains[index];
                  return Obx(() {
                    final isSelected = controller.selectedDomains.contains(domain);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(domain),
                        selected: isSelected,
                        onSelected: (_) => controller.toggleDomainFilter(domain),
                        backgroundColor: Colors.white,
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300]!,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Job List
            Expanded(
              child: Obx(() {
                final jobs = controller.filteredJobs;
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
                          'No jobs found',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: jobs.length,
                  itemBuilder: (_, index) {
                    final job = jobs[index];
                    // REMOVED: Saved jobs functionality
                    // final placementController = Get.find<PlacementController>();

                    return Padding(
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
                                    // Obx(() {
                                    //   final isSaved = placementController
                                    //       .savedJobs
                                    //       .contains(job);
                                    //   return IconButton(
                                    //     icon: Icon(
                                    //       isSaved
                                    //           ? Icons.bookmark
                                    //           : Icons.bookmark_border,
                                    //       color: isSaved
                                    //           ? Theme.of(context)
                                    //               .colorScheme
                                    //               .primary
                                    //           : Colors.grey[400],
                                    //     ),
                                    //     onPressed: () {
                                    //       final authController =
                                    //           Get.find<AuthController>();
                                    //       if (authController.requireAuth(
                                    //           'Sign in to save jobs')) {
                                    //         if (placementController.isJobSaved(job.id)) {
                                    //           placementController.unsaveJob(job.id);
                                    //         } else {
                                    //           placementController.saveJob(job.id);
                                    //         }
                                    //       }
                                    //     },
                                    //   );
                                    // }),
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
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // REMOVED: Unused method
  // Widget _buildChip(BuildContext context, IconData icon, String label) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 14, color: Colors.grey[600]),
  //         const SizedBox(width: 4),
  //         Text(
  //           label,
  //           style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                 color: Colors.grey[700],
  //                 fontWeight: FontWeight.w500,
  //               ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
