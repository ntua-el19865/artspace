import 'package:flutter/material.dart';
import 'package:untitled2/Components/items.dart';


class SpacedItemsList extends StatefulWidget {
  final List<Map<String, dynamic>> designDetailsList;
  final int usrId;

  const SpacedItemsList({
    Key? key,
    required this.designDetailsList,
    required this.usrId,
  }) : super(key: key);

  @override
  _SpacedItemsListState createState() => _SpacedItemsListState();
}

class _SpacedItemsListState extends State<SpacedItemsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.designDetailsList.length,
      itemBuilder: (context, index) {
        return LikeCard(
          designDetails: widget.designDetailsList[index],
          loggedInUserId: widget.usrId,
        );
      },
    );
  }
}