import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityCard extends StatelessWidget {
  final String gender;
  final String level;
  final String note;
  final String time;
  final int playerCount;
  final List<String> joinedPlayers;
  final String userId;
  final VoidCallback onJoin;

  CommunityCard({
    required this.gender,
    required this.level,
    required this.note,
    required this.time,
    required this.playerCount,
    required this.joinedPlayers,
    required this.userId,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    int totalPlayers = joinedPlayers.length + 1; // Include the post creator

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: $time', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Preferred Gender: $gender'),
            Text('Skill Level: $level'),
            Text('Note: $note'),
            Text('Players: $totalPlayers/$playerCount'),
            if (totalPlayers < playerCount && currentUserId != userId && !joinedPlayers.contains(currentUserId))
              ElevatedButton(
                onPressed: onJoin,
                child: Text('Join'),
              ),
          ],
        ),
      ),
    );
  }
}
