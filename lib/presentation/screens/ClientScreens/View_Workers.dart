import 'package:flutter/material.dart';
import 'package:auth_firebase/data/models/user.dart';
import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewWorkersScreen extends StatefulWidget {
  const ViewWorkersScreen({super.key});

  @override
  State<ViewWorkersScreen> createState() => _ViewWorkersScreenState();
}

class _ViewWorkersScreenState extends State<ViewWorkersScreen> {
  final UserRepository _userRepository = UserRepository();
  late Future<List<UserModel>> _futureWorkers;

  @override
  void initState() {
    super.initState();
    _futureWorkers = _userRepository.fetchWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workers List', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _futureWorkers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: GoogleFonts.poppins(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No workers found.', style: GoogleFonts.poppins()),
            );
          } else {
            final workers = snapshot.data!;
            return ListView.builder(
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: const Icon(Icons.person),
                    ),
                    title: Text(worker.name ?? 'No Name', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text(worker.email, style: GoogleFonts.poppins()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Ajouter navigation ou détail ici
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
