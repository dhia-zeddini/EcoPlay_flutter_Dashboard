import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/listAdmin.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/listUsers.dart';

import '../../responsive.dart';
import '../dashboard/dashboard_screen.dart';
import '../home/components/side_menu.dart';

class TableAdminScreen extends StatefulWidget {
  TableAdminScreen({Key? key}) : super(key: key);

  @override
  State<TableAdminScreen> createState() => _TableAdminScreenState();
}

class _TableAdminScreenState extends State<TableAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: ListAdmin(),
            ),
          ],
        ),
      ),
    );
  }
}
