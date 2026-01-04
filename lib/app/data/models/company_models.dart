class Company {
  final String id;
  final String name;
  final String email;
  final String? description;
  final String? website;
  final String? industry;
  final String? size;
  final int? founded;
  final String? logo;
  final ContactInfo? contactInfo;
  final HrContact? hrContact;
  final bool isVerified;
  final bool isActive;
  final int totalJobsPosted;
  final int activeJobs;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.email,
    this.description,
    this.website,
    this.industry,
    this.size,
    this.founded,
    this.logo,
    this.contactInfo,
    this.hrContact,
    required this.isVerified,
    required this.isActive,
    required this.totalJobsPosted,
    required this.activeJobs,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      description: json['description'],
      website: json['website'],
      industry: json['industry'],
      size: json['size'],
      founded: json['founded'],
      logo: json['logo'],
      contactInfo: json['contactInfo'] != null 
          ? ContactInfo.fromJson(json['contactInfo']) 
          : null,
      hrContact: json['hrContact'] != null 
          ? HrContact.fromJson(json['hrContact']) 
          : null,
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      totalJobsPosted: json['totalJobsPosted'] ?? 0,
      activeJobs: json['activeJobs'] ?? 0,
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin']) 
          : null,
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
      '_id': id,
      'name': name,
      'email': email,
      if (description != null) 'description': description,
      if (website != null) 'website': website,
      if (industry != null) 'industry': industry,
      if (size != null) 'size': size,
      if (founded != null) 'founded': founded,
      if (logo != null) 'logo': logo,
      if (contactInfo != null) 'contactInfo': contactInfo!.toJson(),
      if (hrContact != null) 'hrContact': hrContact!.toJson(),
      'isVerified': isVerified,
      'isActive': isActive,
      'totalJobsPosted': totalJobsPosted,
      'activeJobs': activeJobs,
      if (lastLogin != null) 'lastLogin': lastLogin!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Company copyWith({
    String? id,
    String? name,
    String? email,
    String? description,
    String? website,
    String? industry,
    String? size,
    int? founded,
    String? logo,
    ContactInfo? contactInfo,
    HrContact? hrContact,
    bool? isVerified,
    bool? isActive,
    int? totalJobsPosted,
    int? activeJobs,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      description: description ?? this.description,
      website: website ?? this.website,
      industry: industry ?? this.industry,
      size: size ?? this.size,
      founded: founded ?? this.founded,
      logo: logo ?? this.logo,
      contactInfo: contactInfo ?? this.contactInfo,
      hrContact: hrContact ?? this.hrContact,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      totalJobsPosted: totalJobsPosted ?? this.totalJobsPosted,
      activeJobs: activeJobs ?? this.activeJobs,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ContactInfo {
  final String? phone;
  final Address? address;

  ContactInfo({this.phone, this.address});

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'],
      address: json['address'] != null 
          ? Address.fromJson(json['address']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;

  Address({
    this.street,
    this.city,
    this.state,
    this.country,
    this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (pincode != null) 'pincode': pincode,
    };
  }
}

class HrContact {
  final String? name;
  final String? email;
  final String? phone;
  final String? designation;

  HrContact({
    this.name,
    this.email,
    this.phone,
    this.designation,
  });

  factory HrContact.fromJson(Map<String, dynamic> json) {
    return HrContact(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      designation: json['designation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (designation != null) 'designation': designation,
    };
  }
}

class CompanyAuthData {
  final Company company;
  final CompanyTokens tokens;

  CompanyAuthData({required this.company, required this.tokens});

  factory CompanyAuthData.fromJson(Map<String, dynamic> json) {
    try {
      final company = json['company'] != null 
          ? Company.fromJson(json['company'] as Map<String, dynamic>)
          : throw Exception('Company data is null');
      
      final tokens = json['tokens'] != null 
          ? CompanyTokens.fromJson(json['tokens'] as Map<String, dynamic>)
          : CompanyTokens(
              accessToken: '',
              tokenType: 'Bearer',
              expiresIn: '7d',
            );
      
      return CompanyAuthData(company: company, tokens: tokens);
    } catch (e) {
      rethrow;
    }
  }
}

class CompanyTokens {
  final String accessToken;
  final String tokenType;
  final String expiresIn;

  CompanyTokens({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory CompanyTokens.fromJson(Map<String, dynamic> json) {
    return CompanyTokens(
      accessToken: json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? 'Bearer',
      expiresIn: json['expiresIn'] ?? '7d',
    );
  }
}

class CompanyDashboard {
  final DashboardStatistics statistics;
  final DashboardCharts charts;

  CompanyDashboard({
    required this.statistics,
    required this.charts,
  });

  factory CompanyDashboard.fromJson(Map<String, dynamic> json) {
    return CompanyDashboard(
      statistics: json['statistics'] != null 
          ? DashboardStatistics.fromJson(json['statistics'] as Map<String, dynamic>)
          : DashboardStatistics(
              totalJobs: 0,
              activeJobs: 0,
              inactiveJobs: 0,
              recentJobs: 0,
              totalApplications: 0,
              pendingApplications: 0,
              shortlistedApplications: 0,
              hiredApplications: 0,
              recentApplications: 0,
            ),
      charts: json['charts'] != null 
          ? DashboardCharts.fromJson(json['charts'] as Map<String, dynamic>)
          : DashboardCharts(
              jobsByDomain: [],
              jobsByEducation: [],
              applicationsByStatus: [],
            ),
    );
  }
}

class DashboardStatistics {
  final int totalJobs;
  final int activeJobs;
  final int inactiveJobs;
  final int recentJobs;
  final int totalApplications;
  final int pendingApplications;
  final int shortlistedApplications;
  final int hiredApplications;
  final int recentApplications;

  DashboardStatistics({
    required this.totalJobs,
    required this.activeJobs,
    required this.inactiveJobs,
    required this.recentJobs,
    required this.totalApplications,
    required this.pendingApplications,
    required this.shortlistedApplications,
    required this.hiredApplications,
    required this.recentApplications,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      totalJobs: json['totalJobs'] ?? 0,
      activeJobs: json['activeJobs'] ?? 0,
      inactiveJobs: json['inactiveJobs'] ?? 0,
      recentJobs: json['recentJobs'] ?? 0,
      totalApplications: json['totalApplications'] ?? 0,
      pendingApplications: json['pendingApplications'] ?? 0,
      shortlistedApplications: json['shortlistedApplications'] ?? 0,
      hiredApplications: json['hiredApplications'] ?? 0,
      recentApplications: json['recentApplications'] ?? 0,
    );
  }
}

class DashboardCharts {
  final List<ChartData> jobsByDomain;
  final List<ChartData> jobsByEducation;
  final List<ChartData> applicationsByStatus;

  DashboardCharts({
    required this.jobsByDomain,
    required this.jobsByEducation,
    required this.applicationsByStatus,
  });

  factory DashboardCharts.fromJson(Map<String, dynamic> json) {
    return DashboardCharts(
      jobsByDomain: (json['jobsByDomain'] as List? ?? [])
          .where((e) => e != null)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobsByEducation: (json['jobsByEducation'] as List? ?? [])
          .where((e) => e != null)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
      applicationsByStatus: (json['applicationsByStatus'] as List? ?? [])
          .where((e) => e != null)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChartData {
  final String id;
  final int count;

  ChartData({required this.id, required this.count});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      count: (json['count'] ?? 0) is int ? json['count'] ?? 0 : int.tryParse(json['count'].toString()) ?? 0,
    );
  }
}

class CompanyJob {
  final String id;
  final String title;
  final String company;
  final String location;
  final String domain;
  final String salary;
  final String description;
  final String eligibility;
  final String educationLevel;
  final String course;
  final String specialization;
  final List<String> skills;
  final String? applyLink;
  final String companyId;
  final bool isActive;
  final int totalApplications;
  final String postedBy;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CompanyJob({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.domain,
    required this.salary,
    required this.description,
    required this.eligibility,
    required this.educationLevel,
    required this.course,
    required this.specialization,
    required this.skills,
    this.applyLink,
    required this.companyId,
    required this.isActive,
    required this.totalApplications,
    required this.postedBy,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyJob.fromJson(Map<String, dynamic> json) {
    return CompanyJob(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      domain: json['domain'] ?? '',
      salary: json['salary'] ?? '',
      description: json['description'] ?? '',
      eligibility: json['eligibility'] ?? '',
      educationLevel: json['educationLevel'] ?? '',
      course: json['course'] ?? '',
      specialization: json['specialization'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      applyLink: json['applyLink'],
      companyId: json['companyId'] ?? '',
      isActive: json['isActive'] ?? true,
      totalApplications: json['totalApplications'] ?? 0,
      postedBy: json['postedBy'] ?? 'company',
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : null,
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
      'location': location,
      'domain': domain,
      'salary': salary,
      'description': description,
      'eligibility': eligibility,
      'educationLevel': educationLevel,
      'course': course,
      'specialization': specialization,
      'skills': skills,
      if (applyLink != null) 'applyLink': applyLink,
    };
  }
}

class JobApplication {
  final String id;
  final ApplicationUser userId;
  final ApplicationJob jobId;
  final String status;
  final Map<String, dynamic> contactInfo;
  final Map<String, dynamic> resume;
  final String? coverLetter;
  final List<Map<String, dynamic>> employerQuestions;
  final List<Map<String, dynamic>> relevantExperience;
  final List<Map<String, dynamic>> supportingDocuments;
  final List<Map<String, dynamic>> employerActions;
  final DateTime appliedAt;
  final DateTime lastUpdated;

  JobApplication({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.status,
    required this.contactInfo,
    required this.resume,
    this.coverLetter,
    required this.employerQuestions,
    required this.relevantExperience,
    required this.supportingDocuments,
    required this.employerActions,
    required this.appliedAt,
    required this.lastUpdated,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['_id'] ?? json['id'] ?? '',
      userId: ApplicationUser.fromJson(json['userId']),
      jobId: ApplicationJob.fromJson(json['jobId']),
      status: json['status'] ?? 'pending',
      contactInfo: Map<String, dynamic>.from(json['contactInfo'] ?? {}),
      resume: Map<String, dynamic>.from(json['resume'] ?? {}),
      coverLetter: json['coverLetter'],
      employerQuestions: List<Map<String, dynamic>>.from(
          json['employerQuestions'] ?? []),
      relevantExperience: List<Map<String, dynamic>>.from(
          json['relevantExperience'] ?? []),
      supportingDocuments: List<Map<String, dynamic>>.from(
          json['supportingDocuments'] ?? []),
      employerActions: List<Map<String, dynamic>>.from(
          json['employerActions'] ?? []),
      appliedAt: DateTime.parse(json['appliedAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class ApplicationUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePicture;
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? location;
  final List<Map<String, dynamic>>? skills;
  final List<Map<String, dynamic>>? workExperience;
  final List<Map<String, dynamic>>? education;
  final List<Map<String, dynamic>>? certifications;

  ApplicationUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePicture,
    this.profile,
    this.location,
    this.skills,
    this.workExperience,
    this.education,
    this.certifications,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      profile: json['profile'] != null 
          ? Map<String, dynamic>.from(json['profile']) 
          : null,
      location: json['location'] != null 
          ? Map<String, dynamic>.from(json['location']) 
          : null,
      skills: json['skills'] != null 
          ? List<Map<String, dynamic>>.from(json['skills']) 
          : null,
      workExperience: json['workExperience'] != null 
          ? List<Map<String, dynamic>>.from(json['workExperience']) 
          : null,
      education: json['education'] != null 
          ? List<Map<String, dynamic>>.from(json['education']) 
          : null,
      certifications: json['certifications'] != null 
          ? List<Map<String, dynamic>>.from(json['certifications']) 
          : null,
    );
  }
}

class ApplicationJob {
  final String id;
  final String title;
  final String company;
  final String location;
  final String domain;
  final String salary;
  final String? description;
  final String? eligibility;
  final List<String>? skills;

  ApplicationJob({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.domain,
    required this.salary,
    this.description,
    this.eligibility,
    this.skills,
  });

  factory ApplicationJob.fromJson(Map<String, dynamic> json) {
    return ApplicationJob(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      domain: json['domain'] ?? '',
      salary: json['salary'] ?? '',
      description: json['description'],
      eligibility: json['eligibility'],
      skills: json['skills'] != null 
          ? List<String>.from(json['skills']) 
          : null,
    );
  }
}