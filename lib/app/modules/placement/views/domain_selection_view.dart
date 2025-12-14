import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/placement_controller.dart';

class DomainSelectionView extends GetView<PlacementController> {
  const DomainSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Select Domain'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
      ),
      body: Obx(() {
        final domains = controller.availableDomains;
        if (domains.isEmpty) {
          return const Center(
            child: Text('Please select a specialization first.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: domains.length,
          itemBuilder: (_, index) {
            final domain = domains[index];
            final colors = [
              Colors.blue,
              Colors.purple,
              Colors.orange,
              Colors.teal,
              Colors.pink,
              Colors.indigo,
              Colors.green,
              Colors.red,
            ];
            final color = colors[index % colors.length];
            
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 60)),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    controller.updateDomain(domain);
                    Get.toNamed(Routes.jobs);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.1),
                          color.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.work_outline,
                            color: color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            domain,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: color,
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
