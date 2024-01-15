import 'dart:convert';

class UserModel {
  int? usrId;
  int? designId;
  String? usrName;
  String? fullName;
  String? email;
  String? usrPassword;
  String? description;
  String? imageUrl;
  String? designImage;

  UserModel({
    this.usrId,
    this.designId,
    this.usrName,
    this.fullName,
    this.email,
    this.usrPassword,
    this.description,
    this.imageUrl,
    this.designImage,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      if (usrId != null) 'usrId': usrId,
      'fullName': fullName,
      'email': email,
      'usrName': usrName,
      'usrPassword': usrPassword,
      'imageUrl': imageUrl,
      'description': description,
      'designImage': designImage
    };

    // Remove entries with null values
    map.removeWhere((key, value) => value == null);

    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      usrId: map['usrId'],
      designId: map['designId'],
      usrName: map['usrName'],
      fullName: map['fullName'],
      email: map['email'],
      usrPassword: map['usrPassword'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      designImage: map['designImage']
    );
  }
}

// Change the function name to avoid conflicts
UserModel usersFromMap(String str) => UserModel.fromMap(json.decode(str));
String usersToMap(UserModel data) => json.encode(data.toMap());


class designs {
  int? designId;
  String? design;
  String? design_descr;
  int? usrId;

  designs({
    this.designId,
    this.design,
    this.design_descr,
    this.usrId,
  });

  Map<String, dynamic> toMap() {
    return {
      'usrId': usrId,
      'designId': designId,
      'design_descr': design_descr,
      'design': design,
    };
  }

  factory designs.fromMap(Map<String, dynamic> map) {
    return designs(
      usrId: map['usrId'],
      designId: map['designId'] ?? '',
      design_descr: map['design_descr'] ?? '',
      design: map['design'] ?? '',
    );
  }
}
likes likesFromMap(String str) => likes.fromMap(json.decode(str));

String likesToMap(UserModel data) => json.encode(data.toMap());

class likes {
  int? designId;
  int? id;
  int? usrId;

  likes({
    this.designId,
    this.id,
    this.usrId,
  });

  Map<String, dynamic> toMap() {
    return {
      'usrId': usrId,
      'designId': designId,
      'id': id,
    };
  }

  factory likes.fromMap(Map<String, dynamic> map) {
    return likes(
      usrId: map['usrId'],
      designId: map['designId'] ?? '',
      id: map['id'] ?? '',
    );
  }
}
