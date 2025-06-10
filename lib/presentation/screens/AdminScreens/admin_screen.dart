import 'package:auth_firebase/presentation/screens/paimentScreens/payment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/manage_roles_page.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/manage_projects_screen.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/manage_users_screen.dart';
import 'package:auth_firebase/presentation/screens/paimentScreens/subscriptions_screen.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/announcements_screen.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/notifications_screen.dart';
//import 'package:auth_firebase/presentation/screens/AdminScreens/manage_landing_page_screen.dart';
//import 'package:auth_firebase/auth/login_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AnnouncementsScreen()));
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final String adminName = "Admin SuperUser";
    final String adminEmail = "admin@example.com";
    final String adminAvatarUrl = "";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              adminName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(adminEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: adminAvatarUrl.isNotEmpty
                  ? NetworkImage(adminAvatarUrl)
                  : null,
              child: adminAvatarUrl.isEmpty
                  ? Text(
                      adminName.isNotEmpty ? adminName[0].toUpperCase() : "A",
                      style: TextStyle(
                          fontSize: 40.0,
                          color: Theme.of(context).primaryColor),
                    )
                  : null,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                  _showSnack(context, "Edit profile (not implemented)");
                },
                tooltip: "Edit profile",
              )
            ],
          ),
          _buildDrawerItem(
            iconId: Icons.dashboard_customize_outlined,
            textLabel: 'Dashboard',
            onTapCallback: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            iconId: Icons.group_outlined,
            textLabel: 'Manage Users',
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ManageUsersScreen()));
            },
          ),
          _buildDrawerItem(
            iconId: Icons.folder_shared_outlined,
            textLabel: 'Manage Projects',
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminManageProjectsScreen()));
            },
          ),
          _buildDrawerItem(
            iconId: Icons.security_outlined,
            textLabel: 'Roles and Permissions',
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ManageRolesPage()));
            },
          ),
          const Divider(),
          _buildDrawerItem(
            iconId: Icons.person_outline,
            textLabel: 'My Admin Profile',
            onTapCallback: () {
              Navigator.pop(context);
              _showSnack(context, "My Admin Profile (not implemented)");
            },
          ),
          _buildDrawerItem(
            iconId: Icons.settings,
            textLabel: 'Settings',
            onTapCallback: () {
              Navigator.pop(context);
              _showSnack(context, "Settings (not implemented)");
            },
          ),
          _buildDrawerItem(
            iconId: Icons.help_outline,
            textLabel: 'Help and Support',
            onTapCallback: () {
              Navigator.pop(context);
              _showSnack(context, "Help and Support (not implemented)");
            },
          ),
          const Divider(),
          _buildDrawerItem(
            iconId: Icons.logout,
            textLabel: 'Sign out',
            textColor: Colors.red.shade700,
            iconColor: Colors.red.shade700,
            onTapCallback: () async {
              Navigator.pop(context);
              try {
                // await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              } catch (eSignOut) {
                _showSnack(context, "Error during sign out: $eSignOut");
              }
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Version 1.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
      leading: Icon(iconId, color: iconColor ?? Colors.grey.shade700),
      title: Text(
        textLabel,
        style: TextStyle(
          color: textColor ?? Colors.grey.shade900,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTapCallback,
      dense: true,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search in admin...',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none_outlined,
              color: Theme.of(context).appBarTheme.iconTheme?.color ??
                  Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminNotificationScreen()));
          },
          tooltip: "Notifications",
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Admin Dashboard",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF071A2F))),
          const Text("What would you like to manage today?",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 24),
          _sectionTitle("Main Actions", onViewAll: () {
            _showSnack(context, "View all actions (not implemented)");
          }),
          const SizedBox(height: 12),
          _adminActionGrid(context),
          const SizedBox(height: 24),
          _sectionTitle("Quick Overview", onViewAll: () {
            _showSnack(context, "View more statistics (not implemented)");
          }),
          const SizedBox(height: 12),
          _quickStatsCards(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      elevation: 8.0,
      child: SizedBox(
        height: 70, // Increased height to accommodate content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(
              context,
              icon: Icons.dashboard_rounded,
              label: "Dashboard",
              isSelected: true,
              onPressed: () {},
            ),
            _buildBottomNavItem(
              context,
              icon: Icons.notifications_outlined,
              label: "Alerts",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminNotificationScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 40), // Space for the FAB
            _buildBottomNavItem(
              context,
              icon: Icons.bar_chart_outlined,
              label: "Stats",
              onPressed: () {
                _showSnack(context, "Navigation to detailed statistics");
              },
            ),
            _buildBottomNavItem(
              context,
              icon: Icons.settings_outlined,
              label: "Settings",
              onPressed: () {
                _showSnack(context, "Navigation to Admin settings");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onPressed,
  }) {
    final color =
        isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600;
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20), // Reduced icon size
              const SizedBox(height: 1), // Reduced spacing
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 9, // Reduced font size
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminActionGrid(BuildContext context) {
    final actions = [
      _AdminAction("Users", Icons.group_outlined, const Color(0xFF0B4F8A), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ManageUsersScreen()));
      }),
      _AdminAction("Subscriptions", Icons.subscriptions_outlined,
          const Color(0xFF1399DC), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) =>  SubscriptionScreen()));
      }),
      _AdminAction(
          "Announcements", Icons.campaign_outlined, const Color(0xFFEE7048),
          () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AnnouncementsScreen()));
      }),
      _AdminAction("Payments", Icons.payment_outlined, const Color(0xFF34A853),
          () {
        // Ensure PaymentDetailsScreen.routeName is defined in main.dart and in PaymentDetailsScreen.dart
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => PaymentDetailsScreen()));
      }),
      _AdminAction("Landing Page", Icons.web_outlined, const Color(0xFFB175F9),
          () {
       // Navigator.push(context,
      //      MaterialPageRoute(builder: (_) => const ManageLandingPageScreen()));
      }),
      _AdminAction("Roles and Permissions", Icons.security_outlined,
          const Color(0xFFFABB05), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ManageRolesPage()));
      }),
      _AdminAction(
          "Projects (All)", Icons.folder_open_outlined, const Color(0xFF5C6BC0),
          () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AdminManageProjectsScreen()));
      }),
      _AdminAction("Content/Reports", Icons.report_problem_outlined,
          const Color(0xFFE53935), () {
        _showSnack(context, "Manage content and reports (not implemented)");
      }),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          color: action.color.withOpacity(0.9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          shadowColor: action.color.withOpacity(0.3),
          child: InkWell(
            onTap: action.onPressed,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(action.icon, size: 30, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    action.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _quickStatsCards() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _quickStatCard("Active Users", "1,234",
              Icons.person_pin_circle_outlined, Colors.blue.shade700),
          const SizedBox(width: 12),
          _quickStatCard("Revenue (Month)", "€5,678",
              Icons.account_balance_wallet_outlined, Colors.green.shade700),
          const SizedBox(width: 12),
          _quickStatCard("Ongoing Projects", "89", Icons.assessment_outlined,
              Colors.orange.shade700),
          const SizedBox(width: 12),
          _quickStatCard("Support Tickets", "12",
              Icons.contact_support_outlined, Colors.red.shade700),
        ],
      ),
    );
  }

  Widget _quickStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500)),
              ),
              Icon(icon, size: 22, color: color.withOpacity(0.8)),
            ],
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF071A2F))),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("View All",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}

class _AdminAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  _AdminAction(this.label, this.icon, this.color, this.onPressed);
}
