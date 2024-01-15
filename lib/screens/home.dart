import 'package:flutter/material.dart';
import 'package:untitled2/Components/items_list.dart';
import 'package:untitled2/Components/top_navigation_bar.dart';
import 'package:untitled2/Components/bottom_navigation_bar.dart';
import 'package:untitled2/screens/search/search.dart';
import 'package:untitled2/screens/profile/profile.dart';
import '../SQLite/database_helper.dart';

class HomePage extends StatefulWidget {
  final int usrId;

  const HomePage({Key? key, required this.usrId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> designDetailsList = [];
  String? userImageUrl = ''; // New variable to store user image URL
  late List<Widget> _pageOptions;

  @override
  void initState() {
    super.initState();
    _generateDesignDetailsList();
    _initializePageOptions();
  }

  Future<void> _generateDesignDetailsList() async {
    // Fetch design details
    designDetailsList = await DatabaseHelper.instance.getDesignsWithDetails();

    // Fetch user details to get the image URL
    final user = await DatabaseHelper.instance.getUserById(widget.usrId);
    if (user != null) {
      userImageUrl = user.imageUrl ?? ''; // Use the user's image URL if available
    }

    setState(() {});
  }

  void _initializePageOptions() {
    _pageOptions = [
      // Pass usrId directly to the ProfilePage widget
      HomePage(usrId: widget.usrId),
      SearchScreen(usrId: widget.usrId, imageUrl: userImageUrl),
      ProfilePage(usrId: widget.usrId,imageUrl: userImageUrl), // Pass usrId and imageUrl directly to ProfilePage
    ];
  }

  void _onTap(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        // Pass usrId and imageUrl to the selected page
        return _pageOptions[index];
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TopNavigationBar(imageUrl: userImageUrl), // Pass imageUrl to the TopNavigationBar
          SliverToBoxAdapter(
            child: Center(
              child: SafeArea(
                child: SizedBox(
                  height: 600,
                  child: SpacedItemsList(
                    designDetailsList: designDetailsList,
                    usrId:widget.usrId,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onTap(index);
        },
      ),
    );
  }
}

