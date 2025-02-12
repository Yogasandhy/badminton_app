import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/booking/BookingProvider.dart';
import 'package:ta_bultang/menu/BottomNavBar.dart';

class PaymentScreen extends StatelessWidget {
  final String lapanganId;
  final DateTime date;
  final String time;
  final int price;

  PaymentScreen({
    required this.lapanganId,
    required this.date,
    required this.time,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lapangan ID: $lapanganId'),
            Text('Date: ${date.toLocal()}'),
            Text('Time: $time'),
            Text('Price: Rp $price'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<BookingProvider>(context, listen: false).addBooking(
                    lapanganId,
                    date,
                    time,
                    'active', // Set initial status to active
                    price,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment successful! Booking confirmed.')),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => BottomNavBar(initialIndex: 2)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment failed. Please try again.')),
                    );
                  }
                }
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
