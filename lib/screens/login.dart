import 'package:flutter/material.dart';
import 'package:untitled2/Components/button.dart';
import 'package:untitled2/Components/colors.dart';
import 'package:untitled2/Components/textfield.dart';
import 'package:untitled2/screens/home.dart';
import 'package:untitled2/screens/signup.dart';
import '../JSON/users.dart';
import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for username and password
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper.instance;

  void login() async {
    try {
      UserModel? usrDetails = await DatabaseHelper.instance.getUser(usrName.text);
      var res = await DatabaseHelper.instance.authenticate(UserModel(
        usrName: usrName.text,
        usrPassword: password.text,
      ));

      if (res == true) {
        // Set user details directly without using Provider
        usrDetails?.usrId != null
            ? Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(usrId: usrDetails!.usrId!)))
            : print("User ID is nullflutter run");

      } else {
        // Otherwise show the error message
        setState(() {
          isLoginTrue = true;
        });
      }
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Art Space", style: TextStyle(color: primaryColor, fontSize: 40)),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password, passwordInvisible: true),
                ListTile(
                  horizontalTitleGap: 2,
                  title: const Text("Remember me"),
                  leading: Checkbox(
                    activeColor: primaryColor,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),
                Button(label: "LOGIN", press: () {
                  login();
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: const Text("SIGN UP"),
                    ),
                  ],
                ),
                // Access denied message in case when your username and password are incorrect
                // By default, we must hide it
                // When login is not true then display the message
                isLoginTrue ? Text("Username or password is incorrect", style: TextStyle(color: Colors.red.shade900)) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}