import 'package:flutter/material.dart';
import 'package:auth_firebase/data/services/api_service.dart';
import 'package:auth_firebase/data/models/message_model.dart';
import 'messages_detail_page.dart'; // Import de la page de détails
import 'package:uuid/uuid.dart'; // Ajout de la dépendance uuid pour générer un messageId unique

class _AppColors {
  static const Color background = Color.fromARGB(255, 255, 255, 255);
  static const Color backButtonBackground = Color(0xFF3B82F6);
  static const Color backButtonIcon = Colors.white;
  static const Color primaryText = Color(0xFF071A2F);
  static const Color secondaryText = Colors.black54;
  static const Color buttonBackground = Color(0xFF3B82F6);
  static const Color buttonText = Colors.white;
  static const Color floatingButtonBackground = Color(0xFFFFA1B4); // Nouvelle couleur pour le FloatingActionButton
}

class _AppSpacings {
  static const double screenPadding = 24.0;
  static const double s14 = 14.0;
  static const double s20 = 20.0;
  static const double s5 = 5.0;
  static const double s40 = 40.0;
}

class _AppDimens {
  static const double backButtonRadius = 36.0;
  static const double imageHeigh = 250.0;
  static const double buttonBorderRadius = 30.0;
}

class _AppFontSizes {
  static const double title = 24.0;
  static const double body = 16.0;
  static const double button = 16.0;
}

class MessagesListPage extends StatefulWidget {
  final ApiService apiService;
  final String userType;

  const MessagesListPage({
    super.key,
    required this.apiService,
    required this.userType,
  });

  @override
  State<MessagesListPage> createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  late Future<List<Message>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = widget.apiService.fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(
            top: _AppSpacings.s14,
            bottom: _AppSpacings.s14,
            left: _AppSpacings.s14,
          ),
          decoration: BoxDecoration(
            color: _AppColors.backButtonBackground,
            borderRadius: BorderRadius.circular(_AppDimens.backButtonRadius),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: _AppColors.backButtonIcon,
              size: 20,
            ),
            tooltip: 'Go Back',
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/splash');
              }
            },
          ),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: _AppColors.backButtonIcon,
            fontSize: _AppFontSizes.title,
          ),
        ),
        backgroundColor: _AppColors.buttonBackground,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: _AppColors.backButtonIcon,
            ),
            tooltip: 'Search Messages',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recherche non implémentée')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _AppColors.floatingButtonBackground,
        tooltip: 'New Conversation',
        onPressed: () {
          final newMessageId = const Uuid().v4(); // Génère un ID unique
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MessageDetailPage(
                apiService: widget.apiService,
                userType: widget.userType,
                messageId: newMessageId,
                recipient: '', // À personnaliser (par exemple, via une sélection d'utilisateur)
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: _AppColors.backButtonIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            tooltip: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
        selectedItemColor: _AppColors.buttonBackground,
        unselectedItemColor: _AppColors.secondaryText,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/profile');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
      body: FutureBuilder<List<Message>>(
        future: _messagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: _AppColors.buttonBackground,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(_AppSpacings.screenPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Erreur : ${snapshot.error}',
                      style: TextStyle(
                        color: _AppColors.primaryText,
                        fontSize: _AppFontSizes.body,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.buttonBackground,
                      ),
                      onPressed: () {
                        setState(() {
                          _messagesFuture = widget.apiService.fetchMessages();
                        });
                      },
                      child: const Text(
                        'Réessayer',
                        style: TextStyle(color: _AppColors.backButtonIcon),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucun message',
                style: TextStyle(
                  color: _AppColors.secondaryText,
                  fontSize: _AppFontSizes.body,
                ),
              ),
            );
          }

          final messages = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(_AppSpacings.screenPadding),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  key: ValueKey(message.id),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      message.destinataire.isNotEmpty
                          ? message.destinataire[0].toUpperCase()
                          : 'N/A',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    message.destinataire.isNotEmpty
                        ? message.destinataire
                        : 'Utilisateur inconnu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _AppColors.primaryText,
                      fontSize: _AppFontSizes.body,
                    ),
                  ),
                  subtitle: Text(
                    message.contenu.isNotEmpty ? message.contenu : 'Aucun contenu',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _AppColors.secondaryText,
                      fontSize: _AppFontSizes.body - 2,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message.date.isNotEmpty ? message.date : 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _AppColors.secondaryText,
                        ),
                      ),
                      if (index == 0)
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.blue,
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 10,
                                color: _AppColors.backButtonIcon,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessageDetailPage(
                          apiService: widget.apiService,
                          userType: widget.userType,
                          messageId: message.id,
                          recipient: message.destinataire,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}