import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/Product.dart';
import 'package:http_parser/http_parser.dart';

class ProductService {
  static final String baseUrl = 'http://localhost:8088/products';

  static Future<List<Product>?> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/getall'));
    if (response.statusCode == 200) {
      final List<dynamic> productList = jsonDecode(response.body);
      return productList.map((json) => Product.fromJson(json)).toList();
    }
    // Handle different status codes and errors appropriately
    return null;
  }


 static Future<bool> addProduct(Product product, Uint8List imageData) async {
  try {
    var uri = Uri.parse('$baseUrl/add');
    var request = http.MultipartRequest('POST', uri)
      ..fields['nameP'] = product.name
      ..fields['descriptionP'] = product.description
      ..fields['priceP'] = product.price
      ..fields['typeP'] = product.type;

    request.files.add(http.MultipartFile.fromBytes(
      'image', 
      imageData,
      filename: 'product-image.jpg',
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      // Log the status code and response body for debugging
      var responseBody = await response.stream.bytesToString();
      print('Failed to add product: ${response.statusCode}');
      print('Response body: $responseBody');
      return false;
    }
  } catch (e) {
    // Log the error
    print('Exception when calling addProduct: $e');
    return false;
  }
}



static Future<bool> updateProduct({
  required String produitId,
  required String nameP,
 required  String descriptionP,
  required String priceP,
  required String typeP,
  Uint8List? imageData, // Optional, include if handling image data
}) async {
    try {
      var uri = Uri.parse('$baseUrl'); // Assuming your backend endpoint is just the base URL
      var response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'produitId': produitId,
          'nameP': nameP,
          'descriptionP': descriptionP,
          'priceP': priceP,
          'typeP': typeP,
          // Include image data if needed, encoded in the appropriate format
        }),
      );

      if (response.statusCode == 200) {
        // Product updated successfully
        return true;
      } else if (response.statusCode == 404) {
        // Product not found
        return false;
      } else {
        // Other errors
        return false;
      }
    } catch (error) {
      // Error occurred
      return false;
    }
  }



  static Future<Product?> getProductById(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/get/$productId')); // Assuming the endpoint is like this
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }
    // Handle different status codes and errors appropriately
    return null;
  }

static Future<bool> deleteProduct(String productId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/'), // Adjusted endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'produitId': productId}), // Send productId in body
    );
    return response.statusCode == 200;
  } catch (e) {
    // Handle exceptions
    print('Exception when calling deleteProduct: $e');
    return false;
  }
}


}