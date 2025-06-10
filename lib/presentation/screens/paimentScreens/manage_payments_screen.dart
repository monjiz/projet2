// Dans manage_payments_screen.dart
import 'package:flutter/material.dart';

class ManagePaymentsScreen extends StatelessWidget { // <--- VÉRIFIEZ CE NOM
  const ManagePaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gérer les Paiements"),
        backgroundColor: const Color(0xFF34A853),
      ),
      body: const Center(
        child: Text(
          "Page de Gestion des Paiements",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}