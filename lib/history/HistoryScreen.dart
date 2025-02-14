import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HistoryProvider.dart';
import 'HistoryCard.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Provider.of<HistoryProvider>(context, listen: false).fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryList(context, status: 'pending'),
          _buildHistoryList(context, status: 'active'),
          _buildHistoryList(context, status: 'completed'),
          _buildHistoryList(context, status: 'canceled', refresh: false),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, {required String status, bool refresh = true}) {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        if (historyProvider.isLoading && refresh) {
          return Center(child: CircularProgressIndicator());
        }

        var bookings;
        if (status == 'pending') {
          bookings = historyProvider.pendingPaymentBookings;
        } else if (status == 'active') {
          bookings = historyProvider.activeBookings;
        } else if (status == 'completed') {
          bookings = historyProvider.completedBookings;
        } else {
          bookings = historyProvider.canceledBookings;
        }

        if (bookings.isEmpty) {
          return Center(child: Text('No bookings available.'));
        }

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];
            return HistoryCard(booking: booking);
          },
        );
      },
    );
  }
}
