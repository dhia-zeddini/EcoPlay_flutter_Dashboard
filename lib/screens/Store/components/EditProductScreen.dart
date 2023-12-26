import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_admin_dashboard/models/Product.dart';
import 'package:smart_admin_dashboard/services/ProductService.dart';
class EditProductScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onUpdateProduct;

  const EditProductScreen({Key? key, required this.product, required this.onUpdateProduct})
      : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}
class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _price, _type;
  Uint8List? _imageData;
  bool _isImageLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _description = widget.product.description;
    _price = widget.product.price;
    _type = widget.product.type;
    // You may also want to load the existing image here if it's editable
  }

  Future<void> _pickImage() async {
    setState(() => _isImageLoading = true);

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageData = await pickedImage.readAsBytes();
      setState(() => _imageData = imageData);
    }
    setState(() => _isImageLoading = false);
  }
 /* Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }
    _formKey.currentState!.save();

    bool success = await ProductService.updateProduct(
      productId: widget.product.id, // Corrected parameter name to 'productId'
      nameP: _name,
      description: _description,
      price: _price,
      type: _type, // Corrected parameter name to 'type'
      // imageData: _imageData, // Pass this if you are updating the image
    );
    if (success) {
      widget.onUpdateProduct(Product(
        id: widget.product.id,
        name: _name,
        description: _description,
        image: '', // Replace with new image path if updated
        price: _price,
        type: _type,
      ));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update product')),
      );
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value != null && value.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value != null && value.isEmpty ? 'Description cannot be empty' : null,
              ),
              TextFormField(
                initialValue: _price,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = value ?? '',
                validator: (value) => value != null && value.isEmpty ? 'Price cannot be empty' : null,
              ),
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(labelText: 'Type'),
                onSaved: (value) => _type = value ?? '',
                validator: (value) => value != null && value.isEmpty ? 'Type cannot be empty' : null,
              ),
              SizedBox(height: 20),
              _isImageLoading
                  ? CircularProgressIndicator()
                  : _imageData != null
                      ? Image.memory(_imageData!, height: 150)
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Change Image'),
                        ),
              SizedBox(height: 20),
             // ElevatedButton(
             //  onPressed: _updateProduct,
               // child: Text('Update Product'),
             // ),
            ],
          ),
        ),
      ),
    );
  }
}
