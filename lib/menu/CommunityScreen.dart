import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/menu/CommunityDetailScreen.dart';
import 'CommunityProvider.dart';
import 'CommunityCard.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<CommunityProvider>(context, listen: false).fetchCommunityPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Global'),
            Tab(text: 'My Post'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostList(context, isGlobal: true),
          _buildPostList(context, isGlobal: false),
        ],
      ),
    );
  }

  Widget _buildPostList(BuildContext context, {required bool isGlobal}) {
    return Consumer<CommunityProvider>(
      builder: (context, communityProvider, child) {
        if (communityProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        var posts = isGlobal
            ? communityProvider.communityPosts
            : communityProvider.myPosts; // Filter posts for "My Post" tab

        if (posts.isEmpty) {
          return Center(child: Text('No posts available.'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var post = posts[index];
            final data = post.data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommunityDetailScreen(post: post),
                  ),
                );
              },
              child: CommunityCard(
                gender: data['gender'],
                level: data['level'],
                note: data['note'],
                time: data['time'],
                playerCount: data['playerCount'],
                joinedPlayers: List<String>.from(data['joinedPlayers']),
                userId: data['userId'],
                price: data['price'], // Pass price to CommunityCard
                onJoin: () async {
                  await Provider.of<CommunityProvider>(context, listen: false)
                      .joinCommunityPost(post.id);
                },
                lapanganId: data['lapanganId'], // Pass lapanganId to CommunityCard
                date: data['date'].toDate(), // Pass date to CommunityCard
                status: data['status'] ?? 'active', // Provide default value for status
              ),
            );
          },
        );
      },
    );
  }
}