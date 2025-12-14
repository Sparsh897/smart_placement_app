class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String domain;
  final String description;
  final String eligibility;
  final String educationLevel;
  final String course;
  final String specialization;
  final List<String> skills;
  final String applyLink;
  final int applicantCount;
  final List<String> jobTypes;
  final bool isRemote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.domain,
    required this.description,
    required this.eligibility,
    required this.educationLevel,
    required this.course,
    required this.specialization,
    required this.skills,
    required this.applyLink,
    this.applicantCount = 0,
    this.jobTypes = const [],
    this.isRemote = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      domain: json['domain'] ?? '',
      description: json['description'] ?? '',
      eligibility: json['eligibility'] ?? '',
      educationLevel: json['educationLevel'] ?? '',
      course: json['course'] ?? '',
      specialization: json['specialization'] ?? '',
      skills: json['skills'] != null 
          ? List<String>.from(json['skills']) 
          : [],
      applyLink: json['applyLink'] ?? '',
      applicantCount: json['applicantCount'] ?? 0,
      jobTypes: json['jobTypes'] != null 
          ? List<String>.from(json['jobTypes']) 
          : [],
      isRemote: json['isRemote'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'domain': domain,
      'description': description,
      'eligibility': eligibility,
      'educationLevel': educationLevel,
      'course': course,
      'specialization': specialization,
      'skills': skills,
      'applyLink': applyLink,
      'applicantCount': applicantCount,
      'jobTypes': jobTypes,
      'isRemote': isRemote,
    };
  }
}

class JobsData {
  final List<Job> jobs;
  final JobsPagination pagination;

  JobsData({required this.jobs, required this.pagination});

  factory JobsData.fromJson(Map<String, dynamic> json) {
    return JobsData(
      jobs: json['jobs'] != null
          ? (json['jobs'] as List).map((e) => Job.fromJson(e)).toList()
          : [],
      pagination: JobsPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class JobsPagination {
  final int currentPage;
  final int totalPages;
  final int totalJobs;
  final int limit;
  final bool hasNext;
  final bool hasPrev;

  JobsPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalJobs,
    required this.limit,
    required this.hasNext,
    required this.hasPrev,
  });

  factory JobsPagination.fromJson(Map<String, dynamic> json) {
    return JobsPagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalJobs: json['totalJobs'] ?? 0,
      limit: json['limit'] ?? 20,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}

class Location {
  final String? city;
  final String? state;
  final String? country;

  Location({
    this.city,
    this.state,
    this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
    };
  }
}

class JobApplication {
  final String id;
  final String jobId;
  final String userId;
  final String status;
  final DateTime appliedAt;
  final DateTime lastUpdated;
  final ContactInfo contactInfo;
  final Resume resume;
  final List<EmployerQuestion> employerQuestions;
  final List<RelevantExperience> relevantExperience;
  final List<SupportingDocument> supportingDocuments;
  final String? coverLetter;
  final JobAlertPreferences? jobAlertPreferences;
  final String applicationSource;
  final List<EmployerAction> employerActions;
  final Job? job;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.appliedAt,
    required this.lastUpdated,
    required this.contactInfo,
    required this.resume,
    required this.employerQuestions,
    required this.relevantExperience,
    required this.supportingDocuments,
    this.coverLetter,
    this.jobAlertPreferences,
    required this.applicationSource,
    required this.employerActions,
    this.job,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['_id'] ?? json['id'] ?? '',
      jobId: json['jobId'] is String ? json['jobId'] : json['jobId']['_id'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? 'pending',
      appliedAt: DateTime.tryParse(json['appliedAt'] ?? '') ?? DateTime.now(),
      lastUpdated: DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
      contactInfo: ContactInfo.fromJson(json['contactInfo'] ?? {}),
      resume: Resume.fromJson(json['resume'] ?? {}),
      employerQuestions: (json['employerQuestions'] as List<dynamic>? ?? [])
          .map((e) => EmployerQuestion.fromJson(e))
          .toList(),
      relevantExperience: (json['relevantExperience'] as List<dynamic>? ?? [])
          .map((e) => RelevantExperience.fromJson(e))
          .toList(),
      supportingDocuments: (json['supportingDocuments'] as List<dynamic>? ?? [])
          .map((e) => SupportingDocument.fromJson(e))
          .toList(),
      coverLetter: json['coverLetter'],
      jobAlertPreferences: json['jobAlertPreferences'] != null
          ? JobAlertPreferences.fromJson(json['jobAlertPreferences'])
          : null,
      applicationSource: json['applicationSource'] ?? 'mobile',
      employerActions: (json['employerActions'] as List<dynamic>? ?? [])
          .map((e) => EmployerAction.fromJson(e))
          .toList(),
      job: json['jobId'] is Map ? Job.fromJson(json['jobId']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'userId': userId,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'contactInfo': contactInfo.toJson(),
      'resume': resume.toJson(),
      'employerQuestions': employerQuestions.map((e) => e.toJson()).toList(),
      'relevantExperience': relevantExperience.map((e) => e.toJson()).toList(),
      'supportingDocuments': supportingDocuments.map((e) => e.toJson()).toList(),
      'coverLetter': coverLetter,
      'jobAlertPreferences': jobAlertPreferences?.toJson(),
      'applicationSource': applicationSource,
      'employerActions': employerActions.map((e) => e.toJson()).toList(),
      'job': job?.toJson(),
    };
  }
}

class ContactInfo {
  final String fullName;
  final String email;
  final String phone;
  final Location? location;

  ContactInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    this.location,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'location': location?.toJson(),
    };
  }
}

