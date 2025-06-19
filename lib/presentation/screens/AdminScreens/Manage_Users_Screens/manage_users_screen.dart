import 'package:auth_firebase/logique(bloc)/user/user_bloc.dart';
import 'package:auth_firebase/logique(bloc)/user/user_event.dart';
import 'package:auth_firebase/logique(bloc)/user/user_state.dart';
import 'package:auth_firebase/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_user_screen.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les utilisateurs')),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddUserScreen()),
    );

    if (context.mounted) {
      context.read<UserBloc>().add(LoadUsers()); // Recharge la liste après ajout
    }
  },
  backgroundColor: Colors.deepPurpleAccent,
  child: const Icon(Icons.add, color: Colors.white),
),

      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('Aucun utilisateur.'));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.name), // adapte ici au champ correct
                  subtitle: Text('${user.email}\nRôle : ${user.type}'), // idem ici
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditRoleDialog(context, user),
                      ),
                   /*   IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(context, user),
                      ),*/
                    ],
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Erreur : ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showEditRoleDialog(BuildContext context, UserModel user) {
    final roles = ['Client', 'Worker', 'Administrator']; // mettre en minuscules si c'est le format backend
    String selectedRole = user.type.toLowerCase();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier le rôle de l’utilisateur'),
        content: StatefulBuilder(
          builder: (context, setState) => DropdownButtonFormField<String>(
            value: selectedRole,
            items: roles.map((role) => DropdownMenuItem<String>(
              value: role,
              child: Text(role[0].toUpperCase() + role.substring(1)), // Capitaliser la première lettre
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedRole = value);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Sélectionner un rôle',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedRole != user.type.toLowerCase()) {
                context.read<UserBloc>().add(UpdateUserRoleEvent(user.id, selectedRole));
              }
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

 /* void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer ${user.fullName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserBloc>().add(DeleteUserEvent(user.id));
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }*/
}
