import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<GoogleSignInSubmitted>(_onGoogleSignInSubmitted);
    on<CheckCurrentUser>(_onCheckCurrentUser);
    on<SignOutRequested>(_onSignOutRequested); // Add this handler
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await _authService.login(
        email: event.email,
        password: event.password,
      );
      if (response.containsKey('data') &&
          (response['data']['accessToken'] != null ||
              response['data']['user']['id'] != null)) {
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
        errorMessage =
            "Erreur de connexion au serveur. Vérifiez votre connexion Internet.";
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
    GoogleSignInSubmitted event, Emitter<LoginState> emit) async {
  emit(LoginLoading());
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  try {
    log("Début de la connexion Google");
    
    // FORCER LA DÉCONNEXION AVANT LA CONNEXION
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      await googleSignIn.disconnect();
    }
    
    // FORCE TOUJOURS L'AFFICHAGE DU SÉLECTEUR
    final googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      log("Sélection du compte annulée par l'utilisateur");
      emit(LoginFailure(
          error: "Vous devez sélectionner un compte Google pour continuer"));
      return;
    }

    log("Obtention des informations d'authentification Google");
    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final email = googleUser.email;

    if (idToken == null || email.isEmpty) {
      log("Token Google ID ou email non disponible");
      throw Exception("Token Google ID ou email non disponible");
    }

    log("Authentification Firebase");
    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final firebaseIdToken = await userCredential.user?.getIdToken();

    if (firebaseIdToken == null) {
      log("Échec de l'authentification Firebase");
      throw Exception("Échec de l'authentification Firebase");
    }

    log("Tentative de connexion sans rôle");
    try {
      final response = await _authService.loginWithGoogle(
        idToken: firebaseIdToken,
        email: email,
        roleIfNew: null,
        name: googleUser.displayName ?? 'Utilisateur',
      );

      final finalType = response['data']?['user']?['type'] ?? 'client';
      log("Connexion Google réussie : Réponse = $response");
      Fluttertoast.showToast(
        msg: 'Connexion Google réussie',
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
      );
      emit(LoginSuccess(type: finalType));
    } catch (e) {
      if (e.toString().contains('User not found') || 
          e.toString().contains('Role required')) {
        log("Utilisateur non trouvé ou rôle manquant, affichage du dialogue");

        if (!event.context.mounted) {
          log("Contexte invalide");
          emit(LoginFailure(error: "Contexte invalide, veuillez réessayer."));
          return;
        }

        final role = await showDialog<String>(
          context: event.context,
          barrierDismissible: false,
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

        if (role == null) {
          log("Aucun rôle sélectionné");
          emit(LoginFailure(error: "Vous devez sélectionner un rôle pour continuer"));
          return;
        }

        log("Tentative d'inscription avec le rôle : $role");
        final response = await _authService.loginWithGoogle(
          idToken: firebaseIdToken,
          email: email,
          roleIfNew: role,
          name: googleUser.displayName ?? 'Utilisateur',
        );

        final finalType = response['data']?['user']?['type'] ?? 'client';
        log("Inscription Google réussie : Réponse = $response");
        Fluttertoast.showToast(
          msg: 'Connexion Google réussie',
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
        );
        emit(LoginSuccess(type: finalType));
      } else {
        log("Erreur lors de la connexion Google : $e");
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
  }
}

  Future<void> _onCheckCurrentUser(
      CheckCurrentUser event, Emitter<LoginState> emit) async {
    try {
      log("Vérification de l'utilisateur actuel");
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken == null) {
          log("ID Token introuvable");
          emit(LoginFailure(error: "ID Token introuvable"));
          return;
        }
        final response = await _authService.loginWithGoogle(
          idToken: idToken,
          email: user.email ?? '',
          name: user.displayName ?? 'Utilisateur',
          roleIfNew: null,
        );
        final finalType = response['data']?['user']?['type'] ?? 'client';
        log("Utilisateur actuel connecté : type = $finalType");
        emit(LoginSuccess(type: finalType));
      } else {
        log("Aucun utilisateur actuel connecté");
        emit(LoginInitial());
      }
    } catch (e) {
      log("Erreur lors de la vérification de l'utilisateur : $e");
      emit(
          LoginFailure(error: 'Erreur lors de la vérification de l\'utilisateur : $e'));
    }
  }

Future<void> _onSignOutRequested(
    SignOutRequested event, Emitter<LoginState> emit) async {

    // Appel à la déconnexion technique
    await _authService.signOut();
    
    // Réinitialisation de l'état
    emit(LoginInitial());
    
    log('Déconnexion complète réussie');
  
}
}