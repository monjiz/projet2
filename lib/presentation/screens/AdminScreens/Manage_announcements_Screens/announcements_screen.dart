import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_bloc.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_event.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_state.dart';

import 'update_annonce_screen.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool localeInitialized = false;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('fr', null).then((_) {
      setState(() {
        localeInitialized = true;
      });
      context.read<AnnouncementBloc>().add(LoadAnnouncements());
    });
  }

  void _confirmDelete(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Supprimer l’annonce "$title" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
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

  String _formatDate(String? dateStr) {
    if (!localeInitialized) return 'Chargement...';
    try {
      if (dateStr == null || dateStr.isEmpty) return 'Date inconnue';
      DateTime date;
      if (dateStr.length == 10) {
        date = DateFormat('yyyy-MM-dd').parse(dateStr);
      } else {
        date = DateTime.parse(dateStr);
      }
      return DateFormat.yMMMMd('fr').format(date);
    } catch (e) {
      debugPrint('Erreur parsing date: $e');
      return 'Date invalide';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!localeInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Annonces", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 139, 47, 197),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UpdateAnnonceScreen(isEdit: false),
            ),
          );
        },
        backgroundColor: const Color(0xFFB175F9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocListener<AnnouncementBloc, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
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
                      title: Text(ann.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatDate(ann.publishedAt)),
                          Text("Type : ${ann.type}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UpdateAnnonceScreen(isEdit: true, announcement: ann),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 144, 83, 182)),
                            onPressed: () => _confirmDelete(context, ann.id, ann.title),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is AnnouncementError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erreur : ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AnnouncementBloc>().add(LoadAnnouncements()),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            } else if (state is AnnouncementEmpty) {
              return const Center(child: Text("Aucune annonce à afficher."));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
