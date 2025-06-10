import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted); // ← Ajout de l'événement Google
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final response = await _authService.login(
        email: event.email,
        password: event.password,
      );

      if (response.containsKey('data') &&
          (response['data']['accessToken'] != null || response['data']['user']['id'] != null)) {
        final type = response['data']['user']['type'] ?? 'client'; // ← Récupère le type
        log("Connexion réussie : Réponse = $response");
        emit(LoginSuccess(type: type)); // ← Transmet le type
      } else {
        log("Échec de la connexion : Clés accessToken ou user.id manquantes dans la réponse.");
        emit(LoginFailure(error: "Échec de la connexion : réponse incomplète."));
      }
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('Erreur réseau')) {
        errorMessage = "Erreur de connexion au serveur. Vérifiez votre connexion Internet.";
      } else if (e.toString().contains('Adresse email invalide')) {
        errorMessage = "Adresse email invalide.";
      } else if (e.toString().contains('Email ou mot de passe incorrect')) {
        errorMessage = "Email ou mot de passe incorrect.";
      } else {
        errorMessage = "Erreur : ${e.toString().replaceAll('Exception: ', '')}";
      }

      log("Erreur lors de la connexion : $e");
      emit(LoginFailure(error: errorMessage));
    }
  }

Future<void> _onGoogleSignInSubmitted(
    GoogleSignInSubmitted event, 
    Emitter<LoginState> emit
) async {
  emit(LoginLoading());

  try {
    final response = await _authService.loginWithGoogle();

    // Vérification plus robuste de la réponse
    if (response.containsKey('data') && 
        response['data'] is Map<String, dynamic> &&
        (response['data']['accessToken'] != null || 
         (response['data']['user'] != null && response['data']['user']['id'] != null))) {
      
      final userType = response['data']['user']?['type']?.toString().toLowerCase() ?? 'client';
      log("Connexion Google réussie. Type d'utilisateur: $userType");
      
      emit(LoginSuccess(type: userType));
    } else {
      log("Réponse incomplète: ${response.toString()}");
      emit(LoginFailure(
          error: "La réponse du serveur est incomplète. Veuillez réessayer."));
    }
  } on Exception catch (e) {
    String errorMessage;
    
    // Gestion plus précise des erreurs
    if (e.toString().contains('Connexion Google annulée')) {
      errorMessage = "Vous avez annulé la connexion avec Google.";
    } else if (e.toString().contains('Erreur réseau')) {
      errorMessage = "Problème de connexion internet. Vérifiez votre réseau.";
    } else if (e.toString().contains('Token') || 
               e.toString().contains('jeton')) {
      errorMessage = "Erreur d'authentification. Veuillez réessayer.";
    } else {
      errorMessage = "Erreur lors de la connexion avec Google: ${e.toString().replaceAll('Exception: ', '')}";
    }
    
    log("Erreur Google Sign-In: ${e.toString()}");
    emit(LoginFailure(error: errorMessage));
  }
}

}
