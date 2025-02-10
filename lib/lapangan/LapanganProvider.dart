import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LapanganProvider with ChangeNotifier {
  final CollectionReference _lapanganCollection =
      FirebaseFirestore.instance.collection('lapangan');

  List<DocumentSnapshot> _lapanganList = [];
  bool _isLoading = false;

  List<DocumentSnapshot> get lapanganList => _lapanganList;
  bool get isLoading => _isLoading;

  Future<void> fetchLapangan() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _lapanganCollection.get();
      
      if (snapshot.docs.isEmpty) {
        await _initializeLapanganCollection();
        snapshot = await _lapanganCollection.get();
      }
      
      _lapanganList = snapshot.docs;
      
    } catch (e) {
      print('Error fetching lapangan: $e');
      _lapanganList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initializeLapanganCollection() async {
    final List<Map<String, dynamic>> lapanganData = [
      {'name': 'Lapangan 1', 'createdAt': FieldValue.serverTimestamp()},
      {'name': 'Lapangan 2', 'createdAt': FieldValue.serverTimestamp()},
      {'name': 'Lapangan 3', 'createdAt': FieldValue.serverTimestamp()},
      {'name': 'Lapangan 4', 'createdAt': FieldValue.serverTimestamp()},
    ];

    for (var lapangan in lapanganData) {
      await _lapanganCollection.add(lapangan);
    }
  }

  @override
  void dispose() {
    _lapanganList = [];
    super.dispose();
  }
}