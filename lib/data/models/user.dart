class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String type;
  final String? password; // nullable

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.type,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      type: json['type'] ?? 'Client',
      password: json['password'], // ici facultatif selon besoin
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'type': type,
    };

    if (password != null) {
      data['password'] = password;
    }

    return data;
  }
}
