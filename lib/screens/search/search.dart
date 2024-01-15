import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled2/Components/bottom_navigation_bar.dart';
import 'package:untitled2/screens/profile/profile.dart';
import 'package:untitled2/screens/home.dart';
import 'package:untitled2/screens/profile/profile.dart' show ProfilePage;
import 'package:untitled2/Components/search_items_list.dart';
import 'package:untitled2/SQLite/database_helper.dart';

import '../../Components/profileicon.dart';

class SearchScreen extends StatefulWidget {
  final int usrId;
  final String? imageUrl;

  const SearchScreen({Key? key, required this.usrId,required this.imageUrl}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentIndex = 1; // Set the initial index for the bottom navigation bar
  late List<Widget> _pageOptions;
  late List<Map<String?, dynamic>> searchDetailsList = [];
  TextEditingController _searchController = TextEditingController();

  get imageUrl => widget.imageUrl;

  @override
  void initState() {
    super.initState();
    _initializePageOptions();
  }

  void _initializePageOptions() {
    _pageOptions = [
      HomePage(usrId: widget.usrId), // Pass usrId directly to HomePage
      SearchScreen(usrId: widget.usrId,imageUrl: widget.imageUrl,), // Pass usrId directly to SearchScreen
      ProfilePage(usrId: widget.usrId, imageUrl: widget.imageUrl), // Pass usrId directly to ProfilePage
    ];
  }

  void _onTap(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => _pageOptions[index]),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isNotEmpty) {
      searchDetailsList = await DatabaseHelper.instance.searchDesignsWithDetails(query);
    } else {
      searchDetailsList.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for designs',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: _performSearch,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.search), // Replace with the search icon
          onPressed: () {
            // You can perform any specific action when the search icon is pressed
          },
        ),
      ),
      body: SearchedSpacedItemsList(
        searchDetailsList: searchDetailsList,
        usrId: widget.usrId,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search for designs',
        onPressed: () async {
          // Perform search using the query from the controller
          await _performSearch(_searchController.text);
        },
        child: const Icon(Icons.search),
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
