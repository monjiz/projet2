import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:auth_firebase/logique(bloc)/annonce/annonce_bloc.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_event.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_state.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementBloc>().add(LoadAnnouncements());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1877F2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Announcements', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AnnouncementBloc, AnnouncementState>(
          listener: (context, state) {
            if (state is AnnouncementOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message, style: GoogleFonts.poppins())),
              );
            } else if (state is AnnouncementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: GoogleFonts.poppins(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AnnouncementLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnnouncementEmpty) {
              return Center(child: Text('No announcements found.', style: GoogleFonts.poppins()));
            } else if (state is AnnouncementLoaded) {
              final announcements = state.annonces;
              return ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final annonce = announcements[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.campaign, color: primaryColor),
                      ),
                      title: Text(
                        annonce.title,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            annonce.content,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Type: ${annonce.type} • Published: ${DateFormat('dd MMM yyyy').format(DateTime.parse(annonce.publishedAt))}",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
                    ),
                  );
                },
              );
            } else if (state is AnnouncementError) {
              return Center(child: Text('Error: ${state.message}', style: GoogleFonts.poppins(color: Colors.red)));
            }
            return Center(child: Text('Unknown state', style: GoogleFonts.poppins()));
          },
        ),
      ),
    );
  }
}
