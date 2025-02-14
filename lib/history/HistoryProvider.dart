import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryProvider with ChangeNotifier {
  final CollectionReference _bookingCollection =
      FirebaseFirestore.instance.collection('booking');

  List<DocumentSnapshot> _activeBookings = [];
  List<DocumentSnapshot> _completedBookings = [];
  List<DocumentSnapshot> _canceledBookings = [];
  List<DocumentSnapshot> _pendingPaymentBookings = []; // Add new list
  bool _isLoading = false;

  List<DocumentSnapshot> get activeBookings => _activeBookings;
  List<DocumentSnapshot> get completedBookings => _completedBookings;
  List<DocumentSnapshot> get canceledBookings => _canceledBookings;
  List<DocumentSnapshot> get pendingPaymentBookings => _pendingPaymentBookings; // Add getter
  bool get isLoading => _isLoading;

  Future<void> fetchHistory() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      Future.microtask(() => notifyListeners());

      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _bookingCollection
          .where('userIds', arrayContains: currentUserId)
          .get();

      _pendingPaymentBookings = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == 'pending'; // Filter for pending payment
      }).toList();

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
      _pendingPaymentBookings = []; // Clear list on error
      _activeBookings = [];
      _completedBookings = [];
      _canceledBookings = [];
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> addPendingBooking({
    required String lapanganId,
    required DateTime date,
    required String time,
    required int price,
    required List<String> playerIds,
  }) async {
    try {
      DocumentReference bookingRef = await _bookingCollection.add({
        'lapanganId': lapanganId,
        'date': Timestamp.fromDate(date),
        'time': time,
        'status': 'pending',
        'price': price,
        'userIds': playerIds, // Store list of user IDs
        'createdAt': FieldValue.serverTimestamp(),
      });
      await fetchHistory(); // Ensure history is fetched after adding booking

      // Set a timeout to cancel the booking if not paid within 5 minutes
      Future.delayed(Duration(minutes: 5), () async {
        DocumentSnapshot snapshot = await bookingRef.get();
        if (snapshot.exists && snapshot.get('status') == 'pending') {
          await bookingRef.update({'status': 'canceled'});
          await fetchHistory(); // Ensure history is fetched after updating status
        }
      });
    } catch (e) {
      print('Error adding pending booking: $e');
      throw e;
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _bookingCollection.doc(bookingId).update({'status': status});
      await fetchHistory(); // Ensure history is fetched after updating status
    } catch (e) {
      print('Error updating booking status: $e');
      throw e;
    }
  }

  Future<void> updateBookingStatusByDetails({
    required String lapanganId,
    required DateTime date,
    required String time,
    required String status,
  }) async {
    try {
      QuerySnapshot snapshot = await _bookingCollection
          .where('lapanganId', isEqualTo: lapanganId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('time', isEqualTo: time)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'status': status});
      }
      await fetchHistory(); // Ensure history is fetched after updating status
    } catch (e) {
      print('Error updating booking status by details: $e');
      throw e;
    }
  }

  Future<void> addBooking({
    required String lapanganId,
    required DateTime date,
    required String time,
    required int price,
    required String status,
  }) async {
    try {
      await _bookingCollection.add({
        'lapanganId': lapanganId,
        'date': Timestamp.fromDate(date),
        'time': time,
        'status': status,
        'price': price,
        'userIds': [FirebaseAuth.instance.currentUser!.uid], // Store list of user IDs
        'createdAt': FieldValue.serverTimestamp(),
      });
      await fetchHistory(); // Ensure history is fetched after adding booking
    } catch (e) {
      print('Error adding booking: $e');
      throw e;
    }
  }
}
