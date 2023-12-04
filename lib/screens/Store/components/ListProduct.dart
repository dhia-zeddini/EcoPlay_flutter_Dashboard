import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/models/Product.dart';
import 'package:smart_admin_dashboard/services/ProductService.dart';

class AdminProductList extends StatefulWidget {
  @override
  _AdminProductListState createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    List<Product>? products = await ProductService.getAllProducts();
    if (products != null) {
      setState(() {
        productList = products;
      });
    }
  }

  void navigateToAddProduct() {
    // TODO: Navigate to the Add Product page
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProductScreen()));
  }

  void editProduct(Product product) {
    // TODO: Implement edit functionality.
    // For example: navigate to the edit product page
  }

  void deleteProduct(Product product) {
    // TODO: Implement delete functionality.
    // For example: show a confirmation dialog and then delete the product
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: navigateToAddProduct,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ), // Text color
              ),
              child: Text('Add Product'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the content of the column to take full width
          children: [        
            DataTable(
              columns: [
                DataColumn(label: Text("Image")),
                DataColumn(label: Text("Product Name")),
                DataColumn(label: Text("Description")),
                DataColumn(label: Text("Price")),
                DataColumn(label: Text("Type")),
                DataColumn(label: Text("Operations")),
              ],
              rows: productList.map((product) => productDataRow(product)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  DataRow productDataRow(Product product) {
    return DataRow(
      cells: [
        DataCell(
          Image.network(
            "http://localhost:8088/images/product/${product.image}",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
          ),
        ),
        DataCell(Text(product.name)),
        DataCell(Text(product.description)),
        DataCell(Text(product.price.toString())),
        DataCell(Text(product.type)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min, // This will keep the Row as small as possible
            children: [
              // Edit Button
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () => editProduct(product),
              ),
              // Delete Button
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteProduct(product),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
