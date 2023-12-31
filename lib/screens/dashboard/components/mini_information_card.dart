import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/daily_info_model.dart';

import 'package:smart_admin_dashboard/responsive.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/mini_information_widget.dart';
import 'package:smart_admin_dashboard/screens/forms/input_form.dart';
import 'package:flutter/material.dart';
import '../../../Services/user_service.dart';
import '../../../models/UserModel.dart';
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
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new FormMaterial();
                  },
                  fullscreenDialog: true,
                ));
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add New",
              ),
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
    loadUsers();
    print(dailyInfo[0].title);
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

        if (counts != null) {
          var dailyCount = counts['dailyCount'] ?? 0;
          var weeklyCount = counts['weeklyCount'] ?? 0;

          try {
            var totalStorage = ((dailyCount * 100) / totalUsers).toInt();
            var weeklyStorage = ((weeklyCount * 100) / totalUsers).toInt();

            setState(() {
              dailyInfo[0].volumeData = dailyCount;
              dailyInfo[0].weeklyData = weeklyCount;
              dailyInfo[0].totalStorage = totalStorage.toString();
              dailyInfo[0].weeklyStorage = weeklyStorage.toString();
            });
          } catch (e) {
            // Handle the exception as needed
            print('Error converting to int: $e');
          }
        }
        print(counts);
        print(counts['dailyCount']);


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
    DateTime weeklyStartDate = currentDate.subtract(Duration(days: currentDate.weekday - 1));

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

}
