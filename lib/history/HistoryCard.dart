import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'HistoryProvider.dart';
import 'HistoryDetail.dart';

class HistoryCard extends StatelessWidget {
  final DocumentSnapshot booking;

  HistoryCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final data = booking.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoryDetail(booking: booking),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lapangan ID: ${data['lapanganId']}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Date: ${data['date'].toDate()}'),
              Text('Time: ${data['time']}'),
              Text('Price: Rp ${data['price']}'),
              Text('Status: ${data['status']}'),
              if (data['status'] == 'active')
                ElevatedButton(
                  onPressed: () {
                    Provider.of<HistoryProvider>(context, listen: false)
                        .updateBookingStatus(booking.id, 'completed');
                  },
                  child: Text('Complete'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
