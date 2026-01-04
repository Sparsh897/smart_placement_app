part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const userTypeSelection = _Paths.userTypeSelection;
  static const welcome = _Paths.welcome;
  static const onboarding = _Paths.onboarding;
  static const mainNavigation = _Paths.mainNavigation;
  static const home = _Paths.home;
  static const appliedJobs = _Paths.appliedJobs;
  static const educationLevel = _Paths.educationLevel;
  static const course = _Paths.course;
  static const specialization = _Paths.specialization;
  static const domain = _Paths.domain;
  static const jobs = _Paths.jobs;
  static const jobDetail = _Paths.jobDetail;
  static const jobApplication = _Paths.jobApplication;
  static const auth = _Paths.auth;
  static const profile = _Paths.profile;
  // Company routes
  static const companyAuth = _Paths.companyAuth;
  static const companyDashboard = _Paths.companyDashboard;
  static const companyCreateJob = _Paths.companyCreateJob;
  static const companyJobs = _Paths.companyJobs;
  static const companyProfile = _Paths.companyProfile;
  static const companyApplications = _Paths.companyApplications;
}

abstract class _Paths {
  _Paths._();
  static const userTypeSelection = '/user-type-selection';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const mainNavigation = '/main';
  static const home = '/home';
  static const appliedJobs = '/applied-jobs';
  static const educationLevel = '/education';
  static const course = '/course';
  static const specialization = '/specialization';
  static const domain = '/domain';
  static const jobs = '/jobs';
  static const jobDetail = '/job-detail';
  static const jobApplication = '/job-application';
  static const auth = '/auth';
  static const profile = '/profile';
  // Company paths
  static const companyAuth = '/company-auth';
  static const companyDashboard = '/company-dashboard';
  static const companyCreateJob = '/company-create-job';
  static const companyJobs = '/company-jobs';
  static const companyProfile = '/company-profile';
  static const companyApplications = '/company-applications';
}
