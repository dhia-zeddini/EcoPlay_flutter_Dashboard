import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_admin_dashboard/models/Product.dart';
import 'package:smart_admin_dashboard/services/ProductService.dart';

class AddProductScreen extends StatefulWidget {
  final Function(Product) onAddProduct;

  const AddProductScreen({Key? key, required this.onAddProduct}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _price, _type;
  Uint8List? _imageData;
  bool _isImageLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    setState(() => _isImageLoading = true);

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageData = await pickedImage.readAsBytes();
      setState(() => _imageData = imageData);
    }
    setState(() => _isImageLoading = false);
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
      return;
    }
    _formKey.currentState!.save();

    if (_imageData == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image')));
      return;
    }

    var newProduct = Product(
      id: '',
      name: _name,
      description: _description,
      image: '',
      price: _price,
      type: _type,
    );

    bool success = await ProductService.addProduct(newProduct, _imageData!);
    if (success) {
      widget.onAddProduct(newProduct);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Added succuflly')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  style: TextStyle(color: Colors.black), // Set the text color to black
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value != null && value.isEmpty ? 'This field cannot be empty' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                  style: TextStyle(color: Colors.black), // Set the text color to black
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value != null && value.isEmpty ? 'This field cannot be empty' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                  style: TextStyle(color: Colors.black), // Set the text color to black
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) => value != null && value.isEmpty ? 'This field cannot be empty' : null,
                onSaved: (value) => _price = value!,
              ),
              TextFormField(
                  style: TextStyle(color: Colors.black), // Set the text color to black
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) => value != null && value.isEmpty ? 'This field cannot be empty' : null,
                onSaved: (value) => _type = value!,
              ),
              SizedBox(height: 70),
              _imageData != null
                  ? Image.memory(_imageData!, height: 150)
                  : (_isImageLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text('No image selected.')),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
