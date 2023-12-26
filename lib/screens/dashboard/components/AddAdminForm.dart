import 'package:smart_admin_dashboard/Services/user_service.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';


import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../../../config.dart';
import '../../../models/NewAdmin_request_model.dart';
import '../../../responsive.dart';



class AddAdminForm extends StatefulWidget {
  const AddAdminForm({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAdminForm> createState() => _AddAdminFormState();
}

class _AddAdminFormState extends State<AddAdminForm> {
  bool isAPIcallProcess = false;
  bool hidePwd = true;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late String phoneNumber="";
  late String password="";
  late String firstname = ""; // Initialize the variables
  late String lastname = "";
  late String username = "";
  late String email = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (Responsive.isDesktop(context))

          Form(
            key: globalKey,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
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
                      firstname = onSavedVal;
                    },
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.person),
                    borderFocusColor: Colors.pink,
                    prefixIconColor: Colors.pinkAccent,
                    borderColor: Colors.pinkAccent,
                    textColor: Colors.pinkAccent,
                    hintColor: Colors.pinkAccent.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
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
                      lastname = onSavedVal;
                    },
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.person),
                    borderFocusColor: Colors.pink,
                    prefixIconColor: Colors.pinkAccent,
                    borderColor: Colors.pinkAccent,
                    textColor: Colors.pinkAccent,
                    hintColor: Colors.pinkAccent.withOpacity(0.7),
                  ),
                ),
              ],
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
              borderFocusColor: Colors.pink,
              prefixIconColor: Colors.pinkAccent,
              borderColor: Colors.pinkAccent,
              textColor: Colors.pinkAccent,
              hintColor: Colors.pinkAccent.withOpacity(0.7),
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
                  return "Phone number can't be empty";
                }
                return null;
              },
                  (onSavedVal) {
                phoneNumber = onSavedVal;
              },
              isNumeric: true,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.call),
              borderFocusColor: Colors.pink,
              prefixIconColor: Colors.pinkAccent,
              borderColor: Colors.pinkAccent,
              textColor: Colors.pinkAccent,
              hintColor: Colors.pinkAccent.withOpacity(0.7),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
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
              borderFocusColor: Colors.pink,
              prefixIconColor: Colors.pinkAccent,
              borderColor: Colors.pinkAccent,
              textColor: Colors.pinkAccent,
              hintColor: Colors.pinkAccent.withOpacity(0.7),
              obscureText: hidePwd,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePwd = !hidePwd;
                    });
                  },
                  color: Colors.pinkAccent.withOpacity(0.7),
                  icon: Icon(
                     // Icons.visibility_off
                    hidePwd ? Icons.visibility_off : Icons.visibility,
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Register",
                  () {
                    print("new admin");

               /* if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });*/
                  NewAdminRequestModel model = NewAdminRequestModel(
                    firstName: firstname,
                    lastName: lastname,
                    email: email,
                    phoneNumber: phoneNumber,
                    password: password,
                  );
                  UserService.newAdmin(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (response.status) {
                      FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "${response.success}",
                          "OK", () {

                      });
                    } else {
                      FormHelper.showSimpleAlertDialog(
                          context, Config.appName, response.success, "OK", () {
                        Navigator.pop(context);
                      });
                    }
                  });
               // }
              },
              btnColor: Colors.white,
              borderColor: Colors.pink,
              txtColor: Colors.pink,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }


}
