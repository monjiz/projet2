import 'package:auth_firebase/presentation/screens/ClientScreens/client_settings_screen.dart';
import 'package:flutter/material.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF3B82F6);
    final greyColor = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black, 
            fontSize: 18, 
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {

  //  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>  ClientSettingsScreen()),
                  );


            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/image.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Charlotte King",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "@johnkinggraphics",
                    style: TextStyle(
                      fontSize: 16,
                      color: greyColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 4,
                      shadowColor: primaryColor.withOpacity(0.5),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ..._buildListTiles(primaryColor, greyColor),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: greyColor,
              onPressed: () {},
              tooltip: 'Home',
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: greyColor,
              onPressed: () {},
              tooltip: 'Search',
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: primaryColor,
              onPressed: () {},
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListTiles(Color primaryColor, Color greyColor) {
    return [
      ListTile(
        leading: Icon(Icons.favorite, color: greyColor),
        title: const Text("Favourites"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
        hoverColor: primaryColor.withOpacity(0.1),
      ),
      ListTile(
        leading: Icon(Icons.download, color: greyColor),
        title: const Text("Downloads"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.language, color: greyColor),
        title: const Text("Language"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.location_on, color: greyColor),
        title: const Text("Location"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.subscriptions, color: greyColor),
        title: const Text("Subscription"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.delete, color: greyColor),
        title: const Text("Clear cache"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.history, color: greyColor),
        title: const Text("Clear history"),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.logout, color: primaryColor),
        title: Text("Log out", style: TextStyle(color: primaryColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
        onTap: () {},
      ),
    ];
  }
}
