import 'package:dcache/dcache.dart';
import 'package:smart_admin_dashboard/Services/user_service.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/init/provider_list.dart';
import 'package:smart_admin_dashboard/screens/User/TableUserScreen.dart';
import 'package:smart_admin_dashboard/screens/challenges/CreateChallenge.dart';
import 'package:smart_admin_dashboard/screens/home/home_screen.dart';
import 'package:smart_admin_dashboard/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';


void main() async {
  String? cachedToken = await getCachedToken();
print(cachedToken);
  Widget initialScreen = cachedToken != null ? TableUserScreen() : Login(title: "test");

  runApp(MyApp(initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp(this.initialScreen);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoPlay - Admin Panel ',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: bgColor, elevation: 0),
        scaffoldBackgroundColor: bgColor,
        primaryColor: greenColor,
        dialogBackgroundColor: secondaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(greenColor),
          ),
        ),
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: Login(
        title: "test",
      ),
    );
  }
}
Future<String?> getCachedToken() async {
  final cache = await UserService.cache;
  return cache.get('token');
}
