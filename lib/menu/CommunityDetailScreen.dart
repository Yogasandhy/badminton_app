import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDetailScreen extends StatelessWidget {
  final DocumentSnapshot post;

  CommunityDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    final data = post.data() as Map<String, dynamic>;
    final joinedPlayers = List<String>.from(data['joinedPlayers']);
    final chatController = TextEditingController();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    bool isPlayer = joinedPlayers.contains(currentUserId) || data['userId'] == currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${data['time']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Preferred Gender: ${data['gender']}'),
            Text('Skill Level: ${data['level']}'),
            Text('Note: ${data['note']}'),
            Text('Players: ${joinedPlayers.length + 1}/${data['playerCount']}'),
            SizedBox(height: 20),
            Text('Joined Players:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...joinedPlayers.map((playerId) => Text('Player')).toList(),
            SizedBox(height: 20),
            if (isPlayer)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('community')
                      .doc(post.id)
                      .collection('chats')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var messages = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        return ListTile(
                          title: Text(message['text']),
                          subtitle: Text(message['sender']),
                        );
                      },
                    );
                  },
                ),
              ),
            if (isPlayer)
              TextField(
                controller: chatController,
                decoration: InputDecoration(labelText: 'Enter your message'),
                onSubmitted: (message) async {
                  if (message.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('community')
                        .doc(post.id)
                        .collection('chats')
                        .add({
                      'text': message,
                      'sender': FirebaseAuth.instance.currentUser!.email,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    chatController.clear();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
