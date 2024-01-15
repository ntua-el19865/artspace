import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:untitled2/screens/login.dart';

enum Menu { signOut }

class ProfileIcon extends StatelessWidget {
  final String? imageUrl;

  const ProfileIcon({Key? key, required this.imageUrl}) : super(key: key);

  void _onSignOutSelected(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Widget profileImage;

    try {
      if (imageUrl != null) {
        final Uint8List decodedBytes = base64Decode(imageUrl!);
        profileImage = Image.memory(decodedBytes);
      } else {
        profileImage = Image.asset('assets/img.png', fit: BoxFit.cover);
      }
    } catch (e) {
      print("Error decoding image: $e");
      // Provide a fallback image or handle the error accordingly.
      profileImage = Image.asset('assets/img.png', fit: BoxFit.cover);
    }

    return Material( // Add Material widget
      child: PopupMenuButton<Menu>(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: profileImage,
      ),
      onSelected: (Menu item) {
        if (item == Menu.signOut) {
          _onSignOutSelected(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.signOut,
          child: Text('Sign Out'),
        ),
      ],
    ),
    );
  }
}
