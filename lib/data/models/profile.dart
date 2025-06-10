enum UserType { client, worker, admin }

class Profile {
  final String name;
  final String username;
  final String imageUrl;
  final UserType userType;

  Profile({
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.userType,
  });
}
