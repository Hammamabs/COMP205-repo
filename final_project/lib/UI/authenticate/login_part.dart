import 'package:final_project/services/fireauth.dart';
import 'package:final_project/services/sharedpreference.dart';
import 'package:final_project/theme/theme.dart';
import 'package:final_project/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class LoginPart extends StatefulWidget {
  final Function changeSignIn;
  const LoginPart({Key? key, required this.changeSignIn}) : super(key: key);

  @override
  _LoginPartState createState() => _LoginPartState();
}

class _LoginPartState extends State<LoginPart> {
  final _userName = TextEditingController();
  final _password = TextEditingController();
  bool eye = true;

  static const String domain = "@agu.edu.tr";
  bool rememberMe = false;
  Icon eyeIcon = const Icon(Icons.remove_red_eye_outlined);

  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();

  @override
  void dispose() {
    focus1.dispose();
    focus2.dispose();
    super.dispose();
  }

  void fix(BuildContext context) {
    if (eye == true) {
      setState(() {
        eyeIcon = Icon(
          Icons.remove_red_eye_outlined,
          color: Theme.of(context).colorScheme.surface,
        );
      });
    } else {
      setState(() {
        eyeIcon = Icon(
          Icons.remove_red_eye_sharp,
          color: Theme.of(context).colorScheme.surface,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fix(context);
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Text(
            'Login',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: TextField(
              focusNode: focus1,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z.]"))],
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              cursorColor: gPrimaryGreyColor,
              controller: _userName,
              decoration: InputDecoration(
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                icon: Icon(Icons.email, color: Theme.of(context).colorScheme.surface),
                filled: true,
                suffixText: domain,
                hintText: 'Username',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: TextField(
              focusNode: focus2,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              cursorColor: gPrimaryGreyColor,
              obscureText: eye,
              controller: _password,
              decoration: InputDecoration(
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                icon: Icon(Icons.vpn_key_sharp, color: Theme.of(context).colorScheme.surface),
                suffixIcon: IconButton(
                  onPressed: () {
                    eye = !eye;
                    fix(context);
                  },
                  icon: eyeIcon,
                ),
                filled: true,
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rememberMe = !rememberMe;
                });
              },
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      shape: const CircleBorder(),
                      checkColor: Colors.white,
                      value: rememberMe,
                      activeColor: rPrimaryRedColor,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        focus1.unfocus();
                        focus2.unfocus();
                        widget.changeSignIn('forgPass');
                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  focus1.unfocus();
                  focus2.unfocus();
                  if (_userName.text.isEmpty || _password.text.isEmpty) {
                    alertDialog(context, "Cannot Sign In", "Please fill up all information");
                  } else {
                    String shouldNavigate = await FireAuth().signIn(
                      email: _userName.text + domain,
                      password: _password.text,
                    );
                    if (shouldNavigate == "true") {
                      if (rememberMe) {
                        await SharedPreference.saveLoggingIn(true);
                      } else {
                        await SharedPreference.saveLoggingIn(false);
                      }
                      await setUpDate();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/navigationBar', (route) => false);
                    } else {
                      alertDialog(context, "Cannot Sign In", shouldNavigate);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: rPrimaryRedColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Sign In"),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  focus1.unfocus();
                  focus2.unfocus();
                  widget.changeSignIn('signUp');
                },
                style: ElevatedButton.styleFrom(
                  primary: rPrimaryRedColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Sign Up"),
              ),
            ],
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/faculties_page');
            },
            child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.book,
                  size: 76,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(height: 20),
                Text(
                  'Faculties',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setUpDate() async {
    await SharedPreference.saveUserName(_userName.text.replaceAll(".", " ").toLowerCase());
    await SharedPreference.saveUserId(FireAuth().currentUserID);
    await SharedPreference.saveUserEmail(_userName.text.toLowerCase() + domain);
    Constants.getUpConstants();
  }
}
