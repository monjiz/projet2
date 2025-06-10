import 'package:auth_firebase/data/models/role_models.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_bloc.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_event.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_state.dart';
import 'package:auth_firebase/presentation/widgets/permission_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignPermissionsPage extends StatefulWidget {
  final Role role;

  const AssignPermissionsPage({super.key, required this.role});

  @override
  _AssignPermissionsPageState createState() => _AssignPermissionsPageState();
}

class _AssignPermissionsPageState extends State<AssignPermissionsPage> {
  late List<String> _selectedPermissionsLocal;
  List<String> _allAvailablePermissionNames = [];

  @override
  void initState() {
    super.initState();
    _selectedPermissionsLocal = List.from(widget.role.permissions);

    final currentState = context.read<RolePermissionBloc>().state;
    if (currentState is RolesAndPermissionsLoaded) {
      _allAvailablePermissionNames = currentState.permissions;
      _selectedPermissionsLocal.retainWhere((perm) => _allAvailablePermissionNames.contains(perm));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final blocState = context.read<RolePermissionBloc>().state;
          if (blocState is! RolesAndPermissionsLoaded && blocState is! RolePermissionLoading) {
            context.read<RolePermissionBloc>().add(const LoadRolesAndPermissions());
          }
        }
      });
    }
  }

  void _onPermissionsChanged(List<String> updatedSelectedPermissions) {
    setState(() {
      _selectedPermissionsLocal = updatedSelectedPermissions;
    });
  }

  void _submitPermissions() {
    final updatedRole = Role(
      id: widget.role.id,
      name: widget.role.name,
      description: widget.role.description,
      permissions: _selectedPermissionsLocal,
    );
    context.read<RolePermissionBloc>().add(UpdateRole(updatedRole));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<RolePermissionBloc>().state;
    final isLoading = state is RolePermissionLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text("Permissions pour ${widget.role.name}"),
        elevation: 2,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: BlocConsumer<RolePermissionBloc, RolePermissionState>(
        listener: (context, state) {
          if (state is RolePermissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Erreur : ${state.message}"),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.all(10),
              ),
            );
          } else if (state is RolesAndPermissionsLoaded) {
            if (mounted) {
              setState(() {
                _allAvailablePermissionNames = state.permissions;
                _selectedPermissionsLocal.retainWhere((perm) => _allAvailablePermissionNames.contains(perm));
              });
            }
            if (state.isRecentlyUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Permissions mises à jour avec succès"),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.all(10),
                ),
              );
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          Widget bodyContent;

          if (isLoading && _allAvailablePermissionNames.isEmpty) {
            bodyContent = const Center(child: CircularProgressIndicator());
          } else if (state is RolePermissionError && _allAvailablePermissionNames.isEmpty) {
            bodyContent = Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "Erreur de chargement",
                      style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
            );
          } else {
            bodyContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Attribuer des permissions au rôle :",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.role.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Permissions disponibles :",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading && _allAvailablePermissionNames.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  ),
                Expanded(
                  child: PermissionSelector(
                    allPermissions: _allAvailablePermissionNames,
                    selectedPermissions: _selectedPermissionsLocal,
                    onChanged: _onPermissionsChanged,
                  ),
                ),
              ],
            );
          }

          return bodyContent;
        },
      ),
      bottomNavigationBar: (_allAvailablePermissionNames.isEmpty && !isLoading)
          ? null
          : Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 10.0,
                bottom: 20.0 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitPermissions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text("Enregistrer les permissions"),
              ),
            ),
    );
  }
}
