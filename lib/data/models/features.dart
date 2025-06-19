// lib/data/models/features.dart

class Features {
  final int projectLimit;
  final String taskRecommendations;
  final String workerRecommendations;
  final List<String> analytics;
  final int teamCollaboration;
  final bool apiAccess;
  final String support;
  final bool customBranding;
  final int jobPostLimit;
  final int cvViewLimit;
  final int cvUploadLimit;
  final int jobApplicationLimit;

  Features({
    required this.projectLimit,
    required this.taskRecommendations,
    required this.workerRecommendations,
    required this.analytics,
    required this.teamCollaboration,
    required this.apiAccess,
    required this.support,
    required this.customBranding,
    required this.jobPostLimit,
    required this.cvViewLimit,
    required this.cvUploadLimit,
    required this.jobApplicationLimit,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    // Lecture défensive des entiers
    int readInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Lecture défensive des booléens
    bool readBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is int) return value != 0;
      return false;
    }

    // Lecture défensive des strings
    String readString(dynamic value) => value?.toString() ?? '';

    // Lecture défensive des listes de chaînes
    List<String> readStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e?.toString() ?? '').toList();
      }
      return [];
    }

    return Features(
      projectLimit: readInt(json['projectLimit']),
      taskRecommendations: readString(json['taskRecommendations']),
      workerRecommendations: readString(json['workerRecommendations']),
      analytics: readStringList(json['analytics']),
      teamCollaboration: readInt(json['teamCollaboration']),
      apiAccess: readBool(json['apiAccess']),
      support: readString(json['support']),
      customBranding: readBool(json['customBranding']),
      jobPostLimit: readInt(json['jobPostLimit']),
      cvViewLimit: readInt(json['cvViewLimit']),
      cvUploadLimit: readInt(json['cvUploadLimit']),
      jobApplicationLimit: readInt(json['jobApplicationLimit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectLimit': projectLimit,
      'taskRecommendations': taskRecommendations,
      'workerRecommendations': workerRecommendations,
      'analytics': analytics,
      'teamCollaboration': teamCollaboration,
      'apiAccess': apiAccess,
      'support': support,
      'customBranding': customBranding,
      'jobPostLimit': jobPostLimit,
      'cvViewLimit': cvViewLimit,
      'cvUploadLimit': cvUploadLimit,
      'jobApplicationLimit': jobApplicationLimit,
    };
  }
}
