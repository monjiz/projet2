import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1877F2);
    const whiteBackground = Color(0xFFFFFFFF);
    const lightBlue = Color(0xFFE7F3FF);

    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        title: Text(
          "Gestion de Projets",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0.5,
        backgroundColor: whiteBackground,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.plus, size: 18),
            onPressed: () => _showAddProjectDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectStats(primaryBlue, lightBlue),
              const SizedBox(height: 24),
              _buildSectionTitle("Mes Projets Actifs"),
              const SizedBox(height: 12),
              _buildActiveProjectsList(primaryBlue),
              const SizedBox(height: 24),
              _buildSectionTitle("Projets Archivés"),
              const SizedBox(height: 12),
              _buildArchivedProjectsList(primaryBlue),
              const SizedBox(height: 24),
              _buildSectionTitle("Collaborateurs"),
              const SizedBox(height: 12),
              _buildCollaboratorsList(primaryBlue, lightBlue),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context),
        backgroundColor: primaryBlue,
        child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildProjectStats(Color primaryBlue, Color lightBlue) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem("5", "En cours", primaryBlue, lightBlue),
            _buildStatItem("3", "Terminés", Colors.green, Colors.green[100]!),
            _buildStatItem("2", "En retard", Colors.orange, Colors.orange[100]!),
            _buildStatItem("1", "Annulés", Colors.red, Colors.red[100]!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color, Color bgColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildActiveProjectsList(Color primaryBlue) {
    final activeProjects = [
      _ProjectItem("Site Web E-commerce", "Développement front-end", "70%", Colors.green, DateTime.now().add(const Duration(days: 15))),
      _ProjectItem("Application Mobile", "Phase de test", "45%", Colors.orange, DateTime.now().add(const Duration(days: 30))),
      _ProjectItem("Refonte UI/UX", "Conception wireframes", "20%", Colors.blue, DateTime.now().add(const Duration(days: 45))),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activeProjects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildProjectCard(activeProjects[index], primaryBlue, false),
    );
  }

  Widget _buildArchivedProjectsList(Color primaryBlue) {
    final archivedProjects = [
      _ProjectItem("Système de Gestion", "Projet terminé", "100%", Colors.grey, DateTime.now().subtract(const Duration(days: 60))),
      _ProjectItem("Plateforme SaaS", "Projet annulé", "65%", Colors.red, DateTime.now().subtract(const Duration(days: 30))),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: archivedProjects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildProjectCard(archivedProjects[index], primaryBlue, true),
    );
  }

  Widget _buildProjectCard(_ProjectItem project, Color primaryBlue, bool isArchived) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProjectDetails(project),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isArchived ? Colors.grey : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isArchived)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: project.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        project.progress,
                        style: GoogleFonts.poppins(
                          color: project.statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: double.parse(project.progress.replaceAll('%', '')) / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(project.statusColor),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        "Échéance: ${_formatDate(project.deadline)}",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (!isArchived)
                    IconButton(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onPressed: () => _showProjectOptions(project),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildCollaboratorsList(Color primaryBlue, Color lightBlue) {
  final collaborators = [
    _Collaborator("Jean Dupont", "Développeur Front-end"),
    _Collaborator("Marie Martin", "Designer UI/UX"),
    _Collaborator("Pierre Lambert", "Chef de Projet"),
  ];

  return SizedBox(
    height: 100,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: collaborators.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) => _buildCollaboratorCard(
        collaborators[index],
        primaryBlue,
        lightBlue,
      ),
    ),
  );
}

Widget _buildCollaboratorCard(
    _Collaborator collaborator, Color primaryBlue, Color lightBlue) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*CircleAvatar(
            radius: 24,
            backgroundColor: lightBlue,
            backgroundImage:
                collaborator.avatarUrl.isNotEmpty ? AssetImage(collaborator.avatarUrl) : null,
            onBackgroundImageError: (_, __) => Icon(
              Icons.person,
              color: primaryBlue,
              size: 24,
            ),
            child: collaborator.avatarUrl.isEmpty
                ? Text(
                    collaborator.name.isNotEmpty
                        ? collaborator.name.substring(0, 1)
                        : '',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  )
                : null,
          ),*/
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              collaborator.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              collaborator.role,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Nouveau Projet",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: const Text("Formulaire de création de projet à ajouter ici."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(_ProjectItem project) {
    // Implémentation de navigation vers les détails du projet
  }

  void _showProjectOptions(_ProjectItem project) {
    // Implémentation des options du projet (modifier, archiver, etc.)
  }
}

class _ProjectItem {
  final String title;
  final String subtitle;
  final String progress;
  final Color statusColor;
  final DateTime deadline;

  _ProjectItem(this.title, this.subtitle, this.progress, this.statusColor, this.deadline);
}

class _Collaborator {
  final String name;
  final String role;


  _Collaborator(this.name, this.role);
}
