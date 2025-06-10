import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // =================== REGISTER ===================
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String type,
  }) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.trim().isEmpty ||
        type.trim().isEmpty) {
      throw Exception('Tous les champs sont requis.');
    }

    if (!_emailRegex.hasMatch(email)) {
      throw Exception('Adresse email invalide.');
    }

    if (password.length < 6) {
      throw Exception('Le mot de passe doit contenir au moins 6 caractères.');
    }

    if (password != confirmPassword) {
      throw Exception('Les mots de passe ne correspondent pas.');
    }

    late final String endpoint;
    switch (type.toLowerCase()) {
      case 'administrateur':
        endpoint = '/auth/register-admin';
        break;
      case 'travailleur':
        endpoint = '/auth/register-worker';
        break;
      case 'client':
        endpoint = '/auth/register-client';
        break;
      default:
        throw Exception('Rôle invalide.');
    }

    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      log('Register response status code: ${response.statusCode}');
      log('Register response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final authData = data['data'] as Map<String, dynamic>? ?? {};
        final prefs = await SharedPreferences.getInstance();
        if (authData['accessToken'] != null) {
          await prefs.setString('auth_token', authData['accessToken']);
          log('Token sauvegardé : ${authData['accessToken']}');
        }
        if (authData['user']?['id'] != null) {
          await prefs.setString('user_id', authData['user']['id']);
          log('User ID sauvegardé : ${authData['user']['id']}');
        }
        return data;
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = error['error'] ?? error['message'] ?? 'Erreur inconnue';
        log('Erreur d\'inscription : $errorMessage');
        throw Exception(errorMessage);
      }
    } on SocketException {
      log('Erreur réseau dans registerUser');
      throw Exception('Erreur réseau. Vérifiez votre connexion Internet.');
    } on FormatException {
      log('Format JSON invalide dans registerUser');
      throw Exception('Réponse du serveur invalide.');
    } catch (e) {
      log('Erreur inattendue dans registerUser($type) : $e');
      throw Exception('Erreur de connexion au serveur. Vérifiez votre connexion Internet.');
    }
  }

  // =================== LOGIN ===================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email et mot de passe requis.');
    }

    if (!_emailRegex.hasMatch(email)) {
      throw Exception('Adresse email invalide.');
    }

    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      log('Login response status code: ${response.statusCode}');
      log('Login response body: ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final prefs = await SharedPreferences.getInstance();
        final authData = data['data'] as Map<String, dynamic>? ?? {};
        final token = authData['accessToken'];
        final uid = authData['user']?['id'];

        if (token != null) {
          await prefs.setString('auth_token', token);
          log('Token sauvegardé : $token');
        }
        if (uid != null) {
          await prefs.setString('user_id', uid);
          log('User ID sauvegardé : $uid');
        }
        return data;
      } else {
        final errorMessage = data['error'] ?? data['message'] ?? 'Email ou mot de passe incorrect.';
        log('Erreur de connexion : $errorMessage');
        throw Exception(errorMessage);
      }
    } on SocketException {
      log('Erreur réseau lors de la connexion');
      throw Exception('Erreur réseau. Vérifiez votre connexion Internet.');
    } on FormatException {
      log('Format JSON invalide lors de la connexion');
      throw Exception('Données renvoyées par le serveur invalides.');
    } catch (e) {
      log('Erreur inattendue dans login : $e');
      throw Exception('Erreur de connexion au serveur. Vérifiez votre connexion Internet.');
    }
  }


  // =================== GOOGLE LOGIN ===================





  
Future<Map<String, dynamic>> loginWithGoogle() async {
  // Initialisation de GoogleSignIn avec forceAccountChooser
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    signInOption: SignInOption.standard,
  );

  try {
    // 1. Authentification avec Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Connexion Google annulée');

    // 2. Obtenir les informations d'authentification
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // 3. Vérifier que le token ID est disponible
    if (googleAuth.idToken == null) {
      throw Exception('Token Google ID non disponible');
    }

    // 4. Créer les credentials Firebase
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // 5. Connexion à Firebase
    final userCredential = await _auth.signInWithCredential(credential);
    
    // 6. Obtenir le token Firebase
    final idToken = await userCredential.user?.getIdToken();
    if (idToken == null) throw Exception('Token Firebase invalide');

    // 7. Envoyer le token à votre backend
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'token': idToken,
      }),
    );

    log('Google login response status code: ${response.statusCode}');
    log('Google login response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final authData = data['data'] as Map<String, dynamic>? ?? {};
      final prefs = await SharedPreferences.getInstance();

      if (authData['accessToken'] != null) {
        await prefs.setString('auth_token', authData['accessToken']);
        log('Token sauvegardé : ${authData['accessToken']}');
      }
      if (authData['user']?['id'] != null) {
        await prefs.setString('user_id', authData['user']['id']);
        log('User ID sauvegardé : ${authData['user']['id']}');
      }

      return data;
    } else {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage = error['error'] ?? error['message'] ?? 'Erreur inconnue';
      throw Exception(errorMessage);
    }
  } on SocketException {
    throw Exception('Erreur réseau. Vérifiez votre connexion Internet.');
  } on FormatException {
    throw Exception('Réponse du serveur invalide.');
  } catch (e) {
    throw Exception('Erreur de connexion Google: ${e.toString()}');
  } finally {
    // Optionnel: Déconnexion de GoogleSignIn pour forcer le choix à la prochaine connexion
    await _googleSignIn.signOut();
  }
}

  // =================== FORGOT PASSWORD ===================
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Email requis.');
    }

    if (!_emailRegex.hasMatch(email)) {
      throw Exception('Adresse email invalide.');
    }

    final url = Uri.parse('$baseUrl/auth/forget-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      log('Response status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi de l\'email de réinitialisation.');
      }
    } on SocketException {
      log('Erreur réseau pendant sendPasswordResetEmail');
      throw Exception('Erreur de réseau. Veuillez vérifier votre connexion internet.');
    } on FormatException {
      throw Exception('Réponse invalide du serveur.');
    } catch (e) {
      log('Erreur inattendue dans sendPasswordResetEmail: $e');
      throw Exception('Erreur de connexion au serveur. Vérifiez votre connexion internet.');
    }
  }

  // =================== SET NEW PASSWORD ===================
  Future<void> setNewPassword(String token, String newPassword) async {
    if (newPassword.trim().isEmpty) {
      throw Exception('Nouveau mot de passe requis.');
    }

    if (newPassword.length < 8) {
      throw Exception('Le mot de passe doit comporter au moins 8 caractères.');
    }

    final url = Uri.parse('$baseUrl/auth/set-new-password');

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la mise à jour du mot de passe.');
      }
    } on SocketException {
      log('Erreur réseau pendant setNewPassword');
      throw Exception('Erreur de réseau. Veuillez vérifier votre connexion internet.');
    } on FormatException {
      throw Exception('Réponse invalide du serveur.');
    } catch (e) {
      log('Erreur inattendue dans setNewPassword: $e');
      throw Exception('Erreur de connexion au serveur. Vérifiez votre connexion internet.');
    }
  }

  // =================== SIGN OUT ===================
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('refresh_token');
      await _auth.signOut();
    } catch (e) {
      log('Erreur dans signOut: $e');
      throw Exception('Erreur lors de la déconnexion.');
    }
  }

  // =================== CREATE USER WRAPPER ===================
  Future<Map<String, dynamic>> createUserWithEmailPasswordAndRole({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String type,
  }) async {
    return await registerUser(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      type: type,
    );
  }
}
