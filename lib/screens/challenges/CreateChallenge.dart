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
      try {
        var uri = Uri.parse('http://192.168.1.13:9001/api/challenges');
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
}
