import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../placement/controllers/placement_controller.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final placementController = Get.find<PlacementController>();
    final pageController = PageController();
    
    // Listen to selection changes and auto-slide
    ever(controller.selectedEducationLevel, (_) {
      if (controller.selectedEducationLevel.value != null) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (pageController.hasClients) {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          }
        });
      }
    });
    
    ever(controller.selectedCourse, (_) {
      if (controller.selectedCourse.value != null) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (pageController.hasClients) {
            pageController.animateToPage(
              2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          }
        });
      }
    });
    
    // Listen for specialization selection to trigger immediate preferences update
    ever(controller.selectedSpecialization, (_) {
      if (controller.selectedSpecialization.value != null && 
          controller.isOnboardingComplete) {
        // All selections are complete, update preferences immediately
        controller.updatePreferencesIfComplete();
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header with Animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Quick Setup',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tell us about yourself',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help us personalize your job recommendations',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              // Horizontal PageView with Cards
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Page 1: Education Level
                    _buildPageCard(
                      context,
                      child: _buildSection(
                        context,
                        stepNumber: '01',
                        title: 'Education Level',
                        subtitle: 'What\'s your current education?',
                        items: placementController.educationLevels,
                        selectedItem: controller.selectedEducationLevel,
                        onSelect: (level) {
                          controller.selectedEducationLevel.value = level;
                          controller.selectedCourse.value = null;
                          controller.selectedSpecialization.value = null;
                          placementController.updateEducationLevel(level);
                          // Check if all selections are complete and update preferences
                          controller.updatePreferencesIfComplete();
                        },
                        icons: const [
                          Icons.school_outlined,
                          Icons.workspace_premium_outlined,
                        ],
                      ),
                    ),
                    // Page 2: Course
                    Obx(() {
                      final courses = placementController.courses;
                      return _buildPageCard(
                        context,
                        child: _buildSection(
                          context,
                          stepNumber: '02',
                          title: 'Your Course',
                          subtitle: 'What are you studying?',
                          items: courses,
                          selectedItem: controller.selectedCourse,
                          onSelect: (course) {
                            controller.selectedCourse.value = course;
                            controller.selectedSpecialization.value = null;
                            placementController.updateCourse(course);
                            // Check if all selections are complete and update preferences
                            controller.updatePreferencesIfComplete();
                          },
                          enabled: controller.selectedEducationLevel.value != null,
                          icons: const [
                            Icons.computer,
                            Icons.science,
                            Icons.business_center,
                            Icons.code,
                            Icons.account_balance,
                            Icons.more_horiz,
                          ],
                        ),
                      );
                    }),
                    // Page 3: Specialization
                    Obx(() {
                      final specializations = placementController.specializations;
                      return _buildPageCard(
                        context,
                        child: _buildSection(
                          context,
                          stepNumber: '03',
                          title: 'Specialization',
                          subtitle: 'Your area of focus',
                          items: specializations,
                          selectedItem: controller.selectedSpecialization,
                          onSelect: (spec) {
                            controller.selectedSpecialization.value = spec;
                            placementController.updateSpecialization(spec);
                            // Check if all selections are complete and update preferences
                            controller.updatePreferencesIfComplete();
                          },
                          enabled: controller.selectedCourse.value != null,
                          icons: const [
                            Icons.category_outlined,
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Modern Bottom Button with Progress
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress Indicator
                    Obx(() {
                      int completed = 0;
                      if (controller.selectedEducationLevel.value != null) {
                        completed++;
                      }
                      if (controller.selectedCourse.value != null) completed++;
                      if (controller.selectedSpecialization.value != null) {
                        completed++;
                      }
                      return Row(
                        children: [
                          Text(
                            '$completed/3 completed',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          ...List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.only(left: 6),
                              height: 4,
                              width: 30,
                              decoration: BoxDecoration(
                                color: index < completed
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    // Continue Button
                    Obx(() {
                      final isComplete =
                          controller.selectedEducationLevel.value != null &&
                              controller.selectedCourse.value != null &&
                              controller.selectedSpecialization.value != null;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              isComplete ? controller.completeOnboarding : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: isComplete ? 4 : 0,
                            shadowColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.4),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Continue to Home',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: isComplete ? Colors.white : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageCard(BuildContext context, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: child,
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String stepNumber,
    required String title,
    required String subtitle,
    required List<String> items,
    required RxnString selectedItem,
    required Function(String) onSelect,
    bool enabled = true,
    List<IconData> icons = const [],
  }) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: enabled ? Colors.grey[200]! : Colors.grey[100]!,
            width: 1.5,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: enabled
                          ? LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            )
                          : null,
                      color: enabled ? null : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      stepNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: enabled ? Colors.black87 : Colors.grey,
                                letterSpacing: -0.5,
                              ),
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color:
                                    enabled ? Colors.grey[600] : Colors.grey[400],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                final selected = selectedItem.value;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selected == item;
                    final icon =
                        icons.isNotEmpty ? icons[index % icons.length] : null;

                    return _buildGridChip(
                      context,
                      label: item,
                      icon: icon,
                      isSelected: isSelected,
                      onTap: enabled ? () => onSelect(item) : null,
                      enabled: enabled,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridChip(
    BuildContext context, {
    required String label,
    IconData? icon,
    required bool isSelected,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Material(
      elevation: isSelected ? 4 : 0,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  )
                : null,
            color: isSelected ? null : Colors.grey[50],
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (enabled ? Colors.grey[300]! : Colors.grey[200]!),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.2,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (isSelected) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
