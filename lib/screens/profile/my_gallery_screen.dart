import 'package:flutter/material.dart';
import 'package:untitled2/Components/my_items_list.dart';
import 'package:untitled2/SQLite/database_helper.dart';

class MyGalleryScreen extends StatefulWidget {
  final int usrId;

  const MyGalleryScreen({Key? key, required this.usrId}) : super(key: key);

  @override
  _MyGalleryScreenState createState() => _MyGalleryScreenState();
}

class _MyGalleryScreenState extends State<MyGalleryScreen> {
  late Future<List<Map<String, dynamic>>> _designsFuture;

  @override
  void initState() {
    super.initState();
    _designsFuture = DatabaseHelper.instance.getMyDesignsWithDetails(widget.usrId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _designsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No designs found.'));
        } else {
          return MySpacedItemsList(
            designDetailsList: snapshot.data!,
            usrId: widget.usrId,
            onDelete: _handleItemDelete,
          );
        }
      },
    );
  }

  // Callback function to handle item deletion
  void _handleItemDelete(int designId) {
    // Remove the deleted item from the list
    setState(() {
      _designsFuture = _removeItemFromList(designId);
    });

    // Show a SnackBar or perform any other necessary actions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item deleted'),
      ),
    );
  }

  // Helper function to remove an item from the list
  Future<List<Map<String, dynamic>>> _removeItemFromList(int designId) async {
    List<Map<String, dynamic>> designsList = await _designsFuture;
    designsList.removeWhere((design) => design['designId'] == designId);
    return designsList;
  }
}