class Resume {
  final String fileName;
  final String fileUrl;
  final DateTime uploadedAt;

  Resume({
    required this.fileName,
    required this.fileUrl,
    required this.uploadedAt,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      uploadedAt: DateTime.tryParse(json['uploadedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

class EmployerQuestion {
  final String id;
  final String question;
  final dynamic answer;
  final String questionType;

  EmployerQuestion({
    required this.id,
    required this.question,
    required this.answer,
    required this.questionType,
  });

  factory EmployerQuestion.fromJson(Map<String, dynamic> json) {
    return EmployerQuestion(
      id: json['_id'] ?? json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'],
      questionType: json['questionType'] ?? 'text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'questionType': questionType,
    };
  }
}

class RelevantExperience {
  final String id;
  final String jobTitle;
  final String company;
  final String duration;
  final String description;

  RelevantExperience({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.duration,
    required this.description,
  });

  factory RelevantExperience.fromJson(Map<String, dynamic> json) {
    return RelevantExperience(
      id: json['_id'] ?? json['id'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'duration': duration,
      'description': description,
    };
  }
}

class SupportingDocument {
  final String fileName;
  final String fileUrl;
  final String documentType;

  SupportingDocument({
    required this.fileName,
    required this.fileUrl,
    required this.documentType,
  });

  factory SupportingDocument.fromJson(Map<String, dynamic> json) {
    return SupportingDocument(
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      documentType: json['documentType'] ?? 'other',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'documentType': documentType,
    };
  }
}

class JobAlertPreferences {
  final bool emailUpdates;
  final String location;
  final String jobTitle;

  JobAlertPreferences({
    required this.emailUpdates,
    required this.location,
    required this.jobTitle,
  });

  factory JobAlertPreferences.fromJson(Map<String, dynamic> json) {
    return JobAlertPreferences(
      emailUpdates: json['emailUpdates'] ?? false,
      location: json['location'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailUpdates': emailUpdates,
      'location': location,
      'jobTitle': jobTitle,
    };
  }
}

class EmployerAction {
  final String id;
  final String action;
  final DateTime actionDate;
  final String notes;

  EmployerAction({
    required this.id,
    required this.action,
    required this.actionDate,
    required this.notes,
  });

  factory EmployerAction.fromJson(Map<String, dynamic> json) {
    return EmployerAction(
      id: json['_id'] ?? json['id'] ?? '',
      action: json['action'] ?? '',
      actionDate: DateTime.tryParse(json['actionDate'] ?? '') ?? DateTime.now(),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'actionDate': actionDate.toIso8601String(),
      'notes': notes,
    };
  }
}

class JobApplicationList {
  final List<JobApplication> applications;
  final Pagination pagination;
  final ApplicationSummary summary;

  JobApplicationList({
    required this.applications,
    required this.pagination,
    required this.summary,
  });

  factory JobApplicationList.fromJson(Map<String, dynamic> json) {
    return JobApplicationList(
      applications: (json['applications'] as List<dynamic>? ?? [])
          .map((e) => JobApplication.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      summary: ApplicationSummary.fromJson(json['summary'] ?? {}),
    );
  }
}

class ApplicationSummary {
  final int total;
  final Map<String, int> statusCounts;

  ApplicationSummary({
    required this.total,
    required this.statusCounts,
  });

  factory ApplicationSummary.fromJson(Map<String, dynamic> json) {
    return ApplicationSummary(
      total: json['total'] ?? 0,
      statusCounts: Map<String, int>.from(json['statusCounts'] ?? {}),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? json['currentPage'] ?? 1,
      totalPages: json['total_pages'] ?? json['totalPages'] ?? 1,
      totalItems: json['total_applications'] ?? json['total_jobs'] ?? json['totalItems'] ?? 0,
      perPage: json['per_page'] ?? json['perPage'] ?? json['limit'] ?? 20,
      hasNext: json['has_next'] ?? json['hasNext'] ?? false,
      hasPrev: json['has_prev'] ?? json['hasPrev'] ?? false,
    );
  }
}

class SavedJob {
  final String id;
  final String jobId;
  final String userId;
  final DateTime savedAt;
  final Job? job;

  SavedJob({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.savedAt,
    this.job,
  });

  factory SavedJob.fromJson(Map<String, dynamic> json) {
    return SavedJob(
      id: json['_id'] ?? json['id'] ?? '',
      jobId: json['jobId'] ?? json['job']?['_id'] ?? '',
      userId: json['userId'] ?? '',
      savedAt: DateTime.parse(json['savedAt']),
      job: json['job'] != null ? Job.fromJson(json['job']) : null,
    );
  }
}