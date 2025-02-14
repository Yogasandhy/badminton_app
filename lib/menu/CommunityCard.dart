import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/history/HistoryProvider.dart';
import 'package:ta_bultang/history/HistoryScreen.dart';
import 'package:ta_bultang/booking/BookingProvider.dart';

class CommunityCard extends StatelessWidget {
  final String gender;
  final String level;
  final String note;
  final String time;
  final int playerCount;
  final List<String> joinedPlayers;
  final String userId;
  final VoidCallback onJoin;
  final int price; // Add price field
  final String lapanganId; // Add lapanganId field
  final DateTime date; // Add date field
  final String status; // Add status field

  CommunityCard({
    required this.gender,
    required this.level,
    required this.note,
    required this.time,
    required this.playerCount,
    required this.joinedPlayers,
    required this.userId,
    required this.onJoin,
    required this.price, // Add price field
    required this.lapanganId, // Add lapanganId field
    required this.date, // Add date field
    required this.status, // Add status field
  });

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    int totalPlayers = joinedPlayers.length + 1; // Include the post creator
    int sharedPrice = (price / playerCount).round(); // Calculate shared price per player

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: $time', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Preferred Gender: $gender'),
            Text('Skill Level: $level'),
            Text('Note: $note'),
            Text('Players: $totalPlayers/$playerCount'),
            Text('Total Price: Rp $price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Display total price
            Text('Price per Player: Rp $sharedPrice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Display shared price
            if (status == 'canceled' || status == 'expired') ...[
              ElevatedButton(
                onPressed: null,
                child: Text('Expired'),
              ),
              if (currentUserId == userId)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Expired', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
            ] else if (totalPlayers < playerCount && currentUserId != userId && !joinedPlayers.contains(currentUserId))
              ElevatedButton(
                onPressed: onJoin,
                child: Text('Join'),
              ),
            if (totalPlayers == playerCount && currentUserId == userId && status != 'expired' && status != 'canceled')
              Consumer2<HistoryProvider, BookingProvider>(
                builder: (context, historyProvider, bookingProvider, child) {
                  bool isPending = historyProvider.pendingPaymentBookings.any((booking) =>
                      (booking['userIds'] as List).contains(currentUserId) &&
                      booking['lapanganId'] == lapanganId &&
                      booking['date'].toDate() == date &&
                      booking['time'] == time);

                  return ElevatedButton(
                    onPressed: isPending
                        ? null
                        : () async {
                            // Add booking to pending state
                            await Provider.of<HistoryProvider>(context, listen: false).addPendingBooking(
                              lapanganId: lapanganId,
                              date: date,
                              time: time,
                              price: sharedPrice,
                              playerIds: [userId, ...joinedPlayers],
                            );

                            // Update booking provider to reflect the pending state
                            await Provider.of<BookingProvider>(context, listen: false).getBookings(lapanganId, date);

                            // Navigate to HistoryScreen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HistoryScreen(),
                              ),
                            );
                          },
                    child: Text(isPending ? 'Pending' : 'Book Now'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
