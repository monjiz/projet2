import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image avec contraintes de hauteur
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: Image.asset(
                          'assets/images/image3.png', 
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Titre avec taille réduite et contraintes
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Vision Assistance Accessible Anywhere",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21, // Taille réduite
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF071A2F),
                            height: 1.3, // Interligne augmenté
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Description avec texte ajusté
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Helping visually impaired individuals navigate their environment safely and independently with accessible assistance.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16, // Taille réduite
                            color: Colors.black54,
                            height: 1.5, // Interligne augmenté
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            // Bouton Next
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding2');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}