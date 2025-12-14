import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeController extends GetxController {
  final currentPage = 0.obs;

  final pages = [
    WelcomePage(
      title: 'Find Your Dream Job',
      description:
          'Discover thousands of job opportunities tailored to your education and skills',
      icon: '💼',
    ),
    WelcomePage(
      title: 'Smart Recommendations',
      description:
          'Get personalized job suggestions based on your profile and preferences',
      icon: '🎯',
    ),
    WelcomePage(
      title: 'Easy Application',
      description:
          'Apply to multiple jobs with one tap and track your applications',
      icon: '🚀',
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void skip() {
    currentPage.value = pages.length - 1;
  }

  Future<void> completeWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_complete', true);
    Get.offAllNamed('/onboarding');
  }

  static Future<bool> checkWelcomeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('welcome_complete') ?? false;
  }
}

class WelcomePage {
  final String title;
  final String description;
  final String icon;

  WelcomePage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
