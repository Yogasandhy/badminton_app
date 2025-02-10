import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  final CollectionReference _bookingCollection =
      FirebaseFirestore.instance.collection('booking');
  
  // Store bookings for each lapangan and date combination
  Map<String, List<String>> bookedTimesMap = {};
  
  // Track loading state
  bool isLoading = false;

  // Get key for the map
  String _getKey(String lapanganId, DateTime date) {
    return '$lapanganId-${date.toIso8601String().split('T')[0]}';
  }

  // Check if time is booked
  bool isTimeBooked(String lapanganId, DateTime date, String time) {
    final key = _getKey(lapanganId, date);
    return bookedTimesMap[key]?.contains(time) ?? false;
  }

  // Clear bookings for specific lapangan and date
  void clearBookings(String lapanganId, DateTime date) {
    final key = _getKey(lapanganId, date);
    bookedTimesMap.remove(key);
    notifyListeners();
  }

  Future<void> addBooking(String lapanganId, DateTime date, String time, String status) async {
    final key = _getKey(lapanganId, date);
    
    try {
      await _bookingCollection.add({
        'lapanganId': lapanganId,
        'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
        'time': time,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      bookedTimesMap[key] ??= [];
      bookedTimesMap[key]!.add(time);
      notifyListeners();
    } catch (e) {
      print('Error adding booking: $e');
      throw e;
    }
  }

  Future<void> getBookings(String lapanganId, DateTime date) async {
    final key = _getKey(lapanganId, date);
    
    try {
      isLoading = true;
      notifyListeners();

      // Query for the specific date (midnight to midnight)
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      startOfDay.add(Duration(days: 1));

      QuerySnapshot snapshot = await _bookingCollection
          .where('lapanganId', isEqualTo: lapanganId)
          .where('date', isEqualTo: Timestamp.fromDate(startOfDay))
          .get();

      // Update the map with new data
      bookedTimesMap[key] = snapshot.docs
          .map((doc) => doc.get('time') as String)
          .toList();

    } catch (e) {
      print('Error getting bookings: $e');
      bookedTimesMap[key] = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}