import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled2/screens/login.dart';
import 'package:untitled2/screens/profile/edit_profile_screen.dart';
import '../JSON/users.dart'; // Import your UserModel class

enum Menu { signOut, editprofile }

class UserImage extends StatelessWidget {
  final int usrId;
  final UserModel? user;
  final String? imageUrl;

  const UserImage({Key? key, required this.usrId, required this.user,required this.imageUrl}) : super(key: key);

  void _onSignOutSelected(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
    );
  }

  void _onEditProfileSelected(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EditProfile(usrId: usrId, imageUrl: user!.imageUrl ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("Size: $size"); // Print the size for debugging
    return Stack(
      children: [
        Container(
          width: size.width,
          height: 200,
          color: Colors.transparent,
          padding: const EdgeInsets.only(bottom: 150 / 2.2),
          child: Container(
            width: size.width,
            height: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(10, 10),
                bottomRight: Radius.elliptical(10, 10),
              ),
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.ledr.com/colours/white.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // * 1 menubutton (Row widget)
        Positioned(
          top: 10,
          right: 10,
          child: PopupMenuButton<Menu>(
            onSelected: (Menu item) {
              if (item == Menu.editprofile) {
                _onEditProfileSelected(context);
              } else if (item == Menu.signOut) {
                _onSignOutSelected(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<Menu>(
                  value: Menu.editprofile,
                  child: Text('Edit Profile'),
                ),
                const PopupMenuItem(
                  value: Menu.signOut,
                  child: Text('Sign Out'),
                ),
              ];
            },
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ),

        // * user profile image
        Positioned(
          top: 100 / 2,
          left: size.width / 2.7,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
              shape: BoxShape.circle,
              image: DecorationImage(
                // Use a conditional expression to choose between imageUrl and default image path
                image: user?.imageUrl != null
                    ? Image.memory(
                  // Decode the base64 string to bytes and create a Uint8List
                  base64Decode(user!.imageUrl!),
                  fit: BoxFit.cover,
                ).image // Explicit cast
                    : AssetImage("assets/img.png") as ImageProvider<Object>, // Use AssetImage for local assets
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

