class EducationLevel {
  final String name;
  final List<Course> courses;

  EducationLevel({required this.name, required this.courses});

  factory EducationLevel.fromJson(Map<String, dynamic> json) {
    return EducationLevel(
      name: json['name'] ?? '',
      courses: json['courses'] != null
          ? (json['courses'] as List).map((e) => Course.fromJson(e)).toList()
          : [],
    );
  }
}

class Course {
  final String name;
  final List<Specialization> specializations;

  Course({required this.name, required this.specializations});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'] ?? '',
      specializations: json['specializations'] != null
          ? (json['specializations'] as List)
              .map((e) => Specialization.fromJson(e))
              .toList()
          : [],
    );
  }
}

class Specialization {
  final String name;
  final List<Domain> domains;

  Specialization({required this.name, required this.domains});

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      name: json['name'] ?? '',
      domains: json['domains'] != null
          ? (json['domains'] as List).map((e) => Domain.fromJson(e)).toList()
          : [],
    );
  }
}

class Domain {
  final String name;

  Domain({required this.name});

  factory Domain.fromJson(Map<String, dynamic> json) {
    return Domain(
      name: json['name'] ?? json.toString(),
    );
  }
}

class EducationHierarchy {
  final List<EducationLevel> educationLevels;

  EducationHierarchy({required this.educationLevels});

  factory EducationHierarchy.fromJson(Map<String, dynamic> json) {
    return EducationHierarchy(
      educationLevels: json['educationLevels'] != null
          ? (json['educationLevels'] as List)
              .map((e) => EducationLevel.fromJson(e))
              .toList()
          : [],
    );
  }
}