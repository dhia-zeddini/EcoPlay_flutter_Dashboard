import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:elegant_notification/elegant_notification.dart';
import 'dart:math';
import 'package:smart_admin_dashboard/screens/challenges/Challenges.dart';

class CreateChallengeForm extends StatefulWidget {
  final VoidCallback onChallengeCreated;

  CreateChallengeForm({Key? key, required this.onChallengeCreated})
      : super(key: key);

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

  final _random = Random();

  // Method to generate a random challenge idea
  Future<void> _generateRandomChallenge() async {
    var url = Uri.parse(
        'https://api.airtable.com/v0/appTsPaK7TqmmTHlB/ChallengesModel');

    print('Starting API request...');

    try {
      // Make a GET request to Airtable API
      var response = await http.get(
        url,
        // Set the headers with your Personal Access Token
        headers: {
          'Authorization':
              'Bearer patI8JN3wibBE1te1.4ed0386f633f548ebce212139b203e74f6216b06e55634e836018e7ac5fc9b6f',
          'Content-Type': 'application/json'
        },
      );

      print('API request completed with status code: ${response.statusCode}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        var decodedResponse = json.decode(response.body);
        print('Response data: $decodedResponse');

        // Extract the records from the response
        List<Map<String, dynamic>> challenges = List<Map<String, dynamic>>.from(
          decodedResponse['records'].map(
            (record) => {
              "title": record['fields']['title'],
              "description": record['fields']['description'],
              "category": record['fields']['category'],
            },
          ),
        );

        print('Number of challenges fetched: ${challenges.length}');

        // Randomly select one challenge from the list
        final randomChallenge = challenges[_random.nextInt(challenges.length)];
        print('Random challenge selected: $randomChallenge');

        // Set the form fields to the selected challenge's details
        setState(() {
          _titleController.text = randomChallenge["title"]!;
          _descriptionController.text = randomChallenge["description"]!;
          _categoryController.text = randomChallenge["category"]!;
          // You can also set default or random dates for start and end
        });
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        print('Failed to load challenges. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load challenges');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error occurred during API request: $e');
    }
  }

  XFile? _media;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _imageBytes; //

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // This function will be used to show a DatePicker and update the date controllers
  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _selectedStartDate ?? DateTime.now()
          : _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Specify the file type you want to pick
      withData: true, // Ensure this is true to get the Uint8List of the file
    );

    if (result != null) {
      setState(() {
        _media = XFile.fromData(result.files.single.bytes!,
            name: result.files.single.name);
        _imageBytes = result
            .files.single.bytes; // Store the image bytes to show the preview
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedEndDate!.isBefore(_selectedStartDate!)) {
        // If the end date is before the start date, show an error.
        ElegantNotification.error(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          description: Text(
            'End date must be after the start date.',
            style: TextStyle(color: Colors.black),
          ),
        ).show(context);
        return; // Stop the form submission.
      }
      try {
        var uri = Uri.parse('http://localhost:9001/api/challenges');
        var request = http.MultipartRequest('POST', uri)
          ..fields['title'] = _titleController.text
          ..fields['description'] = _descriptionController.text
          ..fields['start_date'] = _convertDate(_startDateController.text)
          ..fields['end_date'] = _convertDate(_endDateController.text)
          ..fields['category'] = _categoryController.text
          ..fields['point_value'] =
              int.tryParse(_pointValueController.text)?.toString() ?? '0';

        if (_media != null) {
          var mediaBytes = await _media!.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'media',
            mediaBytes,
            filename: _media!.name,
          ));
        }

        var response = await request.send();

        if (response.statusCode == 201) {
          final responseString = await response.stream.bytesToString();
          ElegantNotification.success(
            title: Text('Success'),
            description: Text(
              'Challenge Created successfully.',
              style: TextStyle(color: Colors.black), // Changed color to blue
            ),
          ).show(context);
          widget.onChallengeCreated();
          print("created succesffully");
        } else {
          print('Failed to create challenge');
          // Handle failure
        }
      } catch (e) {
        print('Caught error: $e');
        // Handle any other errors that might occur
      }
    }
  }

  String _convertDate(String date) {
    final originalFormat =
        DateFormat('dd-MM-yyyy'); // Adjust the format if necessary
    final targetFormat = DateFormat('dd-MM-yyyy');
    final dateTime = originalFormat.parseStrict(date);
    return targetFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            buildTextField(_titleController, "Title"),
            SizedBox(height: 20),
            buildTextField(_descriptionController, "Description"),
            SizedBox(height: 20),
            buildDateField(context, _startDateController, "Start Date"),
            SizedBox(height: 20),
            buildDateField(context, _endDateController, "End Date"),
            SizedBox(height: 20),
            buildTextField(_categoryController, "Category"),
            SizedBox(height: 20),
            buildTextField(_pointValueController, "Point Value",
                isNumeric: true),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image takes 2/3 of the space
                Expanded(
                  flex: 2,
                  child: _imageBytes != null
                      ? ImagePreview(imageBytes: _imageBytes!)
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Light grey color
                            border: Border.all(
                              color: Colors
                                  .grey[300]!, // Slightly darker grey border
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.photo, // Gallery icon
                            color: Colors.grey[500], // Medium grey color
                            size: 50,
                          ),
                          alignment: Alignment.center,
                        ),
                ),

                // Spacing between image and button
                SizedBox(width: 20),
                // "Change File" button takes 1/3 of the space
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Use minimum space needed by the column
                    children: [
                      ElevatedButton(
                        onPressed: _generateRandomChallengev2,
                        child: Text("Generate Random Challenge"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickMedia,
                        child:
                            Text(_media != null ? 'Change File' : 'Pick File'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          onPrimary: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
                height:
                    20), // Spacing between the row and the "Create Challenge" button

            // "Create Challenge" button
            ElevatedButton(
              onPressed: _submitForm,
              child: Text("Create Challenge"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                minimumSize: Size(
                    double.infinity, 36), // Make the button take the full width
              ),
            ),
          ],
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

  Widget buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a $label';
        }
        if (isNumeric && value.isNotEmpty && int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

// Helper method to build a date field
  Widget buildDateField(
      BuildContext context, TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(context, controller, label == "Start Date"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
    );
  }

// Widget to display the image preview
  Widget ImagePreview({required Uint8List imageBytes}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Image.memory(imageBytes, fit: BoxFit.cover),
    );
  }

  Future<void> _generateRandomChallengev2() async {
    print('Generating random challenge using mock data...');

    try {
      // Randomly select one challenge from the mock data
      final randomChallenge =
          mockChallenges[_random.nextInt(mockChallenges.length)];
      print('Random challenge selected: $randomChallenge');

      // Set the form fields to the selected challenge's details
      setState(() {
        _titleController.text = randomChallenge["title"] ?? '';
        _descriptionController.text = randomChallenge["description"] ?? '';
        _categoryController.text = randomChallenge["category"] ?? '';
        // You can also set default or random dates for start and end
      });
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error occurred during mock data retrieval: $e');
      throw Exception('Failed to generate challenges from mock data');
    }
  }
}
