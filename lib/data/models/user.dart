class UserModel {
  final String id;
  final String name;
  final String email;
  final String type;
  final String? password;
  final String? confirmPassword;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    this.password,
    this.confirmPassword,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['fullName']?.toString() ??
           json['name']?.toString() ?? '' ,
      email: json['email']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Client',
      password: null,
      confirmPassword: null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name, // Pour POST
      'fullName': name, // Pour PUT/GET si le serveur attend fullName
      'email': email,
      'type': type,
    };
    if (password != null) data['password'] = password;
    if (confirmPassword != null) data['confirmPassword'] = confirmPassword;
    return data;
  }
}
