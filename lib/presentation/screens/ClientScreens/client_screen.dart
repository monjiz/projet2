import 'package:auth_firebase/data/services/api_service.dart';
import 'package:auth_firebase/presentation/screens/messagesScreens/messages_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../auth/auth_service.dart';
import '../../../auth/login_screen.dart';
import '../../../data/models/annonce_models.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/projet_models.dart';
import '../../../data/repositories/client_repository.dart';
import '../../../logique(bloc)/client/client_bloc.dart';
import '../../../logique(bloc)/client/client_event.dart';
import '../../../logique(bloc)/client/client_state.dart';
import 'client_profil_screen.dart';
import 'client_settings_screen.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    const primaryBlue = Color(0xFF1877F2); // Bleu Facebook
    const whiteBackground = Color(0xFFFFFFFF);
    const lightBlue = Color(0xFFE7F3FF); // Bleu clair pour les accents

    return BlocProvider(
      create: (_) => ClientBloc(clientRepository: ClientRepository())
        ..add(LoadClientDashboard())
        ..add(LoadAnnonces())
        //  ..add(LoadMessages())
        ..add(LoadProjects())
        ..add(LoadWorkers()),
      child: Builder(
        builder: (context) {
          return BlocListener<ClientBloc, ClientState>(
            listener: (context, state) {
              if (state is ClientShowSnack) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message,
                        style: GoogleFonts.poppins(color: Colors.white)),
                    backgroundColor: primaryBlue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                    animation: CurvedAnimation(
                      parent: kAlwaysCompleteAnimation,
                      curve: Curves.easeInOut,
                    ),
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: whiteBackground,
              appBar: AppBar(
                backgroundColor: whiteBackground,
                elevation: 0,
                title: _buildSearchBar(primaryBlue, context),
                centerTitle: true,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.bars,
                      color: primaryBlue,
                      size: 20,
                    ),
                    tooltip: 'Open Menu',
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
              drawer: _buildDrawer(context, auth, primaryBlue),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bonjour Client,\nGérez vos espaces",
                                style: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth * 0.06,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              _sectionTitle("Actions rapides",
                                  onViewAll: () {},
                                  primaryBlue: primaryBlue,
                                  constraints: constraints),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              _clientActionGrid(
                                  context, primaryBlue, lightBlue, constraints),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              _sectionTitle("Annonces",
                                  onViewAll: () {},
                                  primaryBlue: primaryBlue,
                                  constraints: constraints),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              _annoncesList(context, primaryBlue, constraints),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              _sectionTitle("Messages",
                                  onViewAll: () {},
                                  primaryBlue: primaryBlue,
                                  constraints: constraints),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              _messagesList(context, primaryBlue, constraints),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              _sectionTitle("Projets",
                                  onViewAll: () {},
                                  primaryBlue: primaryBlue,
                                  constraints: constraints),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              _projectsList(context, primaryBlue, constraints),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              _sectionTitle("Top travailleurs",
                                  onViewAll: () {},
                                  primaryBlue: primaryBlue,
                                  constraints: constraints),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              _topWorkersList(
                                  context, primaryBlue, constraints),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomNavigationBar:
                  _bottomNavBar(context, primaryBlue, whiteBackground),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(Color primaryBlue, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
              color: primaryBlue, size: 18),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _clientActionGrid(BuildContext context, Color primaryBlue,
      Color lightBlue, BoxConstraints constraints) {
    final actions = [
      _ClientAction("Consulter annonces", FontAwesomeIcons.bullhorn,
          () => _showAction(context, "Annonces consultées")),
      _ClientAction("Envoyer message", FontAwesomeIcons.paperPlane,
          () => _showAction(context, "Message envoyé")),
      _ClientAction("Gérer projet", FontAwesomeIcons.projectDiagram,
          () => _showAction(context, "Projet géré")),
      _ClientAction("Voir travailleurs", FontAwesomeIcons.users,
          () => _showAction(context, "Travailleurs affichés")),
      _ClientAction("Créer tâche", FontAwesomeIcons.tasks,
          () => _showAction(context, "Tâche créée")),
      _ClientAction("Voir recommandations", FontAwesomeIcons.lightbulb,
          () => _showAction(context, "Recommandations affichées")),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            color: Colors.white,
            child: InkWell(
              onTap: action.onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: constraints.maxWidth * 0.08,
                    backgroundColor: lightBlue,
                    child: Icon(action.icon,
                        size: constraints.maxWidth * 0.06, color: primaryBlue),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.015),
                  Flexible(
                    child: Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: constraints.maxWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _annoncesList(
      BuildContext context, Color primaryBlue, BoxConstraints constraints) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is AnnoncesLoaded) {
          return SizedBox(
            height: constraints.maxHeight * 0.2,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.annonces.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: constraints.maxWidth * 0.03),
              itemBuilder: (context, index) {
                final annonce = state.annonces[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Container(
                    width: constraints.maxWidth * 0.35,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          annonce.titre,
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Publiée le: ${annonce.datePublication}",
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.03,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator(color: primaryBlue));
      },
    );
  }

  Widget _messagesList(
      BuildContext context, Color primaryBlue, BoxConstraints constraints) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is MessagesLoaded) {
          return SizedBox(
            height: constraints.maxHeight * 0.2,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.messages.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: constraints.maxWidth * 0.03),
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Container(
                    width: constraints.maxWidth * 0.35,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message.titre,
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "De: ${message.destinataire}",
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.03,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator(color: primaryBlue));
      },
    );
  }

  Widget _projectsList(
      BuildContext context, Color primaryBlue, BoxConstraints constraints) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is ProjectsLoaded) {
          return SizedBox(
            height: constraints.maxHeight * 0.2,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.projects.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: constraints.maxWidth * 0.03),
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Container(
                    width: constraints.maxWidth * 0.35,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          project.titre,
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Statut: ${project.status}",
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.03,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator(color: primaryBlue));
      },
    );
  }

  Widget _topWorkersList(
      BuildContext context, Color primaryBlue, BoxConstraints constraints) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is WorkersLoaded) {
          return SizedBox(
            height: constraints.maxHeight * 0.22,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.workers.length,
              separatorBuilder: (_, __) =>
                  SizedBox(width: constraints.maxWidth * 0.03),
              itemBuilder: (context, index) {
                final worker = state.workers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Container(
                    width: constraints.maxWidth * 0.35,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: constraints.maxWidth * 0.09,
                          backgroundColor: primaryBlue.withOpacity(0.1),
                          child: Icon(FontAwesomeIcons.user,
                              size: constraints.maxWidth * 0.07,
                              color: primaryBlue),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.015),
                        Flexible(
                          child: Text(
                            worker.name,
                            style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          "Travailleur",
                          style: GoogleFonts.poppins(
                            fontSize: constraints.maxWidth * 0.03,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator(color: primaryBlue));
      },
    );
  }

  Widget _sectionTitle(String title,
      {required VoidCallback onViewAll,
      required Color primaryBlue,
      required BoxConstraints constraints}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: constraints.maxWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            "Voir tout",
            style: GoogleFonts.poppins(
              fontSize: constraints.maxWidth * 0.035,
              color: primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomNavBar(
      BuildContext context, Color primaryBlue, Color whiteBackground) {
    return Container(
      decoration: BoxDecoration(
        color: whiteBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: whiteBackground,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey[600],
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: MediaQuery.of(context).size.width * 0.035,
        unselectedFontSize: MediaQuery.of(context).size.width * 0.03,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: (index) {
          final bloc = context.read<ClientBloc>();
          if (index == 1)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MessagesListPage(
                        apiService: ApiService(), userType: '')));
          if (index == 2) bloc.add(ShowSnackBar("Projets affichés"));
          if (index == 3)
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ClientProfileScreen()));
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house,
                size: MediaQuery.of(context).size.width * 0.06),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.message,
                size: MediaQuery.of(context).size.width * 0.06),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.projectDiagram,
                size: MediaQuery.of(context).size.width * 0.06),
            label: "Projets",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user,
                size: MediaQuery.of(context).size.width * 0.06),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  void _showAction(BuildContext context, String message) {
    context.read<ClientBloc>().add(ShowSnackBar(message));
  }

  Drawer _buildDrawer(
      BuildContext context, AuthService auth, Color primaryBlue) {
    final String clientName = "Client User";
    final String clientEmail = "client@example.com";
    final String clientAvatarUrl = "";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              clientName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(clientEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: primaryBlue,
              backgroundImage: clientAvatarUrl.isNotEmpty
                  ? NetworkImage(clientAvatarUrl)
                  : null,
              child: clientAvatarUrl.isEmpty
                  ? Text(
                      clientName.isNotEmpty ? clientName[0].toUpperCase() : "C",
                      style: TextStyle(
                        fontSize: 40.0,
                      ),
                    )
                  : null,
            ),
            decoration: BoxDecoration(
              color: primaryBlue,
            ),
            otherAccountsPictures: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  //  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ClientProfileScreen()),
                  );

                  //  _showAction(context, "Edit profile (not implemented)");
                },
                tooltip: "Edit profile",
              ),
            ],
          ),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.house,
            textLabel: 'Accueil',
            onTapCallback: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.message,
            textLabel: 'Mes Messages',
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MessagesListPage(apiService: ApiService(), userType: ''),
                ),
              );
            },
          ),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.user,
            textLabel: 'Mon Profil',
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientProfileScreen()),
              );
            },
          ),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.gear,
            textLabel: 'Paramètres',
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientSettingsScreen()),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.globe,
            textLabel: 'Changer la langue',
            onTapCallback: () {
              Navigator.pop(context);
              _showAction(context, "Changer de langue");
            },
          ),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.questionCircle,
            textLabel: 'Aide et Support',
            onTapCallback: () {
              Navigator.pop(context);
              _showAction(context, "Aide et Support (not implemented)");
            },
          ),
          const Divider(),
          _buildDrawerItem(
            iconId: FontAwesomeIcons.arrowRightFromBracket,
            textLabel: 'Déconnexion',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTapCallback: () async {
              Navigator.pop(context);
              try {
                await auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              } catch (eSignOut) {
                _showAction(
                    context, "Erreur lors de la déconnexion : $eSignOut");
              }
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Version 1.0',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData iconId,
    required String textLabel,
    required GestureTapCallback onTapCallback,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(iconId, color: iconColor ?? Colors.grey[700]),
      title: Text(
        textLabel,
        style: GoogleFonts.poppins(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTapCallback,
      dense: true,
    );
  }
}

class _ClientAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  _ClientAction(this.label, this.icon, this.onPressed);
}
