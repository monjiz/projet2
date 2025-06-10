import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedStatus;

  final List<String> statusOptions = ['En attente', 'En cours', 'Terminé'];

  void _submit() {
    final title = _titleController.text.trim();

    if (title.isEmpty || _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    // Retourner les données à la page précédente
    Navigator.pop(context, {
      "title": title,
      "status": _selectedStatus!,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Projet"),
        backgroundColor: const Color.fromARGB(255, 191, 106, 219),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Titre du projet",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: "Statut du projet",
                border: OutlineInputBorder(),
              ),
              items: statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text("Ajouter le projet"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 191, 106, 219),
              ),
            )
          ],
        ),
      ),
    );
  }
}
