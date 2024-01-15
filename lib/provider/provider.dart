import 'package:flutter/material.dart';
import 'package:untitled2/SQLite/database_helper.dart';
import 'package:untitled2/JSON/users.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;
  List<LikesProvider> likesList = [];
  List<DesignProvider> designList = [];
  List<UserProvider> userList = [];
  String? fullName;
  String? usrName;
  String? email;
  String? description;
  String? imageUrl;
  String? designImage;
  String? usrPassword;
  int? designId;

  UserProvider({
    this.fullName,
    this.usrName,
    this.email,
    this.description,
    this.imageUrl,
    this.designId,
    this.designImage,
    this.usrPassword, required int? usrId,
  });

  int? get usrId => _userModel?.usrId;  // Use the getter from _userModel

  UserModel? get user => _userModel;

  void setUserDetails(UserModel userModel) async {
    _userModel = userModel;
    likesList = await fetchLikesList(userModel.usrId);
    designList = await fetchDesignList(userModel.usrId);
    userList = (await fetchUserList(userModel.usrId)).cast<UserProvider>();

    print('User details updated: ${userModel.usrId}, ${userModel.usrName}, ${userModel.fullName}, ${userModel.email}, ${userModel.description}, ${userModel.imageUrl}, ${userModel.designImage},${userModel.designId},${userModel.usrPassword}');

    notifyListeners();
  }

  Future<List<LikesProvider>> fetchLikesList(int? userId) async {
    List<Map<String, dynamic>> likesData = await DatabaseHelper.instance.getLikesForUser(userId);
    return likesData.map((data) => LikesProvider.fromMap(data)).toList();
  }

  Future<List<DesignProvider>> fetchDesignList(int? userId) async {
    List<Map<String, dynamic>> designData = await DatabaseHelper.instance.getDesignsForUser(userId);
    return designData.map((data) => DesignProvider.fromMap(data)).toList();
  }

  Future<List<UserModel>> fetchUserList(int? userId) async {
    List<Map<String, dynamic>> userModelData = await DatabaseHelper.instance.getUsers();
    return userModelData.map((data) => UserModel.fromMap(data)).toList();
  }

  // Add the fromMap method to convert data from the database to UserProvider
  factory UserProvider.fromMap(Map<String, dynamic> map) {
    return UserProvider(
      usrName: map['usrName'],
      fullName: map['fullName'],
      email: map['email'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      usrId: (map['usrId'] as  int?) ?? 0,
      usrPassword: map['usrPassword'],
      designId: map['designId'],
      designImage: map['designImage']
    );
  }

  // Add the toMap method to convert data from UserProvider to Map
  Map<String, dynamic> toMap() {
    return {
      'usrName': usrName ?? '',
      'fullName': fullName ?? '',
      'email': email ?? '',
      'description': description ?? '',
      'imageUrl': imageUrl ?? '',
      'usrId': usrId ?? 0,
      'designId': designId ?? '',
      'designImage': designImage ?? '',
      'usrPassword': usrPassword ?? '',

    };

  }
}

class DesignProvider extends ChangeNotifier {
  int? designId;
  String? usrName;
  String? design_descr;
  String? designImage;
  int? usrId;

  DesignProvider({this.designId, this.usrName, this.design_descr, this.designImage, this.usrId});

  factory DesignProvider.fromMap(Map<String, dynamic> map) {
    return DesignProvider(
      designId: map['designId'],
      usrName: map['usrName'],
      design_descr: map['design_descr'],
      designImage: map['designImage'],
      usrId: map['usrId'],
    );
  }
}

class LikesProvider extends ChangeNotifier {
  int? likesId;
  int? usrId;
  int? designId;
  String? usrName;
  String? designDescr;
  String? imageUrl;
  String? designImage;

  LikesProvider({
    this.likesId,
    this.usrId,
    this.designId,
    this.usrName,
    this.designDescr,
    this.imageUrl,
    this.designImage,
  });

  factory LikesProvider.fromMap(Map<String, dynamic> map) {
    return LikesProvider(
      likesId: map['likesId'],
      usrId: map['usrId'],
      designId: map['designId'],
      usrName: map['usrName'],
      designDescr: map['designDescr'],
      imageUrl: map['imageUrl'],
      designImage: map['designImage'],
    );
  }
}