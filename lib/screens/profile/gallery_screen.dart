import 'package:flutter/material.dart';
import 'package:untitled2/Components/liked_items_list.dart';
import 'package:untitled2/SQLite/database_helper.dart'; // Import your DatabaseHelper

class GalleryScreen extends StatefulWidget {
  final int usrId; // Pass the user ID from the ProfilePage

  const GalleryScreen({Key? key, required this.usrId}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {


  @override
  Widget build(BuildContext context) {
    debugPrint("Building GalleryScreen");

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getLikedDesignsWithDetails(widget.usrId),
      builder: (context, snapshot) {
        debugPrint("Building GalleryScreen for user ID: ${widget.usrId}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No liked designs found for user ID: ${widget.usrId}');
          return Center(child: Text('No liked designs found.'));
        } else {
          return LikedSpacedItemsList(
            designDetailsList: snapshot.data!,
            usrId:widget.usrId,
          );
        }
      },
    );
  }
}