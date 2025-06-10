import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_bloc.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_event.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_state.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  void _showDialog(BuildContext context,
      {bool isEdit = false, Annonce? announcement}) {
    final titleCtrl =
        TextEditingController(text: isEdit ? announcement?.titre : '');
    final descCtrl =
        TextEditingController(text: isEdit ? announcement?.contenu : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Modifier l\'annonce' : 'Nouvelle annonce'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              titleCtrl.dispose();
              descCtrl.dispose();
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final desc = descCtrl.text.trim();
              if (title.isEmpty || desc.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tous les champs sont requis.")),
                );
                return;
              }

              final id = isEdit && announcement != null
                  ? announcement.id
                  : DateTime.now().millisecondsSinceEpoch.toString();

              final newAnn = Annonce(
                id: id,
                titre: title,
                datePublication: DateTime.now().toIso8601String(), contenu: '', type: '',
              );

              if (isEdit) {
                context.read<AnnouncementBloc>().add(EditAnnouncement(id, newAnn));
              } else {
                context.read<AnnouncementBloc>().add(AddAnnouncement(newAnn));
              }

              Navigator.pop(context);
              titleCtrl.dispose();
              descCtrl.dispose();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Supprimer l’annonce "$title" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AnnouncementBloc>().add(DeleteAnnouncement(id));
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Annonces", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 139, 47, 197),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        backgroundColor: const Color(0xFFB175F9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<AnnouncementBloc, AnnouncementState>(
        builder: (context, state) {
          if (state is AnnouncementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnouncementLoaded) {
            final annonces = state.annonces;
            if (annonces.isEmpty) {
              return const Center(child: Text("Aucune annonce disponible."));
            }
            return ListView.builder(
              itemCount: annonces.length,
              itemBuilder: (context, index) {
                final ann = annonces[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(ann.titre),
                    subtitle: Text(ann.datePublication),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showDialog(context, isEdit: true, announcement: ann),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 144, 83, 182)),
                          onPressed: () =>
                              _confirmDelete(context, ann.id, ann.titre),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AnnouncementError) {
            return Center(child: Text('Erreur : ${state.message}'));
          } else if (state is AnnouncementEmpty) {
            return const Center(child: Text("Aucune annonce à afficher."));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
