import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/company_applications_controller.dart';
import '../../../data/models/company_models.dart';

class CompanyApplicationsView extends GetView<CompanyApplicationsController> {
  const CompanyApplicationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Applications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredApplications.isEmpty) {
                return _buildEmptyState();
              }

              return _buildApplicationsList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search applications...',
              prefixIcon: const Icon(Icons.search),
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
                borderSide: BorderSide(color: Get.theme.colorScheme.primary),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 12),
          // Status filter
          Row(
            children: [
              const Text(
                'Status: ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Obx(() => DropdownButton<String>(
                  value: controller.selectedStatus.value,
                  onChanged: (value) => controller.onStatusChanged(value!),
                  items: controller.statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.capitalize!),
                    );
                  }).toList(),
                  underline: Container(),
                  isExpanded: true,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No applications found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Applications will appear here when candidates apply to your jobs',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList() {
    return Obx(() => RefreshIndicator(
      onRefresh: controller.loadApplications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredApplications.length,
        itemBuilder: (context, index) {
          final application = controller.filteredApplications[index];
          return _buildApplicationCard(application);
        },
      ),
    ));
  }

  Widget _buildApplicationCard(JobApplication application) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showApplicationDetails(application),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      application.userId.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.userId.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          application.userId.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: controller.getStatusColor(application.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      application.status.capitalize!,
                      style: TextStyle(
                        color: controller.getStatusColor(application.status),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Applied for: ${application.jobId.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          application.jobId.location,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.category, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          application.jobId.domain,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        if (application.resume.isNotEmpty && application.resume['fileUrl'] != null) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.picture_as_pdf, size: 14, color: Get.theme.colorScheme.secondary),
                          const SizedBox(width: 4),
                          Text(
                            'Resume',
                            style: TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Applied on ${_formatDate(application.appliedAt)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  if (application.userId.phone != null) ...[
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      application.userId.phone!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showApplicationDetails(application),
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Get.theme.colorScheme.primary,
                        side: BorderSide(color: Get.theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (application.resume.isNotEmpty && application.resume['fileUrl'] != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewResume(application.resume['fileUrl']),
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text('Resume'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Get.theme.colorScheme.secondary,
                          side: BorderSide(color: Get.theme.colorScheme.secondary),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showStatusUpdateDialog(application),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(JobApplication application) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Application Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Applicant: ${application.userId.name}'),
            Text('Job: ${application.jobId.title}'),
            const SizedBox(height: 16),
            const Text('Select new status:'),
            const SizedBox(height: 8),
            ...['pending', 'shortlisted', 'hired', 'rejected'].map((status) {
              return ListTile(
                title: Text(status.capitalize!),
                leading: Radio<String>(
                  value: status,
                  groupValue: application.status,
                  onChanged: (value) {
                    Get.back();
                    if (value != null && value != application.status) {
                      controller.updateApplicationStatus(application, value);
                    }
                  },
                ),
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showApplicationDetails(JobApplication application) {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Application Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection('Applicant Information', [
                        'Name: ${application.userId.name}',
                        'Email: ${application.userId.email}',
                        if (application.userId.phone != null) 'Phone: ${application.userId.phone}',
                        if (application.contactInfo['fullName'] != null) 'Full Name: ${application.contactInfo['fullName']}',
                        if (application.contactInfo['phone'] != null) 'Contact Phone: ${application.contactInfo['phone']}',
                        if (application.contactInfo['location'] != null) 
                          'Location: ${_formatLocation(application.contactInfo['location'])}',
                      ]),
                      const SizedBox(height: 16),
                      _buildDetailSection('Job Information', [
                        'Title: ${application.jobId.title}',
                        'Company: ${application.jobId.company}',
                        'Location: ${application.jobId.location}',
                        'Domain: ${application.jobId.domain}',
                      ]),
                      const SizedBox(height: 16),
                      _buildDetailSection('Application Status', [
                        'Status: ${application.status.capitalize}',
                        'Applied: ${_formatDate(application.appliedAt)}',
                        'Last Updated: ${_formatDate(application.lastUpdated)}',
                      ]),
                      if (application.coverLetter != null) ...[
                        const SizedBox(height: 16),
                        _buildDetailSection('Cover Letter', [
                          application.coverLetter!,
                        ]),
                      ],
                      if (application.resume.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildDetailSection('Resume', [
                          'File: ${application.resume['fileName'] ?? 'Resume.pdf'}',
                          'Uploaded: ${application.resume['uploadedAt'] != null ? _formatDate(DateTime.parse(application.resume['uploadedAt'])) : 'Unknown'}',
                        ]),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _viewResume(application.resume['fileUrl']),
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text('View Resume'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.colorScheme.secondary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _downloadResume(application.resume['fileUrl'], application.resume['fileName']),
                                icon: const Icon(Icons.download),
                                label: const Text('Download'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Get.theme.colorScheme.secondary,
                                  side: BorderSide(color: Get.theme.colorScheme.secondary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showStatusUpdateDialog(application),
                      child: const Text('Update Status'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...details.map((detail) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(detail),
        )),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatLocation(Map<String, dynamic>? location) {
    if (location == null) return 'Not specified';
    
    final parts = <String>[];
    if (location['city'] != null && location['city'].toString().isNotEmpty) {
      parts.add(location['city'].toString());
    }
    if (location['state'] != null && location['state'].toString().isNotEmpty) {
      parts.add(location['state'].toString());
    }
    if (location['country'] != null && location['country'].toString().isNotEmpty) {
      parts.add(location['country'].toString());
    }
    
    return parts.isNotEmpty ? parts.join(', ') : 'Not specified';
  }

  Future<void> _viewResume(String? resumeUrl) async {
    if (resumeUrl == null || resumeUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Resume URL not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    try {
      final Uri url = Uri.parse(resumeUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not open resume. Please check your browser settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> _downloadResume(String? resumeUrl, String? fileName) async {
    if (resumeUrl == null || resumeUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Resume URL not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    try {
      final Uri url = Uri.parse(resumeUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        Get.snackbar(
          'Download',
          'Resume download started. Check your downloads folder.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not download resume. Please check your browser settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}