import 'dart:convert';
import 'dart:io';
import 'package:untitled2/SQLite/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/Components/circular_progress.dart';
import 'package:untitled2/Components/button.dart';
import 'package:untitled2/screens/profile/profile.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.usrId, required this.imageUrl}) : super(key: key);

  final int usrId;
  final String? imageUrl;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;

  XFile? _pickedImage;


  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<String> getImageBase64(XFile imageFile) async {
    try {
      List<int> imageBytes = await getImageBytes(imageFile);
      return base64Encode(imageBytes);
    } catch (e) {
      print("Error encoding image: $e");
      return ''; // or handle the error in a way suitable for your application
    }
  }

  Future<List<int>> getImageBytes(XFile imageFile) async {
    try {
      File file = File(imageFile.path);
      return await file.readAsBytes();
    } catch (e) {
      print("Error reading image bytes: $e");
      return []; // or handle the error in a way suitable for your application
    }
  }

  @override
  Widget build(BuildContext context) {
    Column buildDisplayNameField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Username",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              hintText: "Enter new username",
              errorText: _displayNameValid ? null : "Display Name too short",
            ),
          ),
        ],
      );
    }

    Column buildBioField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Bio",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: bioController,
            decoration: InputDecoration(
              hintText: "Enter your bio",
              errorText: _bioValid ? null : "Bio too long",
            ),
          ),
        ],
      );
    }

    Future<void> updateUser() async {
      setState(() {
        displayNameController.text.trim().length < 3 || displayNameController.text.isEmpty
            ? _displayNameValid = false
            : _displayNameValid = true;
        bioController.text.trim().length > 100 ? _bioValid = false : _bioValid = true;
      });

      if (_displayNameValid && _bioValid) {
        String? imageUrl = _pickedImage != null ? await getImageBase64(_pickedImage!) : null;

        // Update the user information in the database
        await DatabaseHelper.instance.updateUser(
          widget.usrId,
          usrName: displayNameController.text,
          description: bioController.text,
          imageUrl: imageUrl,
        );

        print("user updated!");

        // Display a snackbar
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated!")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ProfilePage(usrId: widget.usrId,imageUrl: widget.imageUrl),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                  ),
                  child: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _pickedImage != null
                          ? Image.file(File(_pickedImage!.path), width: 100,)
                          : Image.asset("assets/img.png", width: 100,),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                    ],
                  ),
                ),
                Button(
                  label: "Update Profile",
                  press: updateUser,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.photo),
      ),
    );
  }
}


