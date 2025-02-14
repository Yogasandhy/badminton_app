import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityProvider with ChangeNotifier {
  final CollectionReference _communityCollection =
      FirebaseFirestore.instance.collection('community');

  List<DocumentSnapshot> _communityPosts = [];
  bool _isLoading = false;

  List<DocumentSnapshot> get communityPosts => _communityPosts;
  bool get isLoading => _isLoading;

  // Getter untuk post pengguna saat ini
  List<DocumentSnapshot> get myPosts {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return _communityPosts.where((post) {
      final data = post.data() as Map<String, dynamic>;
      return data.containsKey('userId') && data['userId'] == currentUserId ||
             data.containsKey('joinedPlayers') && (data['joinedPlayers'] as List).contains(currentUserId);
    }).toList();
  }

  Future<void> fetchCommunityPosts() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      Future.microtask(() => notifyListeners());

      QuerySnapshot snapshot = await _communityCollection.get();
      _communityPosts = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data.containsKey('userId');
      }).toList();
    } catch (e) {
      print('Error fetching community posts: $e');
      _communityPosts = [];
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> addCommunityPost(Map<String, dynamic> postData) async {
    try {
      postData['userId'] = FirebaseAuth.instance.currentUser!.uid; // Tambahkan ID pengguna saat posting
      postData['status'] = 'active'; // Add status field
      DocumentReference postRef = await _communityCollection.add(postData);
      fetchCommunityPosts();

      // Set a timeout to expire the post if player requirement is not met within 1 minute (for testing)
      Future.delayed(Duration(minutes: 1), () async {
        DocumentSnapshot snapshot = await postRef.get();
        final data = snapshot.data() as Map<String, dynamic>;
        if (snapshot.exists && data['status'] == 'active' && data['joinedPlayers'].length < data['playerCount']) {
          await postRef.update({'status': 'expired'});
          fetchCommunityPosts(); // Ensure posts are fetched after updating status
        }
      });
    } catch (e) {
      print('Error adding community post: $e');
      throw e;
    }
  }

  Future<void> joinCommunityPost(String postId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference postRef = _communityCollection.doc(postId);
      await postRef.update({
        'joinedPlayers': FieldValue.arrayUnion([currentUserId]),
      });
      fetchCommunityPosts();
    } catch (e) {
      print('Error joining community post: $e');
      throw e;
    }
  }
}
