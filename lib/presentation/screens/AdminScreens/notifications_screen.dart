import 'package:auth_firebase/data/models/notifications.dart';
import 'package:auth_firebase/logique(bloc)/notification/notification_bloc.dart';
import 'package:auth_firebase/logique(bloc)/notification/notification_event.dart';
//import 'package:auth_firebase/logique(bloc)/notification/notification_state.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/NotificationHistoryScreen';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  static const String _roleAll = 'all';
  static const String _roleClient = 'client';
  static const String _roleWorker = 'worker';

  String _selectedRole = _roleAll;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _getRoleDisplayName(String roleKey) {
    switch (roleKey) {
      case _roleAll:
        return 'Tous les utilisateurs';
      case _roleClient:
        return 'Clients';
      case _roleWorker:
        return 'Travailleurs';
      default:
        return roleKey;
    }
  }

  void _sendNotification(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final notification = AppNotification(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        targetRole: _selectedRole,
        createdAt: DateTime.now(),
      );

      context.read<NotificationBloc>().add(AddNotification(notification));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Notification envoyée avec succès !"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
        ),
      );

      _formKey.currentState?.reset();
      _titleController.clear();
      _messageController.clear();
      setState(() {
        _selectedRole = _roleAll;
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer une Notification'),
        backgroundColor: theme.primaryColor,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historique des notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Ex: Maintenance importante',
                  prefixIcon: Icon(Icons.title, color: theme.primaryColorDark),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  hintText: 'Entrez les détails de la notification...',
                  prefixIcon: Icon(Icons.message, color: theme.primaryColorDark),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 4,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Le message est requis' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: [
                  DropdownMenuItem(value: _roleAll, child: Text(_getRoleDisplayName(_roleAll))),
                  DropdownMenuItem(value: _roleClient, child: Text(_getRoleDisplayName(_roleClient))),
                  DropdownMenuItem(value: _roleWorker, child: Text(_getRoleDisplayName(_roleWorker))),
                ],
                onChanged: (val) => setState(() => _selectedRole = val ?? _roleAll),
                decoration: InputDecoration(
                  labelText: 'Destinataire',
                  prefixIcon: Icon(Icons.people_alt_outlined, color: theme.primaryColorDark),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _sendNotification(context),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Envoyer la Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}