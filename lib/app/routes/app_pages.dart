import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/placement/bindings/placement_binding.dart';
import '../modules/placement/views/education_level_view.dart';
import '../modules/placement/views/course_selection_view.dart';
import '../modules/placement/views/specialization_selection_view.dart';
import '../modules/placement/views/domain_selection_view.dart';
import '../modules/placement/views/job_list_view.dart';
import '../modules/placement/views/job_detail_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/applied_jobs/bindings/applied_jobs_binding.dart';
import '../modules/applied_jobs/views/applied_jobs_view.dart';
import '../modules/job_application/bindings/job_application_binding.dart';
import '../modules/job_application/views/job_application_view.dart';
import '../modules/user_type_selection/bindings/user_type_selection_binding.dart';
import '../modules/user_type_selection/views/user_type_selection_view.dart';
import '../modules/company_auth/bindings/company_auth_binding.dart';
import '../modules/company_auth/views/company_auth_view.dart';
import '../modules/company_dashboard/bindings/company_dashboard_binding.dart';
import '../modules/company_dashboard/views/company_dashboard_view.dart';
import '../modules/company_create_job/bindings/company_create_job_binding.dart';
import '../modules/company_create_job/views/company_create_job_view.dart';
import '../modules/company_jobs/bindings/company_jobs_binding.dart';
import '../modules/company_jobs/views/company_jobs_view.dart';
import '../modules/company_profile/bindings/company_profile_binding.dart';
import '../modules/company_profile/views/company_profile_view.dart';
import '../modules/company_applications/bindings/company_applications_binding.dart';
import '../modules/company_applications/views/company_applications_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = '/';

  static final initialBinding = PlacementBinding();

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: '/',
      page: () => const UserTypeSelectionView(),
      binding: UserTypeSelectionBinding(),
    ),
    GetPage(
      name: Routes.userTypeSelection,
      page: () => const UserTypeSelectionView(),
      binding: UserTypeSelectionBinding(),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.mainNavigation,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.appliedJobs,
      page: () => const AppliedJobsView(),
      binding: AppliedJobsBinding(),
    ),
    GetPage(
      name: Routes.educationLevel,
      page: () => const EducationLevelView(),
      binding: PlacementBinding(),
    ),
    GetPage(
      name: Routes.course,
      page: () => const CourseSelectionView(),
      binding: PlacementBinding(),
    ),
    GetPage(
      name: Routes.specialization,
      page: () => const SpecializationSelectionView(),
      binding: PlacementBinding(),
    ),
    GetPage(
      name: Routes.domain,
      page: () => const DomainSelectionView(),
      binding: PlacementBinding(),
    ),
    GetPage(
      name: Routes.jobs,
      page: () => const JobListView(),
      binding: PlacementBinding(),
    ),
    GetPage(
      name: Routes.jobDetail,
      page: () => const JobDetailView(),
      binding: PlacementBinding(),
    ),
    GetPage(
      name: Routes.jobApplication,
      page: () => const JobApplicationView(),
      binding: JobApplicationBinding(),
    ),
    // REMOVED: Saved jobs functionality
    // GetPage(
    //   name: Routes.savedJobs,
    //   page: () => const SavedJobsView(),
    //   binding: PlacementBinding(),
    // ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: AuthBinding(),
    ),
    // Company routes
    GetPage(
      name: Routes.companyAuth,
      page: () => const CompanyAuthView(),
      binding: CompanyAuthBinding(),
    ),
    GetPage(
      name: Routes.companyDashboard,
      page: () => const CompanyDashboardView(),
      binding: CompanyDashboardBinding(),
    ),
    GetPage(
      name: Routes.companyCreateJob,
      page: () => const CompanyCreateJobView(),
      binding: CompanyCreateJobBinding(),
    ),
    GetPage(
      name: Routes.companyJobs,
      page: () => const CompanyJobsView(),
      binding: CompanyJobsBinding(),
    ),
    GetPage(
      name: Routes.companyProfile,
      page: () => const CompanyProfileView(),
      binding: CompanyProfileBinding(),
    ),
    GetPage(
      name: Routes.companyApplications,
      page: () => const CompanyApplicationsView(),
      binding: CompanyApplicationsBinding(),
    ),
  ];
}
