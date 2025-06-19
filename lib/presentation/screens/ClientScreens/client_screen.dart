import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/data/services/api_service.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/kpi_dashboard_screen.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/Manage_Projets.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/View_Announcements.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/View_Workers.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/project_managment_screen.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/worker_List_Screen.dart';
import 'package:auth_firebase/presentation/screens/messagesScreens/messages_list_page.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/client_profil_screen.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/client_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    const primaryBlue = Color(0xFF1877F2);
    const whiteBackground = Color(0xFFFFFFFF);
    const lightBlue = Color(0xFFE7F3FF);

    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        backgroundColor: whiteBackground,
        elevation: 0,
        title: _buildSearchBar(primaryBlue, context),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(FontAwesomeIcons.bars, color: primaryBlue, size: 20),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(context, auth, primaryBlue),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bonjour Client,\nGérez vos espaces",
                      style: GoogleFonts.poppins(
                        fontSize: constraints.maxWidth * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.03),
                    _clientActionGrid(context, primaryBlue, lightBlue, constraints),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context, primaryBlue, whiteBackground),
    );
  }

  Widget _buildSearchBar(Color primaryBlue, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass, color: primaryBlue, size: 18),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _clientActionGrid(BuildContext context, Color primaryBlue, Color lightBlue, BoxConstraints constraints) {
    final actions = [
      _ClientAction("Consulter annonces", FontAwesomeIcons.bullhorn, () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementScreen()));
      }),
      _ClientAction("Envoyer Message", FontAwesomeIcons.paperPlane, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MessagesListPage(apiService: ApiService(), userType: '')));
      }),
      _ClientAction("Gérer projet", FontAwesomeIcons.projectDiagram, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectManagementScreen()));
      }),
      _ClientAction("Voir travailleurs", FontAwesomeIcons.users, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewWorkersScreen()));
      }),
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
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: Icon(action.icon, size: constraints.maxWidth * 0.06, color: primaryBlue),
                ),
                SizedBox(height: constraints.maxHeight * 0.015),
                Flexible(
                  child: Text(action.label,
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
        );
      },
    );
  }

  Widget _bottomNavBar(BuildContext context, Color primaryBlue, Color whiteBackground) {
    return BottomNavigationBar(
      backgroundColor: whiteBackground,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey[600],
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house), label: "Accueil"),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.message), label: "Messages"),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.projectDiagram), label: "Projets"),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: "Profil"),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MessagesListPage(apiService: ApiService(), userType: '')));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectScreen()));
        }
         else if (index == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientProfileScreen()));
        }
      },
    );
  }

  Drawer _buildDrawer(BuildContext context, AuthService auth, Color primaryBlue) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Client User", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text("client@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: primaryBlue,
              child: Text("C", style: TextStyle(fontSize: 40.0)),
            ),
            decoration: BoxDecoration(color: primaryBlue),
          ),
          _buildDrawerItem(FontAwesomeIcons.house, 'Accueil', () => Navigator.pop(context)),
          _buildDrawerItem(FontAwesomeIcons.message, 'Mes Messages', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => MessagesListPage(apiService: ApiService(), userType: '')));
          }),
          _buildDrawerItem(FontAwesomeIcons.gaugeHigh, 'Dashboard Client', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const KPIDashboardScreen()));
          }),
          _buildDrawerItem(FontAwesomeIcons.user, 'Mon Profil', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientProfileScreen()));
          }),
          _buildDrawerItem(FontAwesomeIcons.gear, 'Paramètres', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientSettingsScreen()));
          }),
          const Divider(),
          _buildDrawerItem(FontAwesomeIcons.arrowRightFromBracket, 'Log Out', () async {
            Navigator.pop(context);
            await auth.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }, iconColor: Colors.red, textColor: Colors.red),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Version 1.0', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey))),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap, {Color? iconColor, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[700]),
      title: Text(label, style: GoogleFonts.poppins(color: textColor ?? Colors.black87)),
      onTap: onTap,
    );
  }
}

class _ClientAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  _ClientAction(this.label, this.icon, this.onPressed);
}
