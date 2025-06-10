class Role {
  final String id;
  final String name;
  final String? description;
  final List<String> permissions;

  Role({
    required this.id,
    required this.name,
    this.description,
    required this.permissions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description ?? '',
      'permissions': permissions,
    };
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}