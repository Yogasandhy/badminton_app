import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/menu/BottomNavBar.dart';
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
    final TextEditingController noteController = TextEditingController();
    String selectedGender = 'Anyone';
    String selectedLevel = 'Amateur';

    return Scaffold(
      appBar: AppBar(
        title: Text('Post to Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Selected Time: $time'),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Male', 'Female', 'Anyone'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedGender = newValue!;
              },
              decoration: InputDecoration(labelText: 'Preferred Gender'),
            ),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              items: ['Amateur', 'Medium', 'Professional'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedLevel = newValue!;
              },
              decoration: InputDecoration(labelText: 'Skill Level'),
            ),
            DropdownButtonFormField<int>(
              value: 2,
              items: [2, 4].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('${value ~/ 2} vs ${value ~/ 2}'),
                );
              }).toList(),
              onChanged: (newValue) {
                // Handle player count selection
              },
              decoration: InputDecoration(labelText: 'Number of Players'),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Additional Notes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final postData = {
                  'lapanganId': lapanganId,
                  'date': date,
                  'time': time,
                  'gender': selectedGender,
                  'level': selectedLevel,
                  'note': noteController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                  'playerCount': 4, // Update player count to reflect 2 vs 2
                  'joinedPlayers': [], // Initialize joined players list
                };
                await Provider.of<CommunityProvider>(context, listen: false)
                    .addCommunityPost(postData);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Posted to community!')),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
