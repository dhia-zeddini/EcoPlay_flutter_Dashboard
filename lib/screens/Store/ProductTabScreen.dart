import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/Store/components/listProduct.dart';
import 'package:smart_admin_dashboard/screens/home/components/side_menu.dart'; // Import the correct widget

class ProductTabScreen extends StatefulWidget {
  const ProductTabScreen({Key? key}) : super(key: key);

  @override
  State<ProductTabScreen> createState() => _ProductTabScreenState();
}

class _ProductTabScreenState extends State<ProductTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: AdminProductList(), // Use the correct widget here
            ),
          ],
        ),
      ),
    );
  }
}
