
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/calendart_widget.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/charts.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/user_details_mini_card.dart';
import 'package:flutter/material.dart';

import '../../../Services/user_service.dart';
import '../../../models/UserModel.dart';

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  double pourcentageBanned =0;
  double pourcentageActive =0;
  int  nbrBanned =0;
  int nbrActive =0;
  int totalUsers=0 ;
  @override
  void initState() {

    super.initState();
    CountUsers();

    print("nbrBanned");
    print(pourcentageActive);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //CalendarWidget(),
          Text(
            "Users Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(pourcentageBanned: pourcentageBanned, pourcentageActive: pourcentageActive,),
          UserDetailsMiniCard(
            color: Color(0xff0293ee),
            title: "Active",
            amountOfFiles: pourcentageActive.toString()+ "%",
            numberOfIncrease: nbrActive,
          ),
          UserDetailsMiniCard(
            color: Color(0xfff8b250),
            title: "Banned",
            amountOfFiles: pourcentageBanned.toString()+ "%",
            numberOfIncrease: nbrBanned,
          ),

        ],
      ),
    );
  }

  Future<void> CountUsers() async {

    try {
      List<UserModel>? allUsers = await UserService.getAllUsers();
      totalUsers =allUsers!.length;
      print(totalUsers);

      for(var user in allUsers!){
        if(user.etatDelete){
          nbrBanned +=1;
        }else{
          nbrActive +=1;
        }
      }


        setState(() {
          pourcentageActive = (nbrActive * 100) / totalUsers;
          pourcentageBanned = (nbrBanned * 100) / totalUsers;
        });



    } catch (e) {
      print('Error loading users: $e');
    }
  }
}
