import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:untitled2/provider/provider.dart';

import '../SQLite/database_helper.dart';

class MyCard extends StatefulWidget {
  final Map<String?, dynamic> designDetails;
  final int loggedInUserId;
  final Function onDelete;// Add this parameter

  const MyCard({
    required this.designDetails,
    required this.loggedInUserId,
    required this.onDelete,// Add this line
    Key? key,
  }) : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // Set the initial liked state based on whether likesId is present
    isLiked = widget.designDetails['likesCount'] != null && widget.designDetails['likesCount'] > 0;
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.designDetails['imageUrl'] ?? "";
    String designImage = widget.designDetails['designImage'] ?? "";

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Card(
        margin: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: Image.memory(base64Decode(imageUrl),fit:BoxFit.cover).image,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          children: [
                            Text(widget.designDetails['usrName'] ?? ""),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: "delete",
                          child: Text("Delete Post"),
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      if (value == "delete") {
                        handleDeletePost();
                      }
                    },
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                )
              ],
            ),

            // * post text
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 2,
              child: Card(
                elevation: 0,
                semanticContainer: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.memory(
                  base64Decode(designImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //*
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle like button tap
                      handleLike();
                    },
                    child: Container(
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleLike() async {
    int userId = widget.loggedInUserId; // Use the loggedInUserId directly
    int designId = widget.designDetails['designId'] ?? 0;

    try {
      // Check if the like already exists for the user and design
      bool likeExists = await DatabaseHelper.instance.doesLikeExist(userId, designId);

      if (likeExists) {
        // If the like exists, remove it from the database
        await DatabaseHelper.instance.removeLikeByUserAndDesign(userId, designId);
        setState(() {
          isLiked = false;
        });
      } else {
        // If the like doesn't exist, add it to the database
        await DatabaseHelper.instance.addLike(userId, designId);
        setState(() {
          isLiked = true;
        });
      }
    } catch (e) {
      print('Error handling like: $e');
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }
  void handleDeletePost() async {
    int designId = widget.designDetails['designId'] ?? 0;

    try {
      // Use the DatabaseHelper instance to delete the design and its data
      await DatabaseHelper.instance.deleteDesign(designId);

      widget.onDelete();

      // TODO: Add any additional UI updates or navigation logic if needed
    } catch (e) {
      print('Error handling delete post: $e');
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

}