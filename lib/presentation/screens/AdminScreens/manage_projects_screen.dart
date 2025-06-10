import 'package:flutter/material.dart';
import 'add_project.dart'; // Assure-toi d’avoir cette page créée

class AdminManageProjectsScreen extends StatefulWidget {
  const AdminManageProjectsScreen({super.key});

  @override
  State<AdminManageProjectsScreen> createState() => _AdminManageProjectsScreenState();
}

class _AdminManageProjectsScreenState extends State<AdminManageProjectsScreen> {
  final List<Map<String, String>> _projects = [
    {"title": "Application Mobile Santé", "status": "En cours"},
    {"title": "Site e-Commerce", "status": "Terminé"},
    {"title": "Application de Réalité Augmentée", "status": "En attente"},
  ];

  Future<void> _goToAddProject() async {
    final Map<String, String>? newProject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProjectScreen()),
    );

    if (newProject != null) {
      setState(() {
        _projects.add(newProject);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gérer les Projets",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 87, 181),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _projects.length,
          itemBuilder: (context, index) {
            final project = _projects[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.work_outline, color: Color.fromARGB(255, 177, 100, 208)),
                title: Text(
                  project["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text("Statut : ${project["status"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 225, 0, 255)),
                      onPressed: () {
                        // Action modifier
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 54, 171, 244)),
                      onPressed: () {
                        setState(() {
                          _projects.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddProject,
        backgroundColor: const Color.fromARGB(255, 191, 106, 219),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
