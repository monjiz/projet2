import 'package:flutter/material.dart';
import 'package:auth_firebase/data/models/user.dart';
import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirm_passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole;
  final UserRepository _userRepository = UserRepository();

  final List<String> roles = ['Client', 'Travailleur', 'Administrateur'];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  final fullName = _nameController.text.trim();
  final password = _passwordController.text.trim();
   final ConfirmPassword = _passwordController.text.trim();
  final email = _emailController.text.trim();

  if (fullName.isEmpty || email.isEmpty || _selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veuillez remplir tous les champs.")),
    );
    return;
  }

  final user = UserModel(
    fullName: fullName,
    email: email,
    type: _selectedRole!,
    id: '', // ID généré côté backend
  );

  setState(() => _isLoading = true);

  try {
    // ✅ Récupération du token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print("DEBUG: token récupéré = $token");

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utilisateur non authentifié.")),
      );
      setState(() => _isLoading = false);
      return;
    }

    // ✅ Envoi de l’utilisateur avec le token au backend
    await _userRepository.addUser(user, token);
    print("Utilisateur ajouté avec succès");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Utilisateur ajouté avec succès.")),
    );

    Navigator.pop(context);
  } catch (e, stacktrace) {
    print("Erreur lors de l'ajout utilisateur : $e");
    print(stacktrace);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur : $e")),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un utilisateur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                hintText: 'Ex. Jean Dupont',
                border: OutlineInputBorder(),
              ),
            ),
           
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'exemple@mail.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
               TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: '',
                border: OutlineInputBorder(),
              ),
            ),
               TextField(
              controller: _confirm_passwordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: '',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: roles
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
              decoration: const InputDecoration(
                labelText: "Rôle",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ajouter',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
