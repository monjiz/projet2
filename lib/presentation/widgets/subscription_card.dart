import 'package:auth_firebase/data/models/plan.dart';
import 'package:flutter/material.dart';


class SubscriptionCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onSelect;

  const SubscriptionCard({required this.plan, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1877F2),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${plan.price} €/mois',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            ...plan.benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $benefit', style: const TextStyle(fontSize: 16, color: Colors.black54)),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Souscrire',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}