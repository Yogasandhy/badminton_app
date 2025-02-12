import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/payment'; // Untuk Android Emulator
  // Gunakan 'http://localhost:3000/api/payment' untuk iOS simulator
  // Gunakan IP address server Anda untuk device fisik

  Future<Map<String, dynamic>> createTransaction({
    required String lapanganId,
    required String date,
    required String time,
    required String price,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-transaction'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'lapanganId': lapanganId,
          'date': date,
          'time': time,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> checkStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status/$orderId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to check transaction status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}