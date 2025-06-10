import 'package:flutter/material.dart';
import 'dart:async'; // Pour Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Pour l'animation de fondu (fade-in)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Pour l'animation de la petite phrase (optionnel)
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Durée de l'animation du logo
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn, // Courbe d'animation pour le logo
      ),
    );

    // Animation pour le texte, commençant un peu après le logo
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.5, // Commence à 50% de la durée de _animationController
          1.0, // Finit à 100%
          curve: Curves.easeIn,
        ),
      ),
    );


    // Démarrer l'animation
    _animationController.forward();

    // Redirection après un certain temps
    Timer(const Duration(seconds: 5), () {
      if (mounted) { // Vérifie si le widget est toujours dans l'arbre des widgets
        Navigator.pushReplacementNamed(context, '/onboarding1');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Très important pour éviter les fuites de mémoire
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
           Color.fromARGB(255, 248, 249, 250), Color.fromARGB(255, 238, 240, 240) // Un bleu un peu plus sombre ou une autre teinte
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0], // Optionnel, pour contrôler la transition
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo animé
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 280, // Ajustez la taille si besoin
                  height: 280,
                ),
              ),
              const SizedBox(height: 20), // Espace entre le logo et le texte/indicateur

              // Optionnel: Un slogan ou un message animé
              FadeTransition(
                opacity: _textFadeAnimation, // Utilise la même animation ou une dédiée
                child: const Text(
                  "Votre App, Réinventée.", // Remplacez par votre slogan
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(179, 38, 143, 224), // Un blanc légèrement transparent
                    fontWeight: FontWeight.w300, // Police plus légère
                  ),
                ),
              ),

              const SizedBox(height: 40), // Espace avant l'indicateur

              // Optionnel: Indicateur de chargement
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 91, 171, 211)),
                strokeWidth: 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}