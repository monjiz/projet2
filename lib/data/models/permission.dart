class Permission {
  final String id;
  final String name;

  Permission({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
