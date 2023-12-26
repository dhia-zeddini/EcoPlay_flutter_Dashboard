import 'package:smart_admin_dashboard/core/constants/color_constants.dart';

import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/Ban_request_model.dart';
import 'package:smart_admin_dashboard/models/NewAdmin_request_model.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/AddAdminForm.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../../../Services/user_service.dart';
import '../../../config.dart';
import '../../../models/Login_request_model.dart';
import '../../../models/UserModel.dart';
import '../../../responsive.dart';
import '../../forms/input_form.dart';

class ListAdmin extends StatefulWidget {
  const ListAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<ListAdmin> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListAdmin> {
  List<UserModel> users = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? password;
  bool isAPIcallProcess = false;
  bool hidePwd = true;
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
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                        title: Center(
                          child: Text("New Admin"),
                        ),
                        content: Container(

                          //height: 70,
                          child: Column(
                            children: [
                              if (Responsive.isDesktop(context))
                              Form(
                                key: _formKey,
                                child: addFormUI(context),
                              ),


                            ],
                          ),
                        ));
                  });
            },
            icon: Icon(Icons.add),
            label: Text(
              "Add New",
            ),
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

  Widget addFormUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "firstname",
              "First Name",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "First Name can't be empty";
                }
                return null;
              },
                  (onSavedVal) {
                firstName = onSavedVal;
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.person),
              borderFocusColor: Colors.green,
              prefixIconColor: Colors.white,
              borderColor: Colors.black,
              textColor: Colors.white,
              hintColor: Colors.black.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "lastname",
              "Last Name",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Last Name can't be empty";
                }
                return null;
              },
                  (onSavedVal) {
                lastName = onSavedVal;
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.person),
              borderFocusColor: Colors.green,
              prefixIconColor: Colors.white,
              borderColor: Colors.black,
              textColor: Colors.white,
              hintColor: Colors.black.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "email",
              "Email",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Email can't be empty";
                }
                return null;
              },
                  (onSavedVal) {
                email = onSavedVal;
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.email),
              borderFocusColor: Colors.green,
              prefixIconColor: Colors.white,
              borderColor: Colors.black,
              textColor: Colors.white,
              hintColor: Colors.black.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "phoneNumber",
              "Phone Number",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Phone Number can't be empty";
                }
                return null;
              },
                  (onSavedVal) {
                phoneNumber = onSavedVal;
              },

              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.call),
              borderFocusColor: Colors.green,
              prefixIconColor: Colors.white,
              borderColor: Colors.black,
              textColor: Colors.white,
              hintColor: Colors.black.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              "password",
              "Password",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Password can't be empty";
                }
                return null;
              },
                  (onSavedVal) {
                password = onSavedVal;
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.lock),
              borderFocusColor: Colors.green,
              prefixIconColor: Colors.white,
              borderColor: Colors.black,
              textColor: Colors.white,
              hintColor: Colors.black.withOpacity(0.2),
              obscureText: hidePwd,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePwd = !hidePwd;
                    });
                  },
                  color: Colors.white.withOpacity(0.7),
                  icon: Icon(
                    hidePwd ?  Icons.visibility: Icons.visibility_off,
                  )),
            ),
          ),

          const SizedBox(
            height: 50,
          ),
          Center(
            child: FormHelper.submitButton(
              "Save",
                  () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  NewAdminRequestModel model = NewAdminRequestModel(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    password: password,
                  );
                  UserService.newAdmin(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    FormHelper.showSimpleAlertDialog(context, Config.appName,
                        response.success, "OK", () {
                          Navigator.pop(context);
                        });
                  });
                }
              },
              btnColor: Colors.white,
              borderColor: Colors.black,
              txtColor: Colors.black,
            ),
          ),

        ],
      ),
    );
  }
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}