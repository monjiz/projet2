import 'package:auth_firebase/data/models/plan.dart';
import 'package:auth_firebase/presentation/widgets/subscription_card.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  SubscriptionScreen({super.key});

  final List<Plan> plans = [
    Plan(
      id: 'basic',
      name: 'Basic',
      price: 9.99,
      benefits: ['Accès limité aux fonctionnalités', 'Support standard'],
    ),
    Plan(
      id: 'premium',
      name: 'Premium',
      price: 19.99,
      benefits: ['Accès illimité', 'Support prioritaire', 'Contenu exclusif'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Abonnements Premium',
          style: TextStyle(color: Color.fromARGB(221, 0, 0, 0)), // Texte sombre pour contraster avec le fond blanc
        ),
        backgroundColor: Colors.white, // Fond blanc pour l'AppBar
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87, // Icône sombre pour contraster
          ),
          onPressed: () {
            Navigator.pop(context); // Retour à l'écran précédent
          },
        ),
        elevation: 1, // Ombre légère pour démarquer l'AppBar
      ),
      body: Container(
        color: const Color(0xFFF0F2F5),
        child: ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            return SubscriptionCard(
              plan: plans[index],
              onSelect: () {
                Navigator.pushNamed(context, '/summary', arguments: plans[index]);
              },
            );
          },
        ),
      ),
    );
  }
}