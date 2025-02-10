import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityProvider with ChangeNotifier {
  final CollectionReference _communityCollection =
      FirebaseFirestore.instance.collection('community');

  List<DocumentSnapshot> _communityPosts = [];
  bool _isLoading = false;

  List<DocumentSnapshot> get communityPosts => _communityPosts;
  bool get isLoading => _isLoading;

  Future<void> fetchCommunityPosts() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _communityCollection.get();
      _communityPosts = snapshot.docs;
    } catch (e) {
      print('Error fetching community posts: $e');
      _communityPosts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCommunityPost(Map<String, dynamic> postData) async {
    try {
      await _communityCollection.add(postData);
      fetchCommunityPosts();
    } catch (e) {
      print('Error adding community post: $e');
      throw e;
    }
  }
}
