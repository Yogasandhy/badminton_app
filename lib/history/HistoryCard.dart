import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/payment/PaymentScreen.dart';
import 'HistoryProvider.dart';
import 'HistoryDetail.dart';
import 'dart:async';

class HistoryCard extends StatefulWidget {
  final DocumentSnapshot booking;

  HistoryCard({required this.booking});

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  late Timer _timer;
  late DateTime _endTime;
  Duration _remainingTime = Duration();

  @override
  void initState() {
    super.initState();
    final data = widget.booking.data() as Map<String, dynamic>;
    _endTime = data['createdAt'].toDate().add(Duration(minutes: 5));
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _endTime.difference(DateTime.now());
        if (_remainingTime.isNegative) {
          _timer.cancel();
          // Automatically update the status to canceled if time is up
          Provider.of<HistoryProvider>(context, listen: false)
              .updateBookingStatus(widget.booking.id, 'canceled');
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.booking.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoryDetail(booking: widget.booking),
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
              if (data['status'] == 'pending') ...[
                Text('Time remaining: ${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          lapanganId: data['lapanganId'],
                          date: data['date'].toDate(),
                          time: data['time'],
                          price: data['price'],
                        ),
                      ),
                    );
                  },
                  child: Text('Pay Now'),
                ),
              ],
              if (data['status'] == 'active')
                ElevatedButton(
                  onPressed: () {
                    Provider.of<HistoryProvider>(context, listen: false)
                        .updateBookingStatus(widget.booking.id, 'completed');
                  },
                  child: Text('Complete'),
                ),
              if (data['status'] == 'canceled')
                ElevatedButton(
                  onPressed: null,
                  child: Text('Expired'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
