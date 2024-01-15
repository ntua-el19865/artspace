import 'package:flutter/material.dart';
import 'package:untitled2/Components/items.dart';


class LikedSpacedItemsList extends StatelessWidget {
  final List<Map<String, dynamic>> designDetailsList;
  final int usrId;

  const LikedSpacedItemsList({
    Key? key,
    required this.designDetailsList,
    required this.usrId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: designDetailsList.length,
      itemBuilder: (context, index) {
        return LikeCard(
          designDetails: designDetailsList[index],
          loggedInUserId: usrId,
        );
      },
    );
  }
}