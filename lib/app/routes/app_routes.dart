part of 'app_pages.dart';

abstract class Routes {
  Routes._();
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
}

abstract class _Paths {
  _Paths._();
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
}
