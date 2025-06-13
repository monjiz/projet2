class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String type;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',               // corrigé ici
      fullName: json['fullName'] ?? 'Nom inconnu',
      email: json['email'] ?? 'Email inconnu',
      type: json['type'] ?? 'Client',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'type': type,
    };
  }
}
