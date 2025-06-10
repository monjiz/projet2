import 'package:auth_firebase/data/models/profile.dart';
import 'package:auth_firebase/data/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Events
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final UserType userType;

  LoadProfile(this.userType);
}

// States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.fetchProfile(event.userType);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError("Erreur lors du chargement du profil"));
      }
    });
  }
}
