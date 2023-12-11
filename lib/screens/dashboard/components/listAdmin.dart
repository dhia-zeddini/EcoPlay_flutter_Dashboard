import 'package:smart_admin_dashboard/core/constants/color_constants.dart';

import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/Ban_request_model.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

import '../../../Services/user_service.dart';
import '../../../models/UserModel.dart';

class ListAdmin extends StatefulWidget {
  const ListAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<ListAdmin> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListAdmin> {
  List<UserModel> users = [];
  @override
  void initState() {

    super.initState();
    loadUsers();

    print(users);
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
          Text(
            "List Admins",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [

                  DataColumn(
                    label: Text("Name Surname"),
                  ),
                  DataColumn(
                    label: Text("Phone Number"),
                  ),
                  DataColumn(
                    label: Text("E-mail"),
                  ),
                  DataColumn(
                    label: Text("Registration Date"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Operation"),
                  ),
                ],
                rows: List.generate(
                  users.length,
                  (index) => recentUserDataRow(users[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


DataRow recentUserDataRow(UserModel userInfo, BuildContext context) {
  return DataRow(
    cells: [

      DataCell(
        Row(
          children: [
            TextAvatar(
              size: 35,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 14,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: userInfo.firstName!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                userInfo.firstName!+" "+userInfo.lastName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(


            borderRadius: BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(userInfo.phoneNumber!))),
      DataCell(Text(userInfo.email!)),
      DataCell(Text(userInfo.createdAt!.substring(0, 10))),
      DataCell(
        userInfo.etatDelete?
          Icon(Icons.cancel_outlined):
        Icon(Icons.check_circle_outline)
      ),
      DataCell(
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.withOpacity(0.5),
              ),
              icon: Icon(
                Icons.visibility,
                size: 14,
              ),
              onPressed: () {},
              // Edit
              label: Text("View"),
            ),
            SizedBox(
              width: 6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.green.withOpacity(0.5),
              ),
              icon: Icon(
                Icons.check_circle_outline

              ),
              onPressed: () async {
                BanRequestModel model = BanRequestModel(
                    userId: userInfo.id);
                await UserService.unBanUser(model);
                //Navigator.of(context).pop();
                setState(() {
                  loadUsers();
                  print("loaded");
                });
              },
              //View
              label: Text("Unban"),
            ),
            SizedBox(
              width: 6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.red.withOpacity(0.5),
              ),
              icon: Icon(Icons.cancel_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          title: Center(
                            child: Text("Confirm Ban"),
                          ),
                          content: Container(
                            color: secondaryColor,
                            height: 70,
                            child: Column(
                              children: [
                                Text(
                                    "Are you sure want to ban  '${userInfo.firstName}'?"),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                        icon: Icon(
                                          Icons.close,
                                          size: 14,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.grey),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        label: Text("Cancel")),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton.icon(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 14,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        onPressed: ()async {
                                          BanRequestModel model = BanRequestModel(
                                              userId: userInfo.id);
                                          await UserService.banUser(model);
                                          Navigator.of(context).pop();
                                          setState(() {
                                            loadUsers();
                                            print("loaded");
                                          });
                                        },
                                        label: Text("Ban"))
                                  ],
                                )
                              ],
                            ),
                          ));
                    });
              },
              // Delete
              label: Text("Ban"),
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> loadUsers() async {
  try {
    List<UserModel>? allUsers = await UserService.getAllAdmins();
    print("try");

    if (allUsers != null) {
      setState(() {
        users = allUsers;
      });
    }
  } catch (e) {
    print('Error loading users: $e');
  }
}
}