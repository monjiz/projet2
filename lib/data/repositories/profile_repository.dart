import '../models/profile.dart';

class ProfileRepository {
  Future<Profile> fetchProfile(UserType userType) async {
    // Simulation d'une requête réseau/donnees locales avec un délai
    await Future.delayed(Duration(seconds: 1));

    switch (userType) {
      case UserType.client:
        return Profile(
          name: "Charlotte King",
          username: "@johnkinggraphics",
          imageUrl: 'assets/images/image.png',
          userType: UserType.client,
        );
      case UserType.worker:
        return Profile(
          name: "Worker Bob",
          username: "@workerbob",
          imageUrl: 'assets/images/worker.png',
          userType: UserType.worker,
        );
      case UserType.admin:
        return Profile(
          name: "Admin Alice",
          username: "@adminalice",
          imageUrl: 'assets/images/admin.png',
          userType: UserType.admin,
        );
    }
  }
}
