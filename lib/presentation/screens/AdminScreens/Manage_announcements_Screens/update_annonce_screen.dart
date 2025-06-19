// Fichier : update_annonce_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase/data/models/annonce_models.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_bloc.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_event.dart';

class UpdateAnnonceScreen extends StatefulWidget {
  final bool isEdit;
  final Annonce? announcement;

  const UpdateAnnonceScreen(
      {super.key, required this.isEdit, this.announcement});

  @override
  State<UpdateAnnonceScreen> createState() => _UpdateAnnonceScreenState();
}

class _UpdateAnnonceScreenState extends State<UpdateAnnonceScreen> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TextEditingController typeCtrl;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(
        text: widget.isEdit ? widget.announcement?.title : '');
    descCtrl = TextEditingController(
        text: widget.isEdit ? widget.announcement?.content : '');
    typeCtrl = TextEditingController(
        text: widget.isEdit ? widget.announcement?.type : '');
    selectedDate = widget.isEdit && widget.announcement != null
        ? DateTime.parse(widget.announcement!.publishedAt).toLocal()
        : DateTime.now();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveAnnonce() {
    final title = titleCtrl.text.trim();
    final desc = descCtrl.text.trim();
    final type = typeCtrl.text.trim();

    if (title.isEmpty || desc.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont requis.")),
      );
      return;
    }

    final id = widget.isEdit && widget.announcement != null
        ? widget.announcement!.id
        : DateTime.now().millisecondsSinceEpoch.toString();

    final utcDate = selectedDate.toUtc();
    final isoDate = utcDate.toIso8601String();

    // Ajoute ce log ici pour voir la date envoyée
    debugPrint('Date envoyée au backend : $isoDate');

    final newAnn = Annonce(
      id: id,
      title: title,
      content: desc,
      type: type,
      publishedAt: isoDate,
    );

    if (widget.isEdit) {
      context.read<AnnouncementBloc>().add(EditAnnouncement(id, newAnn));
    } else {
      context.read<AnnouncementBloc>().add(AddAnnouncement(newAnn));
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Modifier l\'annonce' : 'Nouvelle annonce'),
        backgroundColor: const Color.fromARGB(255, 139, 47, 197),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                controller: titleCtrl,
                label: 'Titre',
                hintText: 'Ajouter un titre',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: descCtrl,
                label: 'Description',
                hintText: 'Décrivez votre annonce',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: typeCtrl,
                label: 'Type',
                hintText: 'Ex: éducation, événement, offre...',
              ),
              const SizedBox(height: 24),
              Text(
                'Date de publication',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 20, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        'Modifier',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveAnnonce,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  widget.isEdit ? 'Mettre à jour' : 'Publier',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
