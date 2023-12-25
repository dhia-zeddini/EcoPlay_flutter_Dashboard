import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/challenge.dart';
import 'dart:convert';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/screens/challenges/CreateChallenge.dart';
import 'package:smart_admin_dashboard/screens/challenges/UserStatistics.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:smart_admin_dashboard/responsive.dart';
import 'package:elegant_notification/elegant_notification.dart';

class ChallengeView extends StatefulWidget {
  const ChallengeView({Key? key}) : super(key: key);

  @override
  _ChallengeViewState createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  List<Challenge> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    const url = 'https://ecoplay-api.onrender.com/api/challenges';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> challengesJson = json.decode(response.body);
        setState(() {
          _challenges =
              challengesJson.map((json) => Challenge.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load challenges');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  Future<bool> _deleteChallenge(String challengeId) async {
    final url = Uri.parse(
        'https://ecoplay-api.onrender.com/api/challenges/$challengeId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        print('Challenge deleted successfully.');
        return true;
      } else {
        print(
            'Failed to delete challenge. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error deleting challenge: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isMobile(context) ? SideMenu() : null,
      body: SafeArea(
        child: Stack(
          // Use a Stack to overlay the FloatingActionButton
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Side menu for larger screens
                if (Responsive.isDesktop(context))
                  Expanded(
                    // default flex is 1
                    child: SideMenu(),
                  ),
                Expanded(
                  flex: 5, // It takes 5/6 part of the screen
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _challenges.isEmpty
                          ? const Center(child: Text('No challenges found'))
                          : Column(
                              // Wrap your content in a Column
                              children: [
                                _buildChallengeContent(), // Existing content
                                StatisticsCard(), // Your new static StatisticsCard
                              ],
                            ),
                ),
              ],
            ),
            Positioned(
              // Correctly placed FloatingActionButton within the Stack
              top: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => _showCreateChallengeDialog(context),
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateChallengeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: CreateChallengeForm(
                onChallengeCreated: () {
                  Navigator.of(context).pop();
                  // Fetch the challenges again
                  _fetchChallenges();
                  // Show the success notification
                  ElegantNotification.success(
                    title: Text('Success'),
                    description: Text(
                      'Challenge Created successfully.',
                      style: TextStyle(
                          color: Colors.black), // Changed color to blue
                    ),
                  ).show(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetailCard(Challenge challenge) {
    String imageName = challenge.media;
    String imageUrl =
        'https://ecoplay-api.onrender.com/images/challenges/$imageName';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12)), // Rounded corners for the dialog
          child: IntrinsicWidth(
            child: Card(
              margin: EdgeInsets.all(0), // Remove default card margin
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12)), // Rounded corners for the card
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageUrl.isNotEmpty
                      ? ClipRRect(
                          // Clip it with rounded corners
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: 400,
                            height: 350,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                  child: Text('Unable to load image'));
                            },
                          ),
                        )
                      : SizedBox(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(challenge.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal)),
                          ),
                          SizedBox(height: 16),
                          Text('Category: ${challenge.category}',
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 8),
                          Text(
                              'Number of Participants: ${challenge.participants.length}',
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 8),
                          Text('Number of posts: ${challenge.comments.length}',
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 8),
                          Text(
                              'Inappropriate comments: ${challenge.comments.length}',
                              style: TextStyle(color: Colors.white)),
                          SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal, // Button color
                                onPrimary: Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text('Close'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChallengeContent() {
    // The content of your challenge, extracted to a method for clarity
    return Container(
      padding: EdgeInsets.all(defaultPadding), // consistent padding
      decoration: BoxDecoration(
        color: secondaryColor, // consistent color
        borderRadius:
            const BorderRadius.all(Radius.circular(10)), // rounded corners
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: defaultPadding, // consistent spacing
          columns: [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Title")),
            DataColumn(label: Text("Category")),
            DataColumn(label: Text("Participants")),
            DataColumn(
              label: Text("Operation"),
            ),
          ],
          rows: _challenges.map((challenge) {
            return DataRow(
              cells: [
                DataCell(Text(challenge.id)),
                DataCell(Text(challenge.title)),
                DataCell(Text(challenge.category)),
                DataCell(Text(challenge.participants.length.toString())),
                DataCell(
                  Row(
                    children: [
                      TextButton(
                        child:
                            Text('View', style: TextStyle(color: greenColor)),
                        onPressed: () => _showDetailCard(challenge),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      TextButton(
                        child: Text("Archive",
                            style: TextStyle(color: Colors.redAccent)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                    title: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.warning_outlined,
                                              size: 36, color: Colors.red),
                                          SizedBox(height: 20),
                                          Text("Confirm Delete"),
                                        ],
                                      ),
                                    ),
                                    content: Container(
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text(
                                              "Are you sure want to Archive '${challenge.title}'?"),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 14,
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors
                                                              .transparent),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  label: Text("Cancel")),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton.icon(
                                                icon: Icon(Icons.delete,
                                                    size: 14),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.red),
                                                onPressed: () async {
                                                  // Close the confirmation dialog
                                                  Navigator.of(context).pop();

                                                  // Show a loading indicator or disable the button while processing
                                                  final didDelete =
                                                      await _deleteChallenge(
                                                          challenge.id);

                                                  if (didDelete) {
                                                    setState(() {
                                                      _challenges.removeWhere(
                                                          (item) =>
                                                              item.id ==
                                                              challenge.id);
                                                    });
                                                    // Show a success notification
                                                    ElegantNotification.success(
                                                      title: Text('Success'),
                                                      description: Text(
                                                        'Challenge Archived successfully.',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black), // Changed color to blue
                                                      ),
                                                    ).show(context);
                                                  } else {
                                                    // Show an error notification
                                                    ElegantNotification.error(
                                                      title: Text('Error'),
                                                      description: Text(
                                                          'Failed to delete the challenge.'),
                                                    ).show(context);
                                                  }
                                                },
                                                label: Text("Archive"),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ));
                              });
                        },
                        // Delete
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
