import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/models/worker_model.dart'; // Assurez-vous que le chemin est correct
import '../../../logique(bloc)/client/client_bloc.dart';
import '../../../logique(bloc)/client/client_event.dart';
import '../../../logique(bloc)/client/client_state.dart';

class WorkersListScreen extends StatelessWidget {
  const WorkersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF1877F2);
    final whiteBackground = const Color(0xFFFFFFFF);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des Travailleurs',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: whiteBackground,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
     /* body: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          if (state is WorkersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkersLoaded) {
            return _buildWorkersList(state.workers, primaryBlue, whiteBackground);
          } else if (state is WorkersError) {
            return Center(child: Text('Erreur: ${state.message}'));
          }
          return const Center(child: Text('Aucun travailleur disponible'));
        },
      ),*/
    );
  }

  Widget _buildWorkersList(List<Worker> workers, Color primaryBlue, Color whiteBackground) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _showWorkerDetails(context, worker, primaryBlue);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryBlue.withOpacity(0.1),
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          worker.specialty ?? 'Spécialité non spécifiée',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              worker.rating?.toStringAsFixed(1) ?? '0.0',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWorkerDetails(BuildContext context, Worker worker, Color primaryBlue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: primaryBlue.withOpacity(0.1),
                    child: Icon(
                      FontAwesomeIcons.user,
                      color: primaryBlue,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          worker.specialty ?? 'Spécialité non spécifiée',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 10),
              _buildDetailRow(
                Icons.star_border,
                'Note',
                worker.rating?.toStringAsFixed(1) ?? '0.0',
                primaryBlue,
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 10),
              Text(
                'À propos',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Spécialisé en ${worker.specialty ?? 'divers domaines'}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Contacter ${worker.name}'),
                      ),
                    );
                  },
                  child: Text(
                    'Contacter',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}