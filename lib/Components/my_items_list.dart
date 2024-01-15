import 'package:flutter/material.dart';
import 'package:untitled2/Components/personal_items.dart';

class MySpacedItemsList extends StatefulWidget {
  final List<Map<String, dynamic>> designDetailsList;
  final int usrId;
  final Function(int designId) onDelete; // Add this parameter

  const MySpacedItemsList({
    Key? key,
    required this.designDetailsList,
    required this.usrId,
    required this.onDelete, // Add this line
  }) : super(key: key);

  @override
  _MySpacedItemsListState createState() => _MySpacedItemsListState();
}

class _MySpacedItemsListState extends State<MySpacedItemsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.designDetailsList.length,
      itemBuilder: (context, index) {
        return MyCard(
          designDetails: widget.designDetailsList[index],
          loggedInUserId: widget.usrId,
          onDelete: () {
            _handleItemDelete(index);
          },
        );
      },
    );
  }

  void _handleItemDelete(int index) {
    setState(() {
      // Remove the item from the list
      widget.onDelete(widget.designDetailsList[index]['designId']);
    });

    // Notify users about the deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item deleted'),
      ),
    );
  }
}