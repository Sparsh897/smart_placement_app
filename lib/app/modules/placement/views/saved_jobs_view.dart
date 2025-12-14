// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../routes/app_pages.dart';
// import '../../auth/controllers/auth_controller.dart';
// import '../controllers/placement_controller.dart';

// class SavedJobsView extends GetView<PlacementController> {
//   const SavedJobsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>();
    
//     return Obx(() {
//       // Check if user is logged in
//       if (!authController.isLoggedIn.value) {
//         // Redirect to login page if not authenticated
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Get.offNamed('/auth');
//         });
        
//         // Show loading screen while redirecting
//         return Scaffold(
//           backgroundColor: Colors.grey[50],
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             title: const Text('Saved Jobs'),
//           ),
//           body: const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text(
//                   'Please login to view saved jobs',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
      
//       // User is logged in, load saved jobs
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         controller.loadSavedJobs();
//       });
    
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text('Saved Jobs'),
//         titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//       ),
//       body: Obx(() {
//         final saved = controller.savedJobs;
//         if (saved.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.bookmark_border,
//                   size: 80,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No saved jobs yet',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         color: Colors.grey[600],
//                       ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Bookmark jobs to view them here',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.grey[500],
//                       ),
//                 ),
//               ],
//             ),
//           );
//         }
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: saved.length,
//           itemBuilder: (_, index) {
//             final savedJob = saved[index];
//             final job = savedJob.job; // Extract the Job object from SavedJob
            
//             // Skip if job is null
//             if (job == null) return const SizedBox.shrink();
            
//             return TweenAnimationBuilder<double>(
//               tween: Tween(begin: 0.0, end: 1.0),
//               duration: Duration(milliseconds: 400 + (index * 60)),
//               builder: (context, value, child) {
//                 return Opacity(
//                   opacity: value,
//                   child: Transform.translate(
//                     offset: Offset(0, 20 * (1 - value)),
//                     child: child,
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Dismissible(
//                 key: ValueKey('${job.title}_${job.company}'),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.delete_outline, color: Colors.white, size: 28),
//                       SizedBox(height: 4),
//                       Text(
//                         'Remove',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 onDismissed: (_) {
//                   controller.unsaveJob(savedJob.jobId);
//                   Get.snackbar(
//                     'Removed',
//                     '${job.title} removed from saved jobs',
//                     snackPosition: SnackPosition.BOTTOM,
//                     backgroundColor: Colors.grey[800],
//                     colorText: Colors.white,
//                     duration: const Duration(seconds: 2),
//                   );
//                 },
//                 child: Material(
//                   elevation: 0,
//                   borderRadius: BorderRadius.circular(20),
//                   child: InkWell(
//                     onTap: () => Get.toNamed(
//                       Routes.jobDetail,
//                       arguments: job,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.08),
//                             blurRadius: 15,
//                             offset: const Offset(0, 4),
//                             spreadRadius: 1,
//                           ),
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.04),
//                             blurRadius: 6,
//                             offset: const Offset(0, 1),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Header with logo, title, company and bookmark
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Company logo
//                               Container(
//                                 width: 48,
//                                 height: 48,
//                                 decoration: BoxDecoration(
//                                   color: _getCompanyColor(job.company),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     job.company.substring(0, 1).toUpperCase(),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               // Title and company
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       job.title,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleMedium
//                                           ?.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       job.company,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium
//                                           ?.copyWith(
//                                             color: Colors.grey[600],
//                                             fontSize: 14,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Bookmark button (always filled since these are saved jobs)
//                               Icon(
//                                 Icons.bookmark,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 size: 24,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           // Salary and Applicants row
//                           Row(
//                             children: [
//                               // Salary
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green.withValues(alpha: 0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   job.salary,
//                                   style: const TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               // Applicants
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.person,
//                                     size: 16,
//                                     color: Colors.orange[600],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '${job.applicantCount} applicants',
//                                     style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           // Tags
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: [
//                               _buildTag('Remote', Colors.blue),
//                               _buildTag('Full-time', Colors.purple),
//                               _buildTag(job.location, Colors.orange),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//           },
//         );
//       }),
//     );
//     });
//   }

//   Color _getCompanyColor(String company) {
//     final colors = [
//       Colors.blue[600]!,
//       Colors.green[600]!,
//       Colors.orange[600]!,
//       Colors.purple[600]!,
//       Colors.red[600]!,
//       Colors.teal[600]!,
//       Colors.indigo[600]!,
//       Colors.pink[600]!,
//     ];
//     return colors[company.hashCode % colors.length];
//   }

//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
