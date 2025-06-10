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
  //  on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted); // ← Ajout de l'événement Google
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

 /*Future<void> _onGoogleSignInSubmitted(GoogleSignInSubmitted event, Emitter<LoginState> emit) async {
  emit(LoginLoading());

  try {
    // 1. Connexion avec Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
    if (googleUser == null) {
      emit(LoginFailure(error: "Connexion Google annulée."));
      return;
    }

    // 2. Authentification avec Firebase
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null || idToken.trim().isEmpty) {
      emit(LoginFailure(error: "Échec de la connexion Google : Token Firebase invalide."));
      return;
    }

    log("[log] Firebase ID Token : $idToken");

    // 3. Appel au backend avec le token Firebase
    final response = await _authService.loginWithGoogle(idToken);

    // 4. Traitement de la réponse
    if (response.containsKey('accessToken') || response['user']?['id'] != null) {
      final type = response['user']?['type'] ?? 'client';
      log("Connexion Google réussie : Réponse = $response");
      emit(LoginSuccess(type: type));
    } else {
      log("Échec de la connexion Google : réponse incomplète.");
      emit(LoginFailure(error: "Erreur : Authentification Google incomplète."));
    }
  } catch (e) {
    // 5. Gestion des erreurs
    String errorMessage;
    if (e.toString().contains('Erreur réseau')) {
      errorMessage = "Erreur de connexion au serveur. Vérifiez votre connexion Internet.";
    } else {
      errorMessage = "Erreur Google : ${e.toString().replaceAll('Exception: ', '')}";
    }

    log("Erreur Google Sign-In : $e");
    emit(LoginFailure(error: errorMessage));
  }
}*/

}
