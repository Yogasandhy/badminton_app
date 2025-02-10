import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CommunityProvider.dart';

class CommunityPostScreen extends StatelessWidget {
  final String lapanganId;
  final DateTime date;
  final String time;

  CommunityPostScreen({
    required this.lapanganId,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController genderController = TextEditingController();
    final TextEditingController levelController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Post to Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Selected Time: $time'),
            TextField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Preferred Gender'),
            ),
            TextField(
              controller: levelController,
              decoration: InputDecoration(labelText: 'Skill Level'),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Additional Notes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final postData = {
                  'lapanganId': lapanganId,
                  'date': date,
                  'time': time,
                  'gender': genderController.text,
                  'level': levelController.text,
                  'note': noteController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                };
                Provider.of<CommunityProvider>(context, listen: false)
                    .addCommunityPost(postData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Posted to community!')),
                );
                Navigator.of(context).pop();
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
