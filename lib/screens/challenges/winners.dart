import 'package:flutter/material.dart';
import 'package:flip_carousel/flip_carousel.dart';
import 'package:smart_admin_dashboard/Services/user_service.dart';
import 'package:smart_admin_dashboard/models/UserModel.dart';
import 'package:smart_admin_dashboard/screens/challenges/anims.dart';

class WinnersCarousel extends StatefulWidget {
  @override
  State<WinnersCarousel> createState() => _WinnersCarouselState();
}

class _WinnersCarouselState extends State<WinnersCarousel> {
  bool _showWinningAnimation = false;

  void _toggleWinningAnimation() {
    setState(() {
      _showWinningAnimation = !_showWinningAnimation;
    });

    // If you want the animation to disappear after some time
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showWinningAnimation = false;
      });
    });
  }

  final List<Map<String, dynamic>> winners = [
    {
      "name": "Ahmed Rebhi",
      "image": "assets/images/profile_pic.png",
      "challengeTitle": "30-Day Fitness Challenge",
      "dateWon": "December 10, 2023"
    },
    {
      "name": "User 2",
      "image": "assets/images/profile_pic.png",
      "challengeTitle": "Healthy Eating Week",
      "dateWon": "December 21, 2023"
    },
    {
      "name": "User 3",
      "image": "assets/images/profile_pic.png",
      "challengeTitle": "Marathon Runner Champion",
      "dateWon": "January 01, 2024"
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> items = winners.map((winner) {
      // Wrap each card in a GestureDetector to capture the flip event
      return GestureDetector(
        onTap:
            _toggleWinningAnimation, // Call this method when the card is tapped
        child: WinnerCard(winner: winner),
      );
    }).toList();

    return Stack(
      alignment: Alignment.center,
      children: [
        FlipCarousel(
          items: items,
          // Customize additional properties as needed
        ),
        if (_showWinningAnimation)
          Positioned.fill(
            child: WinningAnimation(), // Your custom winning animation widget
          ),
      ],
    );
  }
}

class WinnerCard extends StatelessWidget {
  final Map<String, dynamic> winner;

  WinnerCard({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Recent Winners",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(winner['image']),
          ),
          SizedBox(height: 10),
          Text(
            winner['name'],
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            winner['challengeTitle'],
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white70,
            ),
          ),
          Text(
            'Won on: ${winner['dateWon']}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
