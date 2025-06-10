// presentation/screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logique(bloc)/notification/notification_bloc.dart';
import '../../logique(bloc)/notification/notification_event.dart';
import '../../logique(bloc)/notification/notification_state.dart';


class NotificationScreen extends StatelessWidget {
  final String userRole;
  const NotificationScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc()..add(LoadNotifications(userRole)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text("Aucune notification"));
              }
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notif = state.notifications[index];
                  return Card(
                    color: notif.isRead ? Colors.white : Colors.purple[50],
                    child: ListTile(
                      title: Text(notif.title),
                      subtitle: Text(notif.message),
                      trailing: notif.isRead
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.mark_email_read),
                              onPressed: () {
                                context.read<NotificationBloc>().add(MarkNotificationRead(notif.id));
                              },
                            ),
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text("Erreur: ${state.message}"));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
