import 'dart:developer';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/widgets/button.dart';
import 'package:auth_firebase/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _selectedRole = 'Client';

  final List<String> roles = ['Client', 'Travailleur', 'Administrateur'];

  @override
  void dispose() {
    _name.dispose();
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

  Future<void> _signup() async {
    final name = _name.text.trim();
    final email = _email.text.trim().toLowerCase();
    final password = _password.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showToast("Veuillez remplir tous les champs.");
      return;
    }

    if (!isValidEmail(email)) {
      showToast("Adresse email invalide.");
      return;
    }

    if (password.length < 6) {
      showToast("Mot de passe trop faible.");
      return;
    }

    try {
      final user = await _auth.createUserWithEmailPasswordAndRole(
        name, email, password, _selectedRole,
      );
      log("Utilisateur créé avec succès : ${user.uid}");
      showToast("Inscription réussie !");
      
      // Affiche un message de confirmation après l'inscription
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Compte créé'),
            content: const Text('Votre compte a été créé avec succès !'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();  // Ferme la boîte de dialogue
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showToast("Erreur : ${e.toString()}");
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
            const Text("Inscription", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 40),
            CustomTextField(label: "Nom", hint: "Entrez votre nom", controller: _name),
            const SizedBox(height: 20),
            CustomTextField(label: "Email", hint: "Entrez votre email", controller: _email),
            const SizedBox(height: 20),
            CustomTextField(label: "Mot de passe", hint: "Entrez le mot de passe", controller: _password, isPassword: true),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
              onChanged: (value) => setState(() => _selectedRole = value!),
              decoration: const InputDecoration(labelText: "Rôle"),
            ),
            const SizedBox(height: 30),
            CustomButton(label: "S'inscrire", onPressed: _signup),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Déjà un compte ? "),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text("Connexion", style: TextStyle(color: Colors.red)),
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