import 'package:auth_firebase/data/models/role_models.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_bloc.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_event.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_state.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/AssignPermissionsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageRolesPage extends StatefulWidget {
  @override
  _ManageRolesPageState createState() => _ManageRolesPageState();
}

class _ManageRolesPageState extends State<ManageRolesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RolePermissionBloc>().add(LoadRolesAndPermissions());
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newRole = Role(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        permissions: [],
      );

      context.read<RolePermissionBloc>().add(CreateRole(newRole));

      _nameController.clear();
      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Création du rôle en cours...")),
      );
    }
  }

  void _editRole(Role role) {
    final TextEditingController editNameController = TextEditingController(text: role.name);
    final TextEditingController editDescController = TextEditingController(text: role.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier le rôle"),
        content: Form(
          key: GlobalKey<FormState>(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: editNameController,
                decoration: InputDecoration(labelText: "Nom du rôle"),
                validator: (value) => value == null || value.isEmpty ? "Nom requis" : null,
              ),
              TextFormField(
                controller: editDescController,
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) => value == null || value.isEmpty ? "Description requise" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (editNameController.text.trim().isEmpty || editDescController.text.trim().isEmpty) {
                return;
              }
              final updatedRole = Role(
                id: role.id,
                name: editNameController.text.trim(),
                description: editDescController.text.trim(),
                permissions: role.permissions,
              );
              context.read<RolePermissionBloc>().add(UpdateRole(updatedRole));
              Navigator.of(context).pop();
            },
            child: Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  void _deleteRole(Role role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer le rôle"),
        content: Text("Voulez-vous vraiment supprimer le rôle '${role.name}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<RolePermissionBloc>().add(DeleteRole(role.id));
              Navigator.of(context).pop();
            },
            child: Text("Supprimer"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer les Rôles"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulaire d'ajout de rôle
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ajouter un rôle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Nom du rôle"),
                    validator: (value) => value == null || value.isEmpty ? "Nom requis" : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                    validator: (value) => value == null || value.isEmpty ? "Description requise" : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: Icon(Icons.save),
                    label: Text("Créer le rôle"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Liste des rôles existants avec Edit et Delete
            Expanded(
              child: BlocConsumer<RolePermissionBloc, RolePermissionState>(
                listener: (context, state) {
                  if (state is RolePermissionError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                    );
                  } else if (state is RolesAndPermissionsLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Rôles mis à jour !"), backgroundColor: Colors.green),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is RolePermissionLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is RolesAndPermissionsLoaded) {
                    if (state.roles.isEmpty) {
                      return Center(child: Text("Aucun rôle trouvé."));
                    }
                    return ListView.builder(
                      itemCount: state.roles.length,
                      itemBuilder: (context, index) {
                        final role = state.roles[index];
                        return Card(
                          child: ListTile(
                            title: Text(role.name),
                            subtitle: Text(role.description ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editRole(role),
                                  tooltip: "Modifier",
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteRole(role),
                                  tooltip: "Supprimer",
                                ),
                                IconButton(
  icon: const Icon(Icons.lock_outline),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignPermissionsPage(role: role),
      ),
    );
  },
),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is RolePermissionError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text("Aucune donnée chargée."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
