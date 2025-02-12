import 'package:flutter/material.dart';
import 'package:ta_bultang/payment/PaymentService.dart';
import 'package:ta_bultang/payment/SnapWebViewScreen.dart';

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
            Text('Price: Rp $price'),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SnapWebViewScreen(snapUrl: redirectUrl),
            ),
          );
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

          ],
        ),
      ),
    );
  }
}
