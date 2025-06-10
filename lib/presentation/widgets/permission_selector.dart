import 'package:flutter/material.dart';

class PermissionSelector extends StatefulWidget {
  final List<String> allPermissions; // Noms des permissions
  final List<String> selectedPermissions; // Noms des permissions sélectionnées
  final Function(List<String>) onChanged;

  PermissionSelector({
    Key? key,
    required this.allPermissions,
    required this.selectedPermissions,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PermissionSelectorState createState() => _PermissionSelectorState();
}

class _PermissionSelectorState extends State<PermissionSelector> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedPermissions);
  }

  @override
  void didUpdateWidget(covariant PermissionSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPermissions != oldWidget.selectedPermissions) {
      _selected = List.from(widget.selectedPermissions);
    }
    // Si allPermissions change et que des permissions sélectionnées n'existent plus,
    // il faudrait les retirer de _selected.
    if (widget.allPermissions != oldWidget.allPermissions) {
        _selected.retainWhere((perm) => widget.allPermissions.contains(perm));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.allPermissions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined, // Icône plus pertinente
                size: 72,
                color: theme.colorScheme.primary.withOpacity(0.6),
              ),
              SizedBox(height: 20),
              Text(
                "Aucune permission disponible",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Il semble qu'aucune permission n'ait été définie ou chargée. Veuillez vérifier la configuration ou créer des permissions si nécessaire.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5, // Améliore la lisibilité
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: widget.allPermissions.length,
      itemBuilder: (context, index) {
        final permissionName = widget.allPermissions[index];
        final bool isSelected = _selected.contains(permissionName);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selected.remove(permissionName);
                } else {
                  _selected.add(permissionName);
                }
                widget.onChanged(List.from(_selected));
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selected.add(permissionName);
                        } else {
                          _selected.remove(permissionName);
                        }
                        widget.onChanged(List.from(_selected));
                      });
                    },
                    activeColor: theme.primaryColor,
                    visualDensity: VisualDensity.compact,
                    // Améliore l'apparence du checkbox
                    side: BorderSide(
                        color: isSelected ? theme.primaryColor : theme.dividerColor,
                        width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      permissionName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: theme.primaryColor, size: 22),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 20, // Alignement avec le texte après checkbox
        endIndent: 20,
        thickness: 0.5,
      ),
    );
  }
}