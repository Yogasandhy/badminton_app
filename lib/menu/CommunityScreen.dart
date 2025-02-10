import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CommunityProvider.dart';
import 'CommunityCard.dart';

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Consumer<CommunityProvider>(
        builder: (context, communityProvider, child) {
          if (communityProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (communityProvider.communityPosts.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          return ListView.builder(
            itemCount: communityProvider.communityPosts.length,
            itemBuilder: (context, index) {
              var post = communityProvider.communityPosts[index];
              return CommunityCard(
                gender: post['gender'],
                level: post['level'],
                note: post['note'],
                time: post['time'],
              );
            },
          );
        },
      ),
    );
  }
}
