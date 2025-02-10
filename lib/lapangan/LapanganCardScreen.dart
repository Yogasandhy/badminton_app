import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LapanganProvider.dart';
import '../booking/BookingScreen.dart';

class LapanganCardScreen extends StatelessWidget {
  const LapanganCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LapanganProvider>(
      builder: (context, lapanganProvider, child) {
        if (lapanganProvider.lapanganList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: lapanganProvider.lapanganList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            var lapangan = lapanganProvider.lapanganList[index];
            return Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(lapanganId: lapangan.id),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lapangan['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(lapanganId: lapangan.id),
                          ),
                        );
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}