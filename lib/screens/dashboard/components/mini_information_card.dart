import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/daily_info_model.dart';

import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/mini_information_widget.dart';
import 'package:smart_admin_dashboard/screens/forms/input_form.dart';
import 'package:flutter/material.dart';
import '../../../Services/user_service.dart';
import '../../../models/UserModel.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class MiniInformation extends StatelessWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),

          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: InformationCard(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.2 : 1,
          ),
          tablet: InformationCard(),
          desktop: InformationCard(
            childAspectRatio: _size.width < 1400 ? 1.2 : 1.4,
          ),
        ),
      ],
    );
  }
}

class InformationCard extends StatefulWidget {
  const InformationCard({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  _InformationCardState createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {

  List<DailyInfoModel> dailyInfo =dailyDatas;
  List<UserModel> users = [];
  @override
  void initState() {
    super.initState();
    print(dailyInfo[0].spots);
    loadUsers();

  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dailyDatas.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          MiniInformationWidget(dailyData: dailyInfo[index]),
    );
  }


  Future<void> loadUsers() async {
    try {
      List<UserModel>? allUsers = await UserService.getAllUsers();
      print("try");
      var totalUsers = 1;
      if (allUsers != null) {
        setState(() {
          users = allUsers;
        });
         totalUsers =allUsers!.length;
        // Calculate daily and weekly counts
        Map<String, int> counts = calculateCounts(users);
        Map<String, int> dailyCounts = calculateDailyCounts(users);
        if (counts != null) {
          var dailyCount = counts['dailyCount'] ?? 0;
          var weeklyCount = counts['weeklyCount'] ?? 0;

          try {
            var totalStorage = ((dailyCount * 100) / totalUsers).toInt();
            var weeklyStorage = ((weeklyCount * 100) / totalUsers).toInt();

            /***********************/
            var Monday= dailyCounts['Monday']?? 0;
            var  Tuesday= dailyCounts['Tuesday']?? 0;
            var  Wednesday= dailyCounts['Wednesday']?? 0;
            var  Thursday= dailyCounts['Thursday']?? 0;
            var Friday= dailyCounts['Friday']?? 0;
            var Saturday= dailyCounts['Saturday']?? 0;
            var Sunday= dailyCounts['Sunday']?? 0;

            setState(() {
              dailyInfo[0].volumeData = dailyCount;
              dailyInfo[0].weeklyData = weeklyCount;
              dailyInfo[0].totalStorage = totalStorage.toString();
              dailyInfo[0].weeklyStorage = weeklyStorage.toString();
              /*******************************/
              dailyInfo[0].spots=[
               FlSpot(1, Monday.toDouble()),
               FlSpot(2, Tuesday.toDouble()),
               FlSpot(3, Wednesday.toDouble()),
               FlSpot(4, Thursday.toDouble()),
               FlSpot(5, Friday.toDouble()),
               FlSpot(6, Saturday.toDouble()),
               FlSpot(7, Sunday.toDouble()),
              ];

              print("/*******************************/");
              print(dailyInfo[0].spots);
            });
          } catch (e) {
            // Handle the exception as needed
            print('Error converting to int: $e');
          }
        }
        print(counts);
        print(dailyCounts);


      }
    } catch (e) {
      print('Error loading users: $e');
    }

  }

  Map<String, int> calculateCounts(List<UserModel> users) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate start and end dates for daily and weekly counts
    DateTime dailyStartDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime weeklyStartDate = currentDate.subtract(Duration(days: currentDate.weekday ));

    // Filter users based on creation date
    List<UserModel> dailyUsers = users.where((user) {
      DateTime userDate = DateTime.parse(user.createdAt);
      return userDate.isAfter(dailyStartDate);
    }).toList();

    List<UserModel> weeklyUsers = users.where((user) {
      DateTime userDate = DateTime.parse(user.createdAt);
      return userDate.isAfter(weeklyStartDate);
    }).toList();

    return {
      'dailyCount': dailyUsers.length,
      'weeklyCount': weeklyUsers.length,
    };
  }




  Map<String, int> calculateDailyCounts(List<UserModel> users) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate start and end dates for the current week
    DateTime weekStartDate = currentDate.subtract(Duration(days: currentDate.weekday ));
    DateTime weekEndDate = weekStartDate.add(Duration(days: 6));

    // Initialize daily counts map
    Map<String, int> dailyCounts = {
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };

    // Filter users based on creation date and update daily counts
    users.forEach((user) {
      DateTime userDate = DateTime.parse(user.createdAt);
      if (userDate.isAfter(weekStartDate) && userDate.isBefore(weekEndDate)) {
        String dayOfWeek = DateFormat('EEEE').format(userDate);
        dailyCounts[dayOfWeek] = dailyCounts[dayOfWeek]! + 1;
      }
    });

    return dailyCounts;
  }

}
