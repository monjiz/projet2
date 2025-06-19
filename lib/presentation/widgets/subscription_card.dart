// lib/presentation/widgets/subscription_card.dart

import 'package:auth_firebase/data/models/plan.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SubscriptionCard({
    required this.plan,
    required this.onSelect,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(plan.planName),
        subtitle: Text('${plan.price.toStringAsFixed(2)} TND'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onSelect,
      ),
    );
  }
}
