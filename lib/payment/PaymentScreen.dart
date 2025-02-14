import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/payment/PaymentService.dart';
import 'package:ta_bultang/payment/SnapWebViewScreen.dart';
import 'package:ta_bultang/history/HistoryProvider.dart';
import 'package:ta_bultang/history/HistoryScreen.dart';

class PaymentScreen extends StatelessWidget {
  final String lapanganId;
  final DateTime date;
  final String time;
  final int price;
  final bool fromBookingScreen; // Add flag to indicate navigation from BookingScreen

  PaymentScreen({
    required this.lapanganId,
    required this.date,
    required this.time,
    required this.price,
    this.fromBookingScreen = false, // Default to false
  });

  final PaymentService _paymentService = PaymentService();

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
            Text('Price per Player: Rp $price'), // Display shared price per player
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  print("🔄 Mengirim permintaan transaksi...");

                  final transactionResponse = await _paymentService.createTransaction(
                    lapanganId: lapanganId,
                    date: date.toIso8601String(),
                    time: time,
                    price: price.toString(),
                  );

                  print("✅ Respons transaksi: $transactionResponse");

                  if (transactionResponse.containsKey('redirect_url')) {
                    String redirectUrl = transactionResponse['redirect_url']; // Ambil URL

                    if (context.mounted) {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SnapWebViewScreen(snapUrl: redirectUrl),
                        ),
                      );

                      if (result == 'success') {
                        // Update booking status to active
                        await Provider.of<HistoryProvider>(context, listen: false)
                            .updateBookingStatusByDetails(
                              lapanganId: lapanganId,
                              date: date,
                              time: time,
                              status: 'active',
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment successful! Booking is now active.')),
                        );

                        // Navigate to HistoryScreen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HistoryScreen()),
                        );
                      }
                    }
                  } else {
                    throw Exception('Transaction failed: No redirect URL received.');
                  }
                } catch (e) {
                  print("⚠️ Error saat memproses pembayaran: $e");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment failed. Please try again.')),
                    );
                  }
                }
              },
              child: Text('Pay Now'),
            ),
            if (fromBookingScreen) // Conditionally show the "Pay Later" button
              ElevatedButton(
                onPressed: () async {
                  // Add booking data to Firestore collection as pending
                  await Provider.of<HistoryProvider>(context, listen: false).addPendingBooking(
                    lapanganId: lapanganId,
                    date: date,
                    time: time,
                    price: price,
                    playerIds: [FirebaseAuth.instance.currentUser!.uid],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking is now pending. Please complete the payment within 5 minutes.')),
                  );

                  // Navigate to HistoryScreen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                },
                child: Text('Pay Later'),
              ),
          ],
        ),
      ),
    );
  }
}
