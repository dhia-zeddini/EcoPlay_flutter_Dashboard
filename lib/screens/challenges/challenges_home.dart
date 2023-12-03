import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/screens/challenges/CreateChallenge.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChallengesHome extends StatelessWidget {
  ChallengesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Challenges'),
      ),
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        child: ListView(
          // Using ListView instead of Column for better scrolling behavior
          children: [
            Header("Manage Challenges"),
            SizedBox(height: defaultPadding),
            ChallengesListView(), // Assuming this widget doesn't take up full height
            SizedBox(height: defaultPadding),
            CreateChallengeForm(), // Now should be visible
          ],
        ),
      ),
    );
  }
}

// Rest of your code remains the same

class ChallengesPanel extends StatelessWidget {
  ChallengesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Header("Manage Challenges"),
          SizedBox(height: defaultPadding),
          Expanded(child: ChallengesListView()),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        Spacer(),
        // Add more widgets for actions or filters
      ],
    );
  }
}

class ChallengesListView extends StatelessWidget {
  ChallengesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with your data source
    List<String> challenges = ["Challenge 1", "Challenge 2", "Challenge 3"];

    return ListView.builder(
      itemCount: challenges.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(challenges[index]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit challenge page
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Handle delete challenge
              },
            ),
          ],
        ),
      ),
    );
  }
}
