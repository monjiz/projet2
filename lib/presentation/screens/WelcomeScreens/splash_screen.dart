import 'package:flutter/material.dart';
import 'dart:async'; // Pour Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Pour l'animation de fondu (fade-in)
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Pour l'animation de la petite phrase
  late Animation<double> _textFadeAnimation;

  // Pour l'animation de rotation de logo.png
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Contrôleur pour le fondu
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Durée de l'animation du logo
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn, // Courbe d'animation pour le logo
      ),
    );

    // Animation pour le texte, commençant un peu après le logo
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(
          0.5, // Commence à 50% de la durée
          1.0, // Finit à 100%
          curve: Curves.easeIn,
        ),
      ),
    );

    // Contrôleur pour la rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Durée d'un tour complet
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear, // Rotation continue
      ),
    );

    // Démarrer les animations
    _fadeController.forward();
    _rotationController.repeat(); // Répéter en continu

    // Redirection après un certain temps
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding1');
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose(); // Libérer le contrôleur de rotation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Dégradé en arrière-plan
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 248, 249, 250),
              Color.fromARGB(255, 238, 240, 240),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo principal animé (fondu)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 280,
                  height: 280,
                ),
              ),
              const SizedBox(height: 20), // Espace entre le logo et le texte

              // Slogan animé (commenté dans votre code, je le conserve tel quel)
              FadeTransition(
                opacity: _textFadeAnimation,
                // child: const Text(
                //   "Votre App, Réinventée.",
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Color.fromARGB(179, 38, 143, 224),
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),
              ),

              const SizedBox(height: 40), // Espace avant l'image animée

              // Image logo.png avec animation de rotation
              RotationTransition(
                turns: _rotationAnimation,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}