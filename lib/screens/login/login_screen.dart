import 'package:flutter/gestures.dart';
import 'package:smart_admin_dashboard/Services/user_service.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/widgets/app_button_widget.dart';
import 'package:smart_admin_dashboard/core/widgets/input_widget.dart';
import 'package:smart_admin_dashboard/screens/User/TableUserScreen.dart';
import 'package:smart_admin_dashboard/screens/home/home_screen.dart';
import 'package:smart_admin_dashboard/screens/login/components/slider_widget.dart';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../../config.dart';
import '../../models/Login_request_model.dart';
import 'dart:html' as html;

import '../../responsive.dart';

class Login extends StatefulWidget {
  Login({required this.title});
  final String title;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var tweenLeft = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  var tweenLeft2 = Tween<Offset>(begin: Offset(4, 0), end: Offset(2, 0))
      .chain(CurveTween(curve: Curves.ease));
  var tweenRight = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
      .chain(CurveTween(curve: Curves.ease));

  AnimationController? _animationController;

  var _isMoved = false;

  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForget = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isAPIcallProcess = false;
  bool hidePwd = true;
  @override
  void initState() {
    super.initState();
    checkCachedToken();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  void checkCachedToken() async {
    String? cachedToken = await getCachedToken();
    print(cachedToken);
    if (cachedToken != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => TableUserScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.white,
                child: SliderWidget(),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                color: bgColor,
                child: Center(
                  child: Card(
                    //elevation: 5,
                    color: bgColor,
                    child: Container(
                      padding: EdgeInsets.all(42),
                      width: MediaQuery.of(context).size.width / 3.6,
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          Image.asset("assets/logo/logo_icon.png", scale: 3),
                          SizedBox(height: 24.0),
                          //Flexible(
                          //  child: _loginScreen(context),
                          //),
                          Flexible(
                            child: Stack(
                              children: [
                                SlideTransition(
                                  position:
                                      _animationController!.drive(tweenRight),
                                  child: Stack(
                                      fit: StackFit.loose,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Form(
                                          key: _formKey,
                                          child: loginUI(context),
                                        ),
                                      ]),
                                ),
                                SlideTransition(
                                  position:
                                      _animationController!.drive(tweenLeft),
                                  child: Stack(
                                      fit: StackFit.loose,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Form(
                                          key: _formKeyForget,
                                            child: addFormUI(context),
                                        )

                                      ]),
                                ),
                                SlideTransition(
                                  position:
                                      _animationController!.drive(tweenLeft2),
                                  child: Stack(
                                      fit: StackFit.loose,
                                      clipBehavior: Clip.none,
                                      children: [
                                        otpFormUI(context),
                                      ]),
                                ),
                              ],
                            ),
                          ),

                          //Flexible(
                          //  child: SlideTransition(
                          //    position: _animationController!.drive(tweenLeft),
                          //    child: Stack(
                          //        fit: StackFit.loose,
                          //        clipBehavior: Clip.none,
                          //        children: [
                          //          _registerScreen(context),
                          //        ]),
                          //  ),
                          //),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container _registerScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 0.0,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputWidget(
              keyboardType: TextInputType.emailAddress,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              onChanged: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },

              topLabel: "Name",

              hintText: "Enter Name",
              // prefixIcon: FlutterIcons.chevron_left_fea,
            ),
            SizedBox(height: 8.0),
            InputWidget(
              keyboardType: TextInputType.emailAddress,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              onChanged: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },

              topLabel: "Email",

              hintText: "Enter E-mail",
              // prefixIcon: FlutterIcons.chevron_left_fea,
            ),
            SizedBox(height: 8.0),
            InputWidget(
              topLabel: "Password",
              obscureText: true,
              hintText: "Enter Password",
              onSaved: (String? uPassword) {},
              onChanged: (String? value) {},
              validator: (String? value) {},
            ),
            SizedBox(height: 24.0),
            AppButton(
              type: ButtonType.PRIMARY,
              text: "Sign Up",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text("Remember Me")
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Center(
              child: Wrap(
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isMoved) {
                        _animationController!.reverse();
                      } else {
                        _animationController!.forward();
                      }
                      _isMoved = !_isMoved;
                    },
                    child: Text("Sign In",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w400, color: greenColor)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginUI(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormHelper.inputFieldWidget(
            context,
            "phoneNumber",
            "Phone Number",
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
            prefixIcon: const Icon(Icons.call),
            borderFocusColor: Colors.pink,
            prefixIconColor: Colors.pinkAccent,
            borderColor: Colors.pinkAccent,
            textColor: Colors.pinkAccent,
            hintColor: Colors.pinkAccent.withOpacity(0.7),
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
                    hidePwd ? Icons.visibility : Icons.visibility_off,
                  )),
            ),
          ),
          InkWell(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 25, top: 10),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 14.5,
                    ),
                    children: [
                      TextSpan(
                        text: "Forget Password?",
                        style: TextStyle(
                          color: Colors.pinkAccent.withOpacity(0.6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              if (_isMoved) {
                _animationController!.reverse();
              } else {
                _animationController!.forward();
              }
              _isMoved = !_isMoved;
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: FormHelper.submitButton(
              "Login",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  LoginRequestModel model =
                      LoginRequestModel(email: email!, password: password!);
                  UserService.login(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    print(response.token);
                    if (response.status) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => TableUserScreen()),
                          (route) => false);
                    } else {
                      FormHelper.showSimpleAlertDialog(
                          context, Config.appName, response.error, "OK", () {
                        Navigator.pop(context);
                      });
                    }
                  });
                }
              },
              btnColor: Colors.white,
              borderColor: Colors.pink,
              txtColor: Colors.pink,
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
  bool validateAndSaveForget() {
    final form = _formKeyForget.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
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
          const SizedBox(
            height: 50,
          ),
          Center(
            child: FormHelper.submitButton(
              "Send",
                  () {

                if (validateAndSaveForget()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  print(email!);
                  UserService.forgetPwd(email!).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (response) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => TableUserScreen()),
                              (route) => false);
                    } else {
                      FormHelper.showSimpleAlertDialog(
                          context, Config.appName, "User dose not exist", "OK", () {
                        Navigator.pop(context);
                      });
                    }
                  });
                }
              },
              btnColor: Colors.white,
              borderColor: Colors.pink,
              txtColor: Colors.pink,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child:  RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.pinkAccent.withOpacity(0.8),
                    fontSize: 14.5,
                  ),
                  children: [
                    TextSpan(
                      text: "Cancel",
                      style: const TextStyle(

                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        if (_isMoved) {
                          _animationController!.reverse();
                        } else {
                          _animationController!.forward();
                        }
                        _isMoved = !_isMoved;
                      },
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
  Widget otpFormUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,

        children: [
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
          const SizedBox(
            height: 50,
          ),
          Center(
            child: FormHelper.submitButton(
              "Send",
              () {
                if (_isMoved) {
                _animationController!.reverse();
              } else {
                _animationController!.forward();
              }
              _isMoved = !_isMoved;},
              btnColor: Colors.white,
              borderColor: Colors.pink,
              txtColor: Colors.pink,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child:  RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.pinkAccent.withOpacity(0.8),
                    fontSize: 14.5,
                  ),
                  children: [
                    TextSpan(
                      text: "otp",
                      style: const TextStyle(

                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        if (_isMoved) {
                          _animationController!.reverse();
                        } else {
                          _animationController!.forward();
                        }
                        _isMoved = !_isMoved;
                      },
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
}

Future<String?> getCachedToken() async {
  try {
    String? token = html.window.localStorage['token'];
    print('Cached Token: $token');
    return token;
  } catch (e) {
    print('Error getting cached token: $e');
    return null;
  }
}
