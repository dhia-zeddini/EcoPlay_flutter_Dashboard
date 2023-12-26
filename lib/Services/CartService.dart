import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  final String baseUrl = 'http://localhost:9001/carts'; // Replace with your actual backend URL

  Future<List<dynamic>> fetchMonthlyPayments(int year, int month) async {
    var url = Uri.parse('$baseUrl/payments/$year/$month');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
        return jsonResponse['data'];
      } else {
        // Handle the case where 'data' is not a list or is missing
        return []; // Return an empty list instead of throwing
      }
    } else {
      // You could handle different status codes differently here
      throw Exception('Failed to load payments: ${response.statusCode}');
    }
  }
}
