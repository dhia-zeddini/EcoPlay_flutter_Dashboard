import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/challenge.dart';
import 'dart:convert';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/screens/challenges/CreateChallenge.dart';
import 'package:smart_admin_dashboard/screens/challenges/leaderboard.dart';
import 'package:smart_admin_dashboard/screens/challenges/winners.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:smart_admin_dashboard/responsive.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:intl/intl.dart';

class ChallengeView extends StatefulWidget {
  const ChallengeView({Key? key}) : super(key: key);

  @override
  _ChallengeViewState createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  List<Challenge> _challenges = [];
  List<Challenge> _filteredChallenges = [];
  late TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchChallenges();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _filteredChallenges = _challenges
            .where((challenge) =>
                challenge.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredChallenges = List.from(_challenges);
      });
    }
  }

  void _handleDeleteChallenge(String challengeId) {
    _deleteChallenge(challengeId, () {
      setState(() {
        _challenges.removeWhere((challenge) => challenge.id == challengeId);
      });
    }).catchError((error) {
      print('Failed to delete the challenge: $error');
    });
  }

  void _filterChallenges(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredChallenges = _challenges;
      });
    } else {
      setState(() {
        _filteredChallenges = _challenges
            .where((challenge) => challenge.title
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _fetchChallenges() async {
    const url = 'http://localhost:9001/api/challenges';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> challengesJson = json.decode(response.body);
        setState(() {
          _challenges =
              challengesJson.map((json) => Challenge.fromJson(json)).toList();
          _filteredChallenges = List.from(_challenges);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load challenges. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  Future<bool> _deleteChallenge(String challengeId, Function onSuccess) async {
    final url =
        Uri.parse('http://localhost:9001/api/challenges/$challengeId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        print('Challenge deleted successfully.');
        onSuccess();
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

  Future<int> fetchFlaggedCommentsCount() async {
    final response = await http
        .get(Uri.parse('http://localhost:9001/api/comments/flagged-count'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['flaggedCount'];
    } else {
      throw Exception('Failed to load flagged comments count');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Flexible(
            child: SearchBarAnimation(
              textEditingController: _searchController,
              isOriginalAnimation: true,
              onFieldSubmitted: (String value) {
                _onSearchChanged();
              },
              trailingWidget: Icon(Icons.search),
              secondaryButtonWidget: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged();
                },
              ),
              buttonWidget: Icon(Icons.search),
            ),
          ),
        ],
      ),
      drawer: Responsive.isMobile(context) ? SideMenu() : null,
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  Expanded(
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
                                _buildChallengeContent(),
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
            Positioned(
                bottom: 0, // Align with the bottom of the sidebar
                left: MediaQuery.of(context).size.width *
                    0.44, // Adjust this value as needed
                child: WinnersCarousel())
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

  void _showLeaderboardDialog(BuildContext context, String challengeTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Leaderboard of the challenge :  $challengeTitle'), // Personalized title
          content: Container(
            width: 500,
            height: 400, // Adjust the height as needed
            child: LeaderBoardScreen(), // Your custom LeaderBoardScreen widget
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showDetailCard(Challenge challenge) {
    String imageName = challenge.media;
    String imageUrl = 'http://localhost:9001/images/challenges/$imageName';

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
                              'Inappropriate comments: ${challenge.comments.length - 1}',
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
            DataColumn(label: Text("Title")),
            DataColumn(label: Text("Category")),
            DataColumn(label: Text("Participants")),
            DataColumn(label: Text("Start Date")),
            DataColumn(label: Text("End Date")),
            DataColumn(
              label: Expanded(
                // This will force the child to fill the available space
                child: Center(
                  child: Text('Operation'),
                ),
              ),
            ),
          ],
          rows: _filteredChallenges.map((challenge) {
            return DataRow(
              cells: [
                DataCell(Text(challenge.title)),
                DataCell(Text(challenge.category)),
                DataCell(Text(challenge.participants.length.toString())),
                DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(challenge.startDate))),
                DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(challenge.endDate))),
                DataCell(
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green.withOpacity(0.5),
                        ),
                        icon: Icon(Icons.view_agenda_outlined),
                        onPressed: () => _showDetailCard(challenge),
                        label: Text("View"),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.withOpacity(0.5),
                        ),
                        onPressed: () {
                          DateTime endDate =
                              challenge.endDate; // Your challenge's end date
                          DateTime now = DateTime.now();

                          if (endDate.isBefore(now)) {
                            // If the end date has passed, show the leaderboard
                            _showLeaderboardDialog(context, challenge.title);
                          } else {
                            // If the end date has not passed, show a message
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Challenge in Progress'),
                                  content: Text(
                                      'This challenge is still in progress.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        icon: Icon(Icons.leaderboard_outlined),
                        label: Text("LeaderBoard"),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.withOpacity(0.5),
                        ),
                        label: Text("Archive"),
                        icon: Icon(Icons.archive_outlined),

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
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog

                                                  final didDelete =
                                                      await _deleteChallenge(
                                                          challenge.id, () {
                                                    // Callback function that updates the state
                                                    setState(() {
                                                      _challenges.removeWhere(
                                                          (item) =>
                                                              item.id ==
                                                              challenge.id);
                                                    });
                                                  });

                                                  if (didDelete) {
                                                    // Show a success notification
                                                    ElegantNotification.success(
                                                      title: Text('Success'),
                                                      description: Text(
                                                          'Challenge Archived successfully.',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
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
