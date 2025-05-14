import 'package:flutter/material.dart';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/widgets/button.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final auth = AuthService();
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Client",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign Out",
              onPressed: () async {
                await auth.signout();
                goToLogin(context);
              },
            )
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
  }
