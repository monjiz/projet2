import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://api.platform.dat.tn/api/v1';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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
        final data = jsonDecode(response.body);
        final authData = data['data'] ?? {};
        final prefs = await SharedPreferences.getInstance();
        if (authData['accessToken'] != null) {
          await prefs.setString('auth_token', authData['accessToken']);
        }
        if (authData['user']?['id'] != null) {
          await prefs.setString('user_id', authData['user']['id']);
        }
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['error'] ?? error['message'] ?? 'Erreur inconnue';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Erreur réseau. Vérifiez votre connexion Internet.');
    } catch (e) {
      throw Exception('Erreur lors de l’inscription : $e');
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
        body: jsonEncode({'email': email, 'password': password}),
      );

      log('Login response status code: ${response.statusCode}');
      log('Login response body: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final prefs = await SharedPreferences.getInstance();
        final authData = data['data'] ?? {};
        if (authData['accessToken'] != null) {
          await prefs.setString('auth_token', authData['accessToken']);
        }
        if (authData['user']?['id'] != null) {
          await prefs.setString('user_id', authData['user']['id']);
        }
        return data;
      } else {
        final errorMessage = data['error'] ?? data['message'] ?? 'Email ou mot de passe incorrect.';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Erreur réseau. Vérifiez votre connexion Internet.');
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // =================== GOOGLE LOGIN ===================
  Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
    required String email,
    String? roleIfNew,
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': idToken,
          if (roleIfNew != null) 'type': roleIfNew,
          'email': email,
          if (name != null) 'name': name,
        }),
      );

      log('Google login response status code: ${response.statusCode}');
      log('Google login response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final authData = data['data'] ?? {};
        final prefs = await SharedPreferences.getInstance();

        if (authData['accessToken'] != null) {
          await prefs.setString('auth_token', authData['accessToken']);
        }
        if (authData['user']?['id'] != null) {
          await prefs.setString('user_id', authData['user']['id']);
        }

        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['error'] ?? error['message'] ?? 'Erreur inconnue';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Erreur réseau. Vérifiez votre connexion Internet.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // =================== FORGOT PASSWORD ===================
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) throw Exception('Email requis.');

    if (!_emailRegex.hasMatch(email)) throw Exception('Adresse email invalide.');

    final url = Uri.parse('$baseUrl/auth/forget-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi de l\'email.');
      }
    } catch (e) {
      throw Exception('Erreur de réinitialisation : $e');
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
    } catch (e) {
      throw Exception('Erreur lors du changement de mot de passe : $e');
    }
  }

  // =================== SIGN OUT ===================
  Future<void> signOut() async {
   
      await _auth.signOut();

      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        await googleSignIn.disconnect();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('refresh_token');

      log('Déconnexion réussie');
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
