import 'package:auth_firebase/data/services/api_service.dart';
import 'package:flutter/material.dart';

class MessageDetailPage extends StatefulWidget {
  final ApiService apiService;
  final String userType; // "Client", "Worker", ou "Admin"
  final String messageId;
  final String recipient;

  const MessageDetailPage({
    super.key,
    required this.apiService,
    required this.userType,
    required this.messageId,
    required this.recipient,
  });

  @override
  State<MessageDetailPage> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  late List<Map<String, dynamic>> _messages; // Déclaré comme late pour initialisation dans initState

  @override
  void initState() {
    super.initState();
    _messages = [
      {'sender': widget.recipient, 'content': 'I\'m meeting a friend here for dinner. How about you? 😄', 'time': '6:30 PM'},
      {'sender': 'Moi', 'content': 'I\'m doing my homework, but I really need to take a break.', 'time': '5:46 PM'},
      {'sender': widget.recipient, 'content': 'On my way home but I needed to stop by the book store to buy a text book. 😊', 'time': '5:49 PM'},
    ];
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'Moi',
          'content': _messageController.text,
          'time': '12:41 PM', // Heure actuelle (exemple)
        });
      });
      _messageController.clear();
      // TODO: Appeler l'API pour envoyer le message
      // widget.apiService.sendMessage(widget.messageId, _messageController.text);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.recipient,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          if (widget.userType == 'Admin')
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conversation supprimée')),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue[50],
            child: const Text(
              'Today',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'Moi';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['content'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['time'],
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.blue[700],
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}