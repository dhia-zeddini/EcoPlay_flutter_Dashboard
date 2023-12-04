import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/Product.dart';

class ProductService {
  static final String baseUrl = 'http://localhost:8088/products';

  static Future<List<Product>?> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/getall'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    // Handle different status codes and errors appropriately
    return null;
  }

  static Future<bool> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<Product?> getProductById(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl?prouditId=$productId'));
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return Product.fromJson(data['produit']);
    }
    // Handle different status codes and errors appropriately
    return null;
  }

  static Future<bool> deleteProduct(String productId) async {
    final response = await http.delete(Uri.parse('$baseUrl?produitId=$productId'));
    return response.statusCode == 200;
  }
}

