import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/SQLite/database_helper.dart';
import 'package:untitled2/Components/circular_progress.dart';
import 'package:untitled2/Components/button.dart';

class UploadDesignPage extends StatefulWidget {
  const UploadDesignPage({Key? key, required this.usrId}) : super(key: key);

  final int usrId;

  @override
  _UploadDesignPageState createState() => _UploadDesignPageState();
}

class _UploadDesignPageState extends State<UploadDesignPage> {
  TextEditingController designDescriptionController = TextEditingController();
  bool isLoading = false;
  bool _descriptionValid = true;

  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<String> getImageBase64(XFile imageFile) async {
    List<int> imageBytes = await getImageBytes(imageFile);
    return base64Encode(imageBytes);
  }

  Future<List<int>> getImageBytes(XFile imageFile) async {
    File file = File(imageFile.path);
    return await file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    Column buildDesignDescriptionField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Design Description",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: designDescriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter design description",
              errorText: _descriptionValid ? null : "Description too long",
            ),
          ),
        ],
      );
    }

    Future<void> uploadDesign() async {
      setState(() {
        designDescriptionController.text.trim().length > 100 ? _descriptionValid = false : _descriptionValid = true;
      });

      if (_descriptionValid) {
        String? imageUrl = _pickedImage != null ? await getImageBase64(_pickedImage!) : null;

        // Upload the design information to the database
        // Adjust the method below according to your database structure for design upload
        await DatabaseHelper.instance.uploadDesign(
          widget.usrId,
          designDescription: designDescriptionController.text,
          imageUrl: imageUrl,
        );

        print("design uploaded!");

        // Display a snackbar
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Design uploaded!")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Upload Design",
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
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1, // Set the height to half of the screen
            child: Column(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: _pickedImage != null
                      ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover,)
                      : Image.asset("assets/designplaceholder.jpg", fit: BoxFit.cover,),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDesignDescriptionField(),
                    ],
                  ),
                ),
                Button(
                  label: "Upload Design",
                  press: uploadDesign,
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