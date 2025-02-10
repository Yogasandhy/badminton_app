import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String gender;
  final String level;
  final String note;
  final String time;

  CommunityCard({
    required this.gender,
    required this.level,
    required this.note,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
