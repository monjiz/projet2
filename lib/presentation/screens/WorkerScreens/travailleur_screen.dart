import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TravailleurScreen extends StatelessWidget {
  const TravailleurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    //Consumer<AuthService>(
     // builder: (context, auth, child) {
      //  final theme = Theme.of(context);
         Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: const Color(0xFF1877F2),
            title: const Text(
              'Espace Travailleur',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Carte de profil
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nom Prénom',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'email@example.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Boutons d'actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildActionButton(
                          context,
                          'Voir les Projets',
                          Icons.work,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Voir les Projets - À implémenter')),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionButton(
                          context,
                          'Gérer les Tâches',
                          Icons.task,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gérer les Tâches - À implémenter')),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionButton(
                          context,
                          'Notifications',
                          Icons.notifications,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notifications - À implémenter')),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionButton(
                          context,
                          'Messages',
                          Icons.message,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Messages - À implémenter')),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionButton(
                          context,
                          'Déconnexion',
                          Icons.logout,
                          () async {
                            try {
                             // await auth.signOut();
                              if (context.mounted) {
                                goToLogin(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur lors de la déconnexion : $e'),
                                  //  backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                              }
                            }
                          },
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Barre de navigation inférieure
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF1877F2),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'Projets',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            onTap: (index) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navigation vers l\'onglet $index - À implémenter')),
              );
            },
          ),
        );
   //   },
   // );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFF1877F2),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void goToLogin(BuildContext context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}