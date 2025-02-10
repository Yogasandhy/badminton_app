import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_bultang/menu/CommunityPostScreen.dart';
import 'BookingProvider.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final String lapanganId;

  BookingScreen({required this.lapanganId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => BookingProvider(),
        child: BookingForm(lapanganId: lapanganId),
      ),
    );
  }
}

class BookingForm extends StatefulWidget {
  final String lapanganId;

  BookingForm({required this.lapanganId});

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  bool isDateSelected = false;

  @override
  void initState() {
    super.initState();
    // Load initial bookings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false)
          .getBookings(widget.lapanganId, selectedDate);
    });
  }

  bool _isTimeInPast(String time) {
    final now = DateTime.now();
    final timeParts = time.split(':');
    final timeDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    return timeDate.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Column(
      children: [
        Text('Select a date:'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              DateTime date = DateTime.now().add(Duration(days: index));
              bool isSelected = selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;
              
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : null,
                    foregroundColor: isSelected ? Colors.white : null,
                  ),
                  onPressed: () async {
                    setState(() {
                      selectedDate = date;
                      selectedTime = ''; // Reset selected time
                      isDateSelected = true;
                    });
                    await bookingProvider.getBookings(widget.lapanganId, date);
                  },
                  child: Column(
                    children: [
                      Text(DateFormat('EEE').format(date)),
                      Text(DateFormat('MMM d').format(date)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        if (bookingProvider.isLoading)
          CircularProgressIndicator()
        else if (isDateSelected) ...[
          SizedBox(height: 20),
          Text('Select a time:'),
          SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(13, (index) {
              String time = '${8 + index}:00';
              bool isBooked = bookingProvider.isTimeBooked(
                widget.lapanganId, 
                selectedDate, 
                time
              );
              bool isSelected = selectedTime == time;
              bool isPast = _isTimeInPast(time);

              return ElevatedButton(
                onPressed: isBooked || isPast
                    ? null
                    : () {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBooked || isPast
                      ? Colors.grey 
                      : isSelected 
                          ? Colors.blue 
                          : null,
                  foregroundColor: isSelected ? Colors.white : null,
                ),
                child: Text(time),
              );
            }),
          ),
        ],
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedTime.isEmpty
              ? null
              : () async {
                  try {
                    await bookingProvider.addBooking(
                      widget.lapanganId, 
                      selectedDate, 
                      selectedTime,
                      'pending' // Add the status argument
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking successful!')),
                    );
                    setState(() {
                      selectedTime = ''; // Reset selection after booking
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking failed. Please try again.')),
                    );
                  }
                },
          child: Text('Confirm Booking'),
        ),
        ElevatedButton(
          onPressed: selectedTime.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CommunityPostScreen(
                        lapanganId: widget.lapanganId,
                        date: selectedDate,
                        time: selectedTime,
                      ),
                    ),
                  );
                },
          child: Text('Find Partner'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clear bookings when leaving the screen
    Provider.of<BookingProvider>(context, listen: false)
        .clearBookings(widget.lapanganId, selectedDate);
    super.dispose();
  }
}