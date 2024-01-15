import 'package:flutter/material.dart';
import 'package:untitled2/Components/button.dart';
import 'package:untitled2/Components/colors.dart';
import 'package:untitled2/Components/textfield.dart';
import 'package:untitled2/screens/login.dart';

import '../JSON/users.dart';
import '../SQLite/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  //Controllers
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper.instance;
  void signUp() async {
    try {
      await DatabaseHelper.instance.createUser(UserModel(
        fullName: fullName.text,
        email: email.text,
        usrName: usrName.text,
        usrPassword: password.text,
      ));

      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      print('Error signing up: $e');
      // Handle the error, e.g., show an error message to the user
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Register New Account",style: TextStyle(color: primaryColor,fontSize: 55,fontWeight: FontWeight.bold),),
                ),

                const SizedBox(height: 20),
                InputField(hint: "Full name", icon: Icons.person, controller: fullName),
                InputField(hint: "Email", icon: Icons.email, controller: email),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true),
                InputField(hint: "Re-enter password", icon: Icons.lock, controller: confirmPassword,passwordInvisible: true),

                const SizedBox(height: 10),
                Button(label: "SIGN UP", press: (){
                  signUp();
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                        },
                        child: const Text("LOGIN"))
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}