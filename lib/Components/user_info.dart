import 'package:flutter/material.dart';
import 'package:untitled2/provider/provider.dart'; // Import your provider if needed
import 'package:untitled2/SQLite/database_helper.dart';

import '../JSON/users.dart'; // Import your DatabaseHelper

class UserInfo extends StatelessWidget {
  final int usrId;

  const UserInfo({Key? key, required this.usrId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: DatabaseHelper.instance.getUserById(usrId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text("User not found");
        } else {
          final UserModel user = snapshot.data!;

          return Container(
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        user.usrName ?? "",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.description ?? "Bio",
                          style: const TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
