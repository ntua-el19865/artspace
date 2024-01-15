import 'package:flutter/material.dart';
class UserActivity extends StatelessWidget {
  final VoidCallback onLikedPressed;
  final VoidCallback onMyDesignsPressed;

  const UserActivity({
    Key? key,
    required this.onLikedPressed,
    required this.onMyDesignsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Button for "Liked"
        Expanded(
          child: ElevatedButton(
            onPressed: onLikedPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Adjust color as needed
              padding: EdgeInsets.all(8),
            ),
            child: Column(
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 20),
                const SizedBox(height: 2),
                const Text("Liked",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),

        // Button for "My Designs"
        Expanded(
          child: ElevatedButton(
            onPressed: onMyDesignsPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // Adjust color as needed
              padding: EdgeInsets.all(8),
            ),
            child: Column(
              children: [
                const Icon(Icons.palette, color: Colors.white, size: 20),
                const SizedBox(height: 2),
                const Text("My Designs",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}