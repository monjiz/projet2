
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted);
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
        final type = response['data']['user']['type'] ?? 'client';
        log("Connexion réussie : Réponse = $response");
        emit(LoginSuccess(type: type));
      } else {
        log("Échec de la connexion : réponse incomplète.");
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

  Future<void> _onGoogleSignInSubmitted(GoogleSignInSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    GoogleSignInAccount? googleUser;

    try {
      // Étape 1 : Connexion Google
      googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) throw Exception('Connexion Google annulée');

      // Étape 2 : Obtenir les informations d'authentification Google
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final email = googleUser.email;

      if (idToken == null || email.isEmpty) {
        throw Exception("Token Google ID ou email non disponible");
      }

      // Étape 3 : Authentification Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseIdToken = await userCredential.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception("Échec de l'authentification Firebase");
      }

      // Étape 4 : Tenter une connexion sans rôle
      try {
        final response = await _authService.loginWithGoogle(
          idToken: firebaseIdToken,
          email: email,
          roleIfNew: null,
          name: googleUser.displayName, // Toujours passer le nom pour éviter les erreurs backend
        );

        final finalType = response['data']?['user']?['type'] ?? 'client';
        log("Connexion Google réussie : Réponse = $response");
        emit(LoginSuccess(type: finalType));
      } catch (e) {
        // Si le backend indique qu'un rôle est requis, afficher le dialogue
        if (e.toString().toLowerCase().contains('rôle requis') ||
            e.toString().toLowerCase().contains('type') ||
            e.toString().toLowerCase().contains('user not found')) {
          final role = await showDialog<String>(
            context: event.context,
            builder: (context) => AlertDialog(
              title: const Text("Sélectionnez un rôle"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Client"),
                    onTap: () => Navigator.pop(context, 'client'),
                  ),
                  ListTile(
                    title: const Text("Travailleur"),
                    onTap: () => Navigator.pop(context, 'worker'),
                  ),
                ],
              ),
            ),
          );

          if (role == null) throw Exception("Rôle requis pour l'inscription.");

          // Réessayer avec le rôle sélectionné
          final response = await _authService.loginWithGoogle(
            idToken: firebaseIdToken,
            email: email,
            roleIfNew: role,
            name: googleUser.displayName,
          );

          final finalType = response['data']?['user']?['type'] ?? 'client';
          log("Inscription Google réussie : Réponse = $response");
          emit(LoginSuccess(type: finalType));
        } else {
          // Propager les autres erreurs
          throw e;
        }
      }
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('Erreur réseau')) {
        errorMessage = "Erreur de connexion au serveur. Vérifiez votre connexion Internet.";
      } else if (e.toString().contains('Connexion Google annulée')) {
        errorMessage = "Connexion Google annulée.";
      } else if (e.toString().contains('Rôle requis')) {
        errorMessage = "Veuillez sélectionner un rôle pour l'inscription.";
      } else if (e.toString().contains('Cet email est déjà utilisé')) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      } else if (e.toString().contains('email non vérifié')) {
        errorMessage = "Votre email n'est pas vérifié. Veuillez vérifier votre email via le lien envoyé par Firebase.";
      } else {
        errorMessage = "Erreur : ${e.toString().replaceAll('Exception: ', '')}";
      }

      log("Erreur lors de la connexion Google : $e");
      emit(LoginFailure(error: errorMessage));
    } finally {
      if (googleUser != null) {
        await GoogleSignIn().signOut();
      }
    }
  }
}
