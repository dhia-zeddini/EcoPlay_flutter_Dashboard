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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Product List",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            DataTable(
              horizontalMargin: 0,
              columnSpacing: 16.0, // Adjust as needed
              columns: [
                DataColumn(
                  label: Text("Product Name"),
                ),
                DataColumn(
                  label: Text("Description"),
                ),
                DataColumn(
                  label: Text("Image"),
                ),
                DataColumn(
                  label: Text("Price"),
                ),
                DataColumn(
                  label: Text("Type"),
                ),
                DataColumn(
                  label: Text("Operation"),
                ),
              ],
              rows: List.generate(
                productList.length,
                (index) => productDataRow(productList[index], context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow productDataRow(Product product, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(product.name),
        ),
        DataCell(
          Text(product.description),
        ),
        DataCell(
          Image.network(
            "http://localhost:8088/images/product/${product.image}",
            width: 50,
            height: 50,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
          ),
        ),
        DataCell(
          Text(product.price),
        ),
        DataCell(
          Text(product.type),
        ),
        DataCell(
          Row(
            children: [
              TextButton(
                child: Text('View', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  // Implement view functionality.
                },
              ),
              SizedBox(width: 6),
              TextButton(
                child:
                    Text('Delete', style: TextStyle(color: Colors.redAccent)),
                onPressed: () {
                  // Implement delete functionality.
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
