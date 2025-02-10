import 'package:flutter/material.dart';
import '../lapangan/LapanganCardScreen.dart';
import '../lapangan/LapanganProvider.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  final String username;

  const Homescreen({super.key, required this.username});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LapanganProvider>().fetchLapangan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child: const LapanganCardScreen(),
          ),
        ],
      ),
    );
  }
}