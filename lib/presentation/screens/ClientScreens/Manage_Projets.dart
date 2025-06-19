import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:auth_firebase/data/models/projet_models.dart';
import 'package:auth_firebase/logique(bloc)/projet/projet_bloc.dart';
import 'package:auth_firebase/logique(bloc)/projet/projet_event.dart';
import 'package:auth_firebase/logique(bloc)/projet/projet_state.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1877F2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Gérer les projets',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: primaryBlue),
            onPressed: () => _showProjectDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is ProjectSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: GoogleFonts.poppins(color: Colors.white)),
                  backgroundColor: primaryBlue,
                ),
              );
            } else if (state is ProjectFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error, style: GoogleFonts.poppins(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProjectLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProjectLoaded) {
              if (state.projects.isEmpty) {
                return Center(child: Text('Aucun projet trouvé', style: GoogleFonts.poppins()));
              }
              return ListView.builder(
                itemCount: state.projects.length,
                itemBuilder: (context, index) {
                  final project = state.projects[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.folder, color: primaryBlue),
                      ),
                      title: Text(project.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        'Statut: ${project.status}\n'
                        'Catégorie: ${project.category}\n'
                        'Deadline: ${DateFormat('dd/MM/yyyy').format(project.deadline)}',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      isThreeLine: true,
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showProjectDialog(context, project: project),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteConfirmation(context, project.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProjectFailure) {
              return Center(child: Text('Erreur : ${state.error}', style: GoogleFonts.poppins()));
            }
            return Center(child: Text('Aucun projet trouvé', style: GoogleFonts.poppins()));
          },
        ),
      ),
    );
  }

  void _deleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Supprimer le projet', style: GoogleFonts.poppins()),
        content: Text('Êtes-vous sûr de vouloir supprimer ce projet ?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            child: Text('Annuler', style: GoogleFonts.poppins()),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text('Supprimer', style: GoogleFonts.poppins(color: Colors.red)),
            onPressed: () {
              context.read<ProjectBloc>().add(DeleteProjectEvent(id));
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showProjectDialog(BuildContext context, {ProjectModel? project}) {
    final titleController = TextEditingController(text: project?.title ?? '');
    final descriptionController = TextEditingController(text: project?.description ?? '');
    final technologiesController = TextEditingController(text: project?.technologies ?? '');
    DateTime deadline = project?.deadline ?? DateTime.now().add(const Duration(days: 7));
    String status = project?.status ?? 'Open';
    String approvmentStatus = project?.approvmentStatus ?? 'Approved';
    String category = project?.category ?? 'Web';
    bool isPublished = project?.isPublished ?? false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(project == null ? 'Créer un projet' : 'Modifier le projet', style: GoogleFonts.poppins()),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Titre', titleController),
                    _buildTextField('Description', descriptionController, maxLines: 3),
                    _buildDropdown('Catégorie', category, ['Web', 'Mobile', 'Desktop', 'Other'], (v) => setState(() => category = v)),
                    _buildTextField('Technologies', technologiesController),
                    const SizedBox(height: 10),
                    _buildDateField(dialogContext, deadline, (value) => setState(() => deadline = value)),
                    _buildDropdown('Statut', status, ['Open', 'In Progress', 'Closed'], (v) => setState(() => status = v)),
                    _buildDropdown('Statut d’approbation', approvmentStatus, ['Approved', 'Rejected', 'In Review', 'Update Requested'], (v) => setState(() => approvmentStatus = v)),
                    CheckboxListTile(
                      title: Text('Publié', style: GoogleFonts.poppins()),
                      value: isPublished,
                      onChanged: (v) => setState(() => isPublished = v!),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Annuler', style: GoogleFonts.poppins(color: Colors.grey)),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                ElevatedButton(
                  onPressed: () {
                    if ([titleController.text, descriptionController.text, category, technologiesController.text].any((e) => e.trim().isEmpty)) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: Text('Veuillez remplir tous les champs', style: GoogleFonts.poppins()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final newProject = ProjectModel(
                      id: project?.id ?? '',
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      deadline: deadline,
                      status: status,
                      approvmentStatus: approvmentStatus,
                      isPublished: isPublished,
                      category: category,
                      technologies: technologiesController.text.trim(),
                    );

                    final bloc = BlocProvider.of<ProjectBloc>(dialogContext);
                    if (project == null) {
                      bloc.add(AddProjectEvent(newProject));
                    } else {
                      bloc.add(UpdateProjectEvent(newProject));
                    }

                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(project == null ? 'Créer' : 'Modifier', style: GoogleFonts.poppins(color: Colors.white)),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, DateTime date, ValueChanged<DateTime> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date limite',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        controller: TextEditingController(text: DateFormat('dd/MM/yyyy').format(date)),
        onTap: () async {
          final selected = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (selected != null) onChanged(selected);
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}
