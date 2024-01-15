import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled2/Components/profileicon.dart';

class TopNavigationBar extends StatelessWidget {
  final String? imageUrl; // Add imageUrl as a parameter

  const TopNavigationBar({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: true,
      floating: false,
      snap: false,
      centerTitle: true,
      leading: SizedBox.shrink(), // Set the leading property to an empty widget
      title: Text(
        'Art Space',
        style: TextStyle(fontSize: 30),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(child: ProfileIcon(imageUrl: imageUrl)// Use the default image if imageUrl is null
          ),
        ),
      ],
    );
  }
}