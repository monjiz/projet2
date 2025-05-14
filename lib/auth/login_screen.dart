import 'dart:developer';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/signup_screen.dart';
import 'package:auth_firebase/admin_screen.dart'; // Écran pour les administrateurs
import 'package:auth_firebase/client_screen.dart';
import 'package:auth_firebase/travailleur_screen.dart';
import 'package:auth_firebase/widgets/button.dart';
import 'package:auth_firebase/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import pour FirebaseAuth
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _login() async {
    final email = _email.text.trim().toLowerCase();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showToast("Veuillez remplir tous les champs.");
      return;
    }

    if (!isValidEmail(email)) {
      showToast("Adresse email invalide.");
      return;
    }

    try {
      // Appel à la méthode de connexion
      final user = await _auth.loginUserWithEmailAndPassword(email, password);

      // Vérification que l'utilisateur n'est pas nul
      if (user != null) {
        final role = await _auth.getUserRole(user.uid);
        log("Connexion réussie - UID: ${user.uid}, Role: $role");
        showToast("Bienvenue $role !");

        // Redirection conditionnelle selon le rôle de l'utilisateur
        if (role == "Administrateur") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (role == "Travailleur") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TravailleurScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ClientScreen()),
          );
        }
      } else {
        log("Erreur : Aucun utilisateur connecté");
        showToast("Erreur : Aucun utilisateur connecté");
      }
    } catch (e) {
      log("Erreur de connexion : $e");
      showToast("Erreur de connexion : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Connexion",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            CustomTextField(
              label: "Email",
              hint: "Entrez votre email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "Mot de passe",
              hint: "Entrez votre mot de passe",
              controller: _password,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            CustomButton(label: "Se connecter", onPressed: _login),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Pas encore inscrit ? "),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  child: const Text(
                    "Créer un compte",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}