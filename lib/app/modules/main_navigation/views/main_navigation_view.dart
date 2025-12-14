import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';
import '../../home/views/home_view.dart';
import '../../auth/views/profile_view.dart';
import '../../applied_jobs/views/applied_jobs_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value,
        children: const [
          HomeView(),
          AppliedJobsView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    ));
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                index: 0,
                isSelected: controller.currentIndex.value == 0,
              ),
              _buildNavItem(
                context,
                icon: Icons.work_rounded,
                index: 1,
                isSelected: controller.currentIndex.value == 1,
              ),
              _buildNavItem(
                context,
                icon: Icons.person_rounded,
                index: 2,
                isSelected: controller.currentIndex.value == 2,
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected 
              ? Colors.white 
              : Colors.grey[500],
          size: 26,
        ),
      ),
    );
  }
}