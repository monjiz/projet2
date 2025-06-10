import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:auth_firebase/auth/auth_service.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService _authService;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
);

  SignupBloc({required AuthService authService})
      : _authService = authService,
        super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
 //   on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted);
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(SignupLoading());

    try {
      final response = await _authService.createUserWithEmailPasswordAndRole(
        name: event.name,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        type: event.role,
      );

      final user = response['user'];
      final token = response['accessToken'];

      if (user != null && user['id'] != null && token != null) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(
          error: "Échec de l'inscription : données utilisateur incomplètes.",
        ));
      }
    } catch (e) {
      String errorMessage;

      if (e.toString().contains('Erreur réseau')) {
        errorMessage = "Erreur de connexion au serveur. Vérifiez votre connexion Internet.";
      } else if (e.toString().contains('Adresse email invalide')) {
        errorMessage = "Adresse email invalide.";
      } else if (e.toString().contains('Les mots de passe ne correspondent pas')) {
        errorMessage = "Les mots de passe ne correspondent pas.";
      } else if (e.toString().contains('Le mot de passe doit contenir au moins')) {
        errorMessage = "Le mot de passe doit contenir au moins 6 caractères.";
      } else if (e.toString().contains('Rôle invalide')) {
        errorMessage = "Rôle invalide.";
      } else {
        errorMessage = "Erreur : ${e.toString().replaceAll('Exception: ', '')}";
      }

      log("Erreur lors de l'inscription : $e");
      emit(SignupFailure(error: errorMessage));
    }
  }

  /*Future<void> _onGoogleSignInSubmitted(
    GoogleSignInSubmitted event, Emitter<SignupState> emit) async {
  emit(SignupLoading());

  try {
    // 1. Connexion avec Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      emit(SignupFailure(error: "Connexion Google annulée."));
      return;
    }

    // 2. Authentification avec Firebase
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // 3. Récupération du token Firebase
    final String? firebaseIdToken = await userCredential.user?.getIdToken();

    // 4. Vérification du token
    if (firebaseIdToken == null || firebaseIdToken is! String || firebaseIdToken.trim().isEmpty) {
      emit(SignupFailure(
        error: "Échec de la connexion Google : Token Firebase invalide.",
      ));
      return;
    }

    log("[log] Firebase ID Token : $firebaseIdToken");

    // 5. Appel au backend avec le token
    final response = await _authService.loginWithGoogle(firebaseIdToken);

    // 6. Traitement de la réponse
    final user = response['user'];
    final token = response['accessToken'];

    if (user != null && user['id'] != null && token != null) {
      log("Connexion Google réussie : Réponse = $response");
      emit(SignupSuccess());
    } else {
      log("Échec de la connexion Google : réponse incomplète.");
      emit(SignupFailure(
        error: "Échec de la connexion Google : réponse incomplète.",
      ));
    }
  } catch (e) {
    // 7. Gestion des erreurs
    String errorMessage;

    if (e.toString().contains('Erreur réseau')) {
      errorMessage = "Erreur de connexion au serveur. Vérifiez votre connexion Internet.";
    } else {
      errorMessage = "Erreur Google : ${e.toString().replaceAll('Exception: ', '')}";
    }

    log("Erreur lors de la connexion Google : $e");
    emit(SignupFailure(error: errorMessage));
  }
}

  @override
  Future<void> close() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // Ignorer les erreurs de déconnexion
    }
    return super.close();
  }*/
}
