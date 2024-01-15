import 'package:flutter/material.dart';
import 'package:untitled2/screens/profile/gallery_screen.dart';
import 'package:untitled2/Components/user_info.dart';
import 'package:untitled2/Components/user_profile_image.dart';
import 'package:untitled2/Components/bottom_navigation_bar.dart';
import 'package:untitled2/SQLite/database_helper.dart';
import 'package:untitled2/screens/home.dart';
import 'package:untitled2/screens/search/search.dart';
import '../../JSON/users.dart'; // Import your DatabaseHelper
import 'package:untitled2/Components/user_activity.dart';
import 'package:untitled2/screens/uploaddesign.dart';

import 'my_gallery_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.usrId, required this.imageUrl}) : super(key: key);

  final int usrId;
  final String? imageUrl;// Assuming usrId is directly available

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int _currentIndex;
  late int _selectedevent;
  UserModel? user;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = 2;
    _selectedevent = 0;
    _pages = [GalleryScreen(usrId: widget.usrId),MyGalleryScreen(usrId: widget.usrId)];

    fetchUserDetails();
  }

  void onLikedPressed() {
    setState(() {
      _selectedevent = 0;
    });
  }

  void onMyDesignsPressed() {
    setState(() {
      _selectedevent = 1;
    });
  }

  void _onTap(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _buildPage(index),
      ),
    );
  }

  Widget _buildPage(int index) {
    if (index == 0) {
      return HomePage(usrId: widget.usrId);
    } else if (index == 1) {
      return SearchScreen(usrId: widget.usrId,imageUrl: widget.imageUrl);
    } else if (index == 2) {
      return GalleryScreen(usrId: widget.usrId);
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      user = await DatabaseHelper.instance.getUserById(widget.usrId);
      if (user != null) {
        setState(() {});
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: UserImage(usrId: widget.usrId, user: user,imageUrl:widget.imageUrl),
            ),
            SliverToBoxAdapter(
              child: UserInfo(usrId: widget.usrId),
            ),
            SliverToBoxAdapter(
              child: UserActivity(
                onLikedPressed: onLikedPressed,
                onMyDesignsPressed: onMyDesignsPressed,
              ),
            ),
            SliverFillRemaining(
              child: _pages[_selectedevent],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  UploadDesignPage(usrId: widget.usrId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}


