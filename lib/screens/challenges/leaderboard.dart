import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/challenges/MyColors.dart';

class LeaderBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.calculatorScreen,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          actions: [
            Icon(
              Icons.grid_view,
              color: Colors.white,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(colors: [
                        Colors.yellow.shade600,
                        Colors.orange,
                        Colors.red
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: MyColors.calculatorButton),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Region',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            Text(
                              'National',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            Text(
                              'Global',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      WinnerContainer(
                        url: 'assets/images/profile_pic.png',
                        winnerName: 'Dhia',
                        height: 120,
                        rank: '2',
                        color: Colors.green,
                        winnerPosition: '2nd', // This is an example value.
                      ),
                      WinnerContainer(
                        isFirst: true,
                        color: Colors.orange,
                        url:
                            'assets/images/profile_pic.png', // Example placeholder image.
                        winnerName: 'Ahmed',
                        rank: '1',
                        winnerPosition: '1st',
                        height:
                            150, // Example height, assuming first place has a taller container.
                      ),
                      WinnerContainer(
                        winnerName: 'Rami',
                        url: 'assets/images/profile_pic.png',
                        height: 120,
                        rank: '3',
                        color: Colors.blue,
                        winnerPosition: '3rd', // This is an example value.
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      gradient: LinearGradient(colors: [
                        Colors.yellow.shade600,
                        Colors.orange,
                        Colors.red
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 360.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: MyColors.calculatorScreen),
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 3.5,
                        children: [
                          ContestantList(
                            url: 'assets/8.jpg',
                            name: 'Shona',
                            rank: '1145',
                          ),
                          ContestantList(
                            url: 'assets/9.jpg',
                            name: 'Emily',
                            rank: '1245',
                          ),
                          ContestantList(
                            url: 'assets/7.jpg',
                            name: 'Josheph',
                            rank: '2153',
                          ),
                          ContestantList(
                            url: 'assets/10.jpg',
                            rank: '3456',
                            name: 'Kristine',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WinnerContainer extends StatelessWidget {
  final bool isFirst;
  final Color color;
  final String winnerPosition;
  final String url;
  final String winnerName;
  final String rank;
  final double height;

  const WinnerContainer({
    Key? key,
    this.isFirst = false,
    required this.color,
    required this.winnerPosition,
    required this.winnerName,
    required this.rank,
    this.height = 150.0,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.yellow.shade600,
                    Colors.orange,
                    Colors.red
                  ]),
                  border: Border.all(
                    color:
                        Colors.amber, //kHintColor, so this should be changed?
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: height ?? 150.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: MyColors.calculatorButton,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Stack(
              children: [
                if (isFirst)
                  Image.asset(
                    'assets/taj.png',
                    height: 70.0,
                    width: 105.0,
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.yellow.shade600,
                          Colors.orange,
                          Colors.red
                        ]),
                        border: Border.all(
                          color: Colors
                              .amber, //kHintColor, so this should be changed?
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            url ?? 'assets/5.jpg',
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 115.0, left: 45.0),
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color ?? Colors.red,
                    ),
                    child: Center(
                        child: Text(
                      rank ?? '1',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150.0,
            child: Container(
              width: 100.0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      winnerName ?? 'Emma Aria',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      rank ?? '1',
                      style: TextStyle(
                        color: color ?? Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContestantList extends StatelessWidget {
  final String url;
  final String name;
  final String rank;

  const ContestantList({
    Key? key,
    required this.url,
    required this.name,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, bottom: 5.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow.shade600,
              Colors.orange,
              Colors.red,
            ],
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.calculatorButton,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          url ?? 'assets/4.jpg',
                          height: 60.0,
                          width: 60.0,
                          fit: BoxFit.fill,
                        )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? 'Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '@${name ?? 'Name'}',
                        style: TextStyle(color: Colors.white54, fontSize: 12.0),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        rank ?? '1234',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
