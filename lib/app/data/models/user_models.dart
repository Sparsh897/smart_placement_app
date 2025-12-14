class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final Location? location;
  final Profile? profile;
  final Preferences? preferences;
  final List<WorkExperience>? workExperience;
  final List<Education>? education;
  final List<Skill>? skills;
  final List<Certification>? certifications;
  final String? loginType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.location,
    this.profile,
    this.preferences,
    this.workExperience,
    this.education,
    this.skills,
    this.certifications,
    this.loginType,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      photoUrl: json['photoUrl'] ?? json['profilePicture'],
      location: json['location'] != null 
          ? Location.fromJson(json['location']) 
          : null,
      profile: json['profile'] != null 
          ? Profile.fromJson(json['profile']) 
          : null,
      preferences: json['preferences'] != null 
          ? Preferences.fromJson(json['preferences']) 
          : null,
      workExperience: json['workExperience'] != null
          ? (json['workExperience'] as List)
              .map((e) => WorkExperience.fromJson(e))
              .toList()
          : null,
      education: json['education'] != null
          ? (json['education'] as List)
              .map((e) => Education.fromJson(e))
              .toList()
          : null,
      skills: json['skills'] != null
          ? (json['skills'] as List)
              .map((e) => Skill.fromJson(e))
              .toList()
          : null,
      certifications: json['certifications'] != null
          ? (json['certifications'] as List)
              .map((e) => Certification.fromJson(e))
              .toList()
          : null,
      loginType: json['loginType'],
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
      if (phone != null) 'phone': phone,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (location != null) 'location': location!.toJson(),
      if (profile != null) 'profile': profile!.toJson(),
      if (preferences != null) 'preferences': preferences!.toJson(),
      if (loginType != null) 'loginType': loginType,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class Location {
  final String? city;
  final String? state;
  final String? country;

  Location({this.city, this.state, this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
    };
  }
}

class Profile {
  final String? educationLevel;
  final String? course;
  final String? specialization;
  final String? summary;
  final int? currentSalary;
  final bool? visibility;
  final String? resumeUrl;

  Profile({
    this.educationLevel,
    this.course,
    this.specialization,
    this.summary,
    this.currentSalary,
    this.visibility,
    this.resumeUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    print('👤 [PROFILE] Parsing profile data: $json');
    print('👤 [PROFILE] Resume URL found: ${json['resumeUrl']}');
    return Profile(
      educationLevel: json['educationLevel'],
      course: json['course'],
      specialization: json['specialization'],
      summary: json['summary'],
      currentSalary: json['currentSalary'],
      visibility: json['visibility'],
      resumeUrl: json['resumeUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (educationLevel != null) 'educationLevel': educationLevel,
      if (course != null) 'course': course,
      if (specialization != null) 'specialization': specialization,
      if (summary != null) 'summary': summary,
      if (currentSalary != null) 'currentSalary': currentSalary,
      if (visibility != null) 'visibility': visibility,
      if (resumeUrl != null) 'resumeUrl': resumeUrl,
    };
  }
}

class Preferences {
  final List<String>? desiredJobTitles;
  final List<String>? jobTypes;
  final WorkSchedule? workSchedule;
  final int? minimumSalary;
  final List<String>? preferredLocations;
  final bool? remoteWork;

  Preferences({
    this.desiredJobTitles,
    this.jobTypes,
    this.workSchedule,
    this.minimumSalary,
    this.preferredLocations,
    this.remoteWork,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      desiredJobTitles: json['desiredJobTitles'] != null
          ? List<String>.from(json['desiredJobTitles'])
          : null,
      jobTypes: json['jobTypes'] != null
          ? List<String>.from(json['jobTypes'])
          : null,
      workSchedule: json['workSchedule'] != null
          ? WorkSchedule.fromJson(json['workSchedule'])
          : null,
      minimumSalary: json['minimumSalary'],
      preferredLocations: json['preferredLocations'] != null
          ? List<String>.from(json['preferredLocations'])
          : null,
      remoteWork: json['remoteWork'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (desiredJobTitles != null) 'desiredJobTitles': desiredJobTitles,
      if (jobTypes != null) 'jobTypes': jobTypes,
      if (workSchedule != null) 'workSchedule': workSchedule!.toJson(),
      if (minimumSalary != null) 'minimumSalary': minimumSalary,
      if (preferredLocations != null) 'preferredLocations': preferredLocations,
      if (remoteWork != null) 'remoteWork': remoteWork,
    };
  }
}

class WorkSchedule {
  final List<String>? days;
  final List<String>? shifts;
  final List<String>? schedules;

  WorkSchedule({this.days, this.shifts, this.schedules});

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      days: json['days'] != null ? List<String>.from(json['days']) : null,
      shifts: json['shifts'] != null ? List<String>.from(json['shifts']) : null,
      schedules: json['schedules'] != null ? List<String>.from(json['schedules']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (days != null) 'days': days,
      if (shifts != null) 'shifts': shifts,
      if (schedules != null) 'schedules': schedules,
    };
  }
}

class WorkExperience {
  final String? id;
  final String jobTitle;
  final String company;
  final String location;
  final String employmentType;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? noticePeriod;
  final String? description;

  WorkExperience({
    this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    this.noticePeriod,
    this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['_id'] ?? json['id'],
      jobTitle: json['jobTitle'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      employmentType: json['employmentType'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      noticePeriod: json['noticePeriod'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'employmentType': employmentType,
      'startDate': startDate.toIso8601String().split('T')[0],
      if (endDate != null) 'endDate': endDate!.toIso8601String().split('T')[0],
      'isCurrent': isCurrent,
      if (noticePeriod != null) 'noticePeriod': noticePeriod,
      if (description != null) 'description': description,
    };
  }
}

class Education {
  final String? id;
  final String degree;
  final String institution;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? grade;

  Education({
    this.id,
    required this.degree,
    required this.institution,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrent,
    this.grade,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'] ?? json['id'],
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      location: json['location'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'location': location,
      'startDate': startDate.toIso8601String().split('T')[0],
      if (endDate != null) 'endDate': endDate!.toIso8601String().split('T')[0],
      'isCurrent': isCurrent,
      if (grade != null) 'grade': grade,
    };
  }
}

class Skill {
  final String? id;
  final String name;
  final String proficiency;
  final String source;

  Skill({
    this.id,
    required this.name,
    required this.proficiency,
    required this.source,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      proficiency: json['proficiency'] ?? '',
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'proficiency': proficiency,
      'source': source,
    };
  }
}

class Certification {
  final String? id;
  final String name;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialId;
  final String? url;

  Certification({
    this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.url,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      issuer: json['issuer'] ?? '',
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      credentialId: json['credentialId'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate.toIso8601String().split('T')[0],
      if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String().split('T')[0],
      if (credentialId != null) 'credentialId': credentialId,
      if (url != null) 'url': url,
    };
  }
}

class AuthData {
  final User user;
  final AuthTokens tokens;

  AuthData({required this.user, required this.tokens});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: User.fromJson(json['user']),
      tokens: AuthTokens.fromJson(json['tokens']),
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String? refreshToken;

  AuthTokens({required this.accessToken, this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }
}

class GoogleUserInfo {
  final String email;
  final String name;
  final String? picture;
  final String sub;

  GoogleUserInfo({
    required this.email,
    required this.name,
    this.picture,
    required this.sub,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      if (picture != null) 'picture': picture,
      'sub': sub,
    };
  }
}