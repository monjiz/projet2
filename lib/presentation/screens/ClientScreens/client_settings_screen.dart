import 'package:flutter/material.dart';
//import 'package:auth_firebase/widgets/button.dart';

class ClientSettingsScreen extends StatelessWidget {
  const ClientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Préférences",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("Notifications"),
              subtitle: const Text("Activer les notifications push"),
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? "Notifications activées" : "Notifications désactivées")),
                );
              },
              activeColor: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Langue"),
              subtitle: const Text("Français"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Changement de langue non implémenté")),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Compte",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Supprimer le compte", style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Suppression de compte non implémentée")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}