import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Méthode complète avec nom et rôle
  Future<User> createUserWithEmailPasswordAndRole(
      String name, String email, String password, String role) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ajouter les infos utilisateur dans Firestore
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': Timestamp.now(),
      });

      return cred.user!;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      log("Unexpected Error: $e");
      throw Exception("Une erreur inattendue est survenue.");
    }
  }

  // Obtenir le rôle d'un utilisateur depuis Firestore
  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data()!.containsKey('role')) {
      return doc['role'];
    } else {
      throw Exception("Rôle non trouvé pour cet utilisateur.");
    }
  }

  // Connexion utilisateur
Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
  try {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (cred.user == null) {
      throw Exception("Aucun utilisateur trouvé après la connexion.");
    }
    return cred.user;
  } on FirebaseAuthException catch (e) {
    log("Firebase Auth Error: ${e.code} - ${e.message}");
    rethrow;
  } catch (e) {
    log("Unexpected Error: $e");
    throw Exception("Une erreur inattendue est survenue.");
  }
}

  // Déconnexion
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Signout Error: $e");
      throw Exception("Erreur lors de la déconnexion.");
    }
  }
}