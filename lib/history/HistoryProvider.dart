import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryProvider with ChangeNotifier {
  final CollectionReference _bookingCollection =
      FirebaseFirestore.instance.collection('booking');

  List<DocumentSnapshot> _activeBookings = [];
  List<DocumentSnapshot> _completedBookings = [];
  List<DocumentSnapshot> _canceledBookings = [];
  bool _isLoading = false;

  List<DocumentSnapshot> get activeBookings => _activeBookings;
  List<DocumentSnapshot> get completedBookings => _completedBookings;
  List<DocumentSnapshot> get canceledBookings => _canceledBookings;
  bool get isLoading => _isLoading;

  Future<void> fetchHistory() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _bookingCollection
          .where('userId', isEqualTo: currentUserId)
          .get();

      _activeBookings = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'active';
      }).toList();

      _completedBookings = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'completed';
      }).toList();

      _canceledBookings = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'canceled';
      }).toList();
    } catch (e) {
      print('Error fetching booking history: $e');
      _activeBookings = [];
      _completedBookings = [];
      _canceledBookings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _bookingCollection.doc(bookingId).update({'status': status});
      fetchHistory();
    } catch (e) {
      print('Error updating booking status: $e');
      throw e;
    }
  }
}
