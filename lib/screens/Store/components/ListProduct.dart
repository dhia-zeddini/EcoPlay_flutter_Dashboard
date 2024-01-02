import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/models/Product.dart';
import 'package:smart_admin_dashboard/screens/Store/components/AddProductScreen.dart';
import 'package:smart_admin_dashboard/screens/Store/components/EditProductScreen.dart';
import 'package:smart_admin_dashboard/screens/Store/components/payementstati.dart';
import 'package:smart_admin_dashboard/services/ProductService.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';

import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';

class AdminProductList extends StatefulWidget {
  @override
  _AdminProductListState createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  String searchQuery = "";
  FocusNode focusNode = FocusNode();
  bool isSearchBarExpanded = false;
  @override
  void initState() {
    super.initState();
    fetchProducts();
    focusNode.addListener(() {
      setState(() {
        isSearchBarExpanded = focusNode.hasFocus;
      });
    });
  }
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }


  fetchProducts() async {
    List<Product>? products = await ProductService.getAllProducts();
    if (products != null) {
      setState(() {
        productList = products;
        filteredProductList = searchQuery.isNotEmpty
            ? productList.where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase())).toList()
            : productList;
      });
    }
  }
  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      if (searchQuery.isNotEmpty) {
        filteredProductList = productList
            .where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

      } else {
        filteredProductList = productList;
      }
    });
  }

  Widget buildAddProductView() {
    return AddProductScreen(
      onAddProduct: (Product product) async {
        await fetchProducts(); // Refresh the list after adding a product
      },
    );
  }
  Future<void> showAddProductDialog() async {
    final newProduct = await showDialog(
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
    fetchProducts();

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
              updateSearchQuery(searchQuery); // Mettre à jour la liste filtrée
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
          updateSearchQuery(searchQuery); // Mettre à jour la liste filtrée
        });
      } else {
        print('Failed to delete the product');
      }
    }
  }




  /*******************************/
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product List",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: isSearchBarExpanded ? MediaQuery.of(context).size.width - 16 : 60, // 60 is the initial width, 16 is the sum of horizontal padding
                child: TextField(
                  focusNode: focusNode,
                  onChanged: updateSearchQuery,
                  onTap: () {
                    setState(() {
                      isSearchBarExpanded = true;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      isSearchBarExpanded = false;
                      FocusScope.of(context).unfocus(); // This will dismiss the keyboard
                    });
                  },
                  decoration: InputDecoration(
                    labelText: isSearchBarExpanded ? 'Search Product' : '',
                    hintText: isSearchBarExpanded ? 'Enter product name' : '',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: isSearchBarExpanded
                        ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          isSearchBarExpanded = false;
                          searchQuery = ''; // Clear search query
                          updateSearchQuery(''); // Update the search
                          focusNode.unfocus(); // This will dismiss the keyboard and remove focus from the TextField
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: showAddProductDialog,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 0, 255, 72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(150, 40),
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
                  minimumSize: Size(150, 40),
                ),
                child: Text('View Stats'),
              ),
            ),
            SingleChildScrollView(
              //scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: double.infinity,
                child:  DataTable(
                  columns: [
                    DataColumn(label: Text("Image")),
                    DataColumn(label: Text("Product Name")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Type")),
                    DataColumn(label: Text("Operations")),
                  ],
                  rows: filteredProductList.map((product) => productDataRow(product)).toList(),
                ),
              ),
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
              "http://localhost:9001/images/product/${product.image}",
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
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Icon(Icons.error);
              },
            ),
          ),

        ),
        DataCell(Text(
          product.name,
        )),
        DataCell(Text(
          product.description,
        )),
        DataCell(Text(
          product.price.toString(),
        )),
        DataCell(Text(
          product.type,
        )),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
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
