import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateChallengeForm extends StatefulWidget {
  @override
  _CreateChallengeFormState createState() => _CreateChallengeFormState();
}

class _CreateChallengeFormState extends State<CreateChallengeForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _pointValueController = TextEditingController();
  XFile? _media;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Specify the file type you want to pick
    );

    if (result != null) {
      // On the web, the path is null and you should use the bytes instead
      setState(() {
        // Use XFile with bytes for web compatibility
        _media = XFile.fromData(result.files.single.bytes!,
            name: result.files.single.name);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var uri = Uri.parse('https://ecoplay-api.onrender.com/api/challenges');
      var request = http.MultipartRequest('POST', uri)
        ..fields['title'] = _titleController.text
        ..fields['description'] = _descriptionController.text
        ..fields['start_date'] = _startDateController.text
        ..fields['end_date'] = _endDateController.text
        ..fields['category'] = _categoryController.text
        ..fields['point_value'] = _pointValueController.text;

      if (_media != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          _media!.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Challenge created successfully');
      } else {
        print('Failed to create challenge');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Challenge"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Add the form key here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: "Start Date",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: "End Date",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _pointValueController,
                decoration: InputDecoration(
                  labelText: "Point Value",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a point value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickMedia,
                child: Text(_media != null ? 'Change File' : 'Pick File'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Create Challenge"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _categoryController.dispose();
    _pointValueController.dispose();
    super.dispose();
  }
}
