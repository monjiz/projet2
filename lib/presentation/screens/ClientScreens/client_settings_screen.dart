import 'package:flutter/material.dart';

class ClientSettingsScreen extends StatelessWidget {
  const ClientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres", 
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, 
            size: 20, 
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Préférences"),
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: "Notifications",
              subtitle: "Gérer vos notifications",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.language_outlined,
              title: "Langue",
              subtitle: "Français",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.dark_mode_outlined,
              title: "Apparence",
              subtitle: "Mode clair",
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: Colors.blue,
              ),
            ),
            
            _buildSectionHeader("Confidentialité"),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: "Confidentialité",
              subtitle: "Qui peut voir vos informations",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.security_outlined,
              title: "Sécurité",
              subtitle: "Options de sécurité du compte",
              onTap: () {},
            ),
            
            _buildSectionHeader("Compte"),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: "Aide et support",
              subtitle: "Centre d'aide et support client",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: "À propos",
              subtitle: "Version 1.0.0",
              onTap: () {},
            ),
            
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: _buildSettingItem(
                  icon: Icons.logout,
                  title: "Déconnexion",
                  subtitle: "Se déconnecter de votre compte",
                  onTap: () {},
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  _showDeleteAccountDialog(context);
                },
                child: const Text(
                  "Supprimer le compte",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer le compte"),
        content: const Text("Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Suppression de compte en cours...")),
              );
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, 
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(subtitle, 
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      minVerticalPadding: 0,
      dense: true,
    );
  }
}