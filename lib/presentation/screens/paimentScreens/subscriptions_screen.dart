import 'package:auth_firebase/data/models/plan.dart';
import 'package:auth_firebase/logique(bloc)/subscription/subscription_bloc.dart';
import 'package:auth_firebase/logique(bloc)/subscription/subscription_event.dart';
import 'package:auth_firebase/logique(bloc)/subscription/subscription_state.dart';
import 'package:auth_firebase/presentation/screens/paimentScreens/add_subscription.dart';
import 'package:auth_firebase/presentation/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(LoadPlans());
  }

  void _confirmDelete(BuildContext context, String planId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cet abonnement ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SubscriptionBloc>().add(DeletePlan(planId));
              Navigator.of(context).pop();
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Abonnements Premium',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
      ),
      body: Container(
        color: const Color(0xFFF0F2F5),
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SubscriptionError) {
              return Center(child: Text('Erreur : ${state.message}'));
            } else if (state is SubscriptionLoaded) {
              final plans = state.plans;
              if (plans.isEmpty) {
                return const Center(child: Text('Aucun plan disponible.'));
              }
              return ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return SubscriptionCard(
                    plan: plan,
                    onSelect: () {
                      // Optionnel : action à définir si besoin
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateEditSubscriptionScreen(plan: plan),
                        ),
                      );
                    },
                    onDelete: () {
                      _confirmDelete(context, plan.id);
                    },
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateEditSubscriptionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
