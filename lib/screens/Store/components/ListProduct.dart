import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/models/Product.dart';
import 'package:smart_admin_dashboard/screens/Store/components/AddProductScreen.dart';
import 'package:smart_admin_dashboard/screens/Store/components/EditProductScreen.dart';
import 'package:smart_admin_dashboard/screens/Store/components/payementstati.dart';
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

  Widget buildAddProductView() {
    return AddProductScreen(
      onAddProduct: (Product product) {
        setState(() {
          productList.add(product);
        });
      },
    );
  }

  Future<void> showAddProductDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Product',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: buildAddProductView(),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

 void editProduct(Product product) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => EditProductScreen(
      product: product,
      onUpdateProduct: (updatedProduct) {
        setState(() {
          int index = productList.indexWhere((p) => p.id == updatedProduct.id);
          if (index != -1) {
            productList[index] = updatedProduct;
          }
        });
      },
    ),
  ));
}


  void deleteProduct(Product product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this product?',
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 254, 254),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    ) ??
        false;

    if (shouldDelete) {
      final success = await ProductService.deleteProduct(product.id);
      if (success) {
        setState(() {
          productList.removeWhere((item) => item.id == product.id);
        });
      } else {
        print('Failed to delete the product');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: showAddProductDialog,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Add Product'),
            ),
          ),
           Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () {
              // This is where you navigate to the PaymentsScreen
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PaymentsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue, // Choose a different color to distinguish this button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('View Stats'),
          ),
        ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataTable(
              columns: [
                DataColumn(label: Text("Image", style: TextStyle(color: Colors.green))),
                DataColumn(label: Text("Product Name", style: TextStyle(color: Colors.green))),
                DataColumn(label: Text("Description", style: TextStyle(color: Colors.green))),
                DataColumn(label: Text("Price", style: TextStyle(color: Colors.green))),
                DataColumn(label: Text("Type", style: TextStyle(color: Colors.green))),
                DataColumn(label: Text("Operations", style: TextStyle(color: Colors.green))),
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
          Container(
            child: Image.network(
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
        ),
        DataCell(Text(
          product.name,
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          product.description,
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          product.price.toString(),
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          product.type,
          style: TextStyle(color: Colors.black),
        )),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orange),
                onPressed: () => editProduct(product),
              ),
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
