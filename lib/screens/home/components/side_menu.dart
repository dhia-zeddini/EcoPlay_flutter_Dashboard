import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_admin_dashboard/screens/challenges/challenges_home.dart';
import 'package:smart_admin_dashboard/screens/home/home_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logo2.png",
                    scale: 4,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: defaultPadding / 2), // Reduced padding
                    child: Text("EcoPlay"),
                  ),
                ],
              ),
            ),
            DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            DrawerListTile(
              title: "Challenges",
              svgSrc: "assets/logo/challenges.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChallengesHome()),
                );
              },
            ),
            DrawerListTile(
              title: "Competitions",
              svgSrc: "assets/logo/competetions.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Quizzes",
              svgSrc: "assets/icons/quiz.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Store",
              svgSrc: "assets/icons/shop.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Astuces",
              svgSrc: "assets/icons/astuce.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Users",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 16.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.blue,
        height: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
