class ProjectModel {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final String status;
  final String approvmentStatus;
  final bool isPublished;
  final String category;
  final String technologies;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
    required this.approvmentStatus,
    required this.isPublished,
    required this.category,
    required this.technologies,
  });

  // Convert JSON to ProjectModel
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deadline: DateTime.parse(json['deadline']),
      status: json['status'] ?? '',
      approvmentStatus: json['approvmentStatus'] ?? '',
      isPublished: json['isPublished'] ?? false,
      category: json['category'] ?? '',
      technologies: json['technologies'] ?? '',
    );
  }

  // Convert ProjectModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'status': status,
      'approvmentStatus': approvmentStatus,
      'isPublished': isPublished,
      'category': category,
      'technologies': technologies,
    };
  }
}
