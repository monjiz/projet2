import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:auth_firebase/data/models/features.dart';
import 'package:auth_firebase/data/models/plan.dart';
import 'package:auth_firebase/logique(bloc)/subscription/subscription_bloc.dart';
import 'package:auth_firebase/logique(bloc)/subscription/subscription_event.dart';
import 'package:auth_firebase/logique(bloc)/user/user_bloc.dart';
import 'package:auth_firebase/logique(bloc)/user/user_state.dart';
import 'package:auth_firebase/logique(bloc)/user/user_event.dart';

class CreateEditSubscriptionScreen extends StatefulWidget {
  final Plan? plan;

  const CreateEditSubscriptionScreen({Key? key, this.plan}) : super(key: key);

  @override
  State<CreateEditSubscriptionScreen> createState() =>
      _CreateEditSubscriptionScreenState();
}

class _CreateEditSubscriptionScreenState
    extends State<CreateEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late bool _apiAccess;
  late String _support;

  String? _selectedClientId;
  String? _selectedWorkerId;

  bool get isEdit => widget.plan != null;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUsers());

    final p = widget.plan;
    _nameCtrl = TextEditingController(text: p?.planName ?? '');
    _priceCtrl = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(2) : '');
    _apiAccess = p?.features.apiAccess ?? false;
    _support = p?.features.support ?? 'standard';
    _selectedClientId = p?.clientId;
    _selectedWorkerId = p?.workerId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClientId == null || _selectedWorkerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionnez un client et un travailleur')),
      );
      return;
    }

    final planToSend = Plan(
      id: isEdit ? widget.plan!.id : const Uuid().v4(),
      planName: _nameCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.replaceAll(',', '.')),
      features: Features(
        projectLimit: widget.plan?.features.projectLimit ?? 1,
        taskRecommendations: widget.plan?.features.taskRecommendations ?? 'basic',
        workerRecommendations:
            widget.plan?.features.workerRecommendations ?? 'basic',
        analytics: widget.plan?.features.analytics ?? ['skills'],
        teamCollaboration: widget.plan?.features.teamCollaboration ?? 1,
        apiAccess: _apiAccess,
        support: _support,
        customBranding: widget.plan?.features.customBranding ?? false,
        jobPostLimit: widget.plan?.features.jobPostLimit ?? 1,
        cvViewLimit: widget.plan?.features.cvViewLimit ?? 1,
        cvUploadLimit: widget.plan?.features.cvUploadLimit ?? 1,
        jobApplicationLimit: widget.plan?.features.jobApplicationLimit ?? 1,
      ),
      userType: 'worker',
      clientId: _selectedClientId!,
      workerId: _selectedWorkerId!,
    );

    if (isEdit) {
      context.read<SubscriptionBloc>().add(UpdatePlan(widget.plan!.id, planToSend));
    } else {
      context.read<SubscriptionBloc>().add(AddPlan(planToSend));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier Abonnement' : 'Créer Abonnement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            } else if (state is UserLoaded) {
              final clients = state.users
                  .where((user) => user.type.toLowerCase() == 'client')
                  .toList();
              final workers = state.users
                  .where((user) => user.type.toLowerCase() == 'worker')
                  .toList();

              if (_selectedClientId != null &&
                  !clients.any((u) => u.id == _selectedClientId)) {
                _selectedClientId = null;
              }

              if (_selectedWorkerId != null &&
                  !workers.any((u) => u.id == _selectedWorkerId)) {
                _selectedWorkerId = null;
              }

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nom du plan'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Obligatoire' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceCtrl,
                      decoration: const InputDecoration(labelText: 'Prix'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => v == null ||
                              double.tryParse(v.replaceAll(',', '.')) == null
                          ? 'Entrez un nombre valide'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedClientId,
                      decoration: const InputDecoration(labelText: 'Client'),
                      items: clients
                          .map((user) => DropdownMenuItem(
                                value: user.id,
                                child: Text(user.name),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedClientId = v),
                      validator: (v) =>
                          v == null ? 'Sélectionnez un client' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedWorkerId,
                      decoration: const InputDecoration(labelText: 'Travailleur'),
                      items: workers
                          .map((user) => DropdownMenuItem(
                                value: user.id,
                                child: Text(user.name),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedWorkerId = v),
                      validator: (v) =>
                          v == null ? 'Sélectionnez un travailleur' : null,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('API Access'),
                      value: _apiAccess,
                      onChanged: (b) => setState(() => _apiAccess = b),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _support,
                      decoration: const InputDecoration(labelText: 'Support'),
                      items: ['standard', 'enterprise']
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (s) => setState(() => _support = s!),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(isEdit ? 'Enregistrer' : 'Ajouter'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
