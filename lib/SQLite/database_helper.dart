import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../JSON/users.dart';

class DatabaseHelper {
  final databaseName = "artspace_latest.db";

  // Define the instance variable for the singleton
  static DatabaseHelper? _instance;

  // Private constructor to prevent multiple instances
  DatabaseHelper._();

  // Getter for the singleton instance
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  // Tables
  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT,
   usrName TEXT UNIQUE,
   usrPassword TEXT,
   imageUrl TEXT,
   description TEXT
   )
   ''';

  String design = '''
  CREATE TABLE designs (
  designId INTEGER PRIMARY KEY AUTOINCREMENT,
  designdescr TEXT,
  likes INTEGER,
  designImage TEXT,
  usrID INTEGER,
  FOREIGN KEY (usrID) REFERENCES users(usrId),
  FOREIGN KEY (likes) REFERENCES likes(likeId)
  )
  ''';

  String likes = '''
  CREATE TABLE likes (
  likeId INTEGER PRIMARY KEY AUTOINCREMENT,
  usrID INTEGER,
  designID INTEGER,
  FOREIGN KEY (usrID) REFERENCES users(usrId),
  FOREIGN KEY (designID) REFERENCES designs(designId)
  )
  ''';

  // Our connection is ready
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(user);
      await db.execute(design);
      await db.execute(likes);
    },
        onUpgrade: (db, oldVersion, newVersion) async {});
  }

  // Function methods

  // Authentication
  Future<bool> authenticate(UserModel usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.usrPassword}' ");
    await db.close(); // Close the database connection
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Sign up
  Future<int> createUser(UserModel usr) async {
    final Database db = await initDB();
    var result = await db.insert("users", usr.toMap());
    await db.close(); // Close the database connection
    return result;
  }

  // Get current User details
  Future<UserModel?> getUser(String usrName) async {
    final Database db = await initDB();
    var res = await db.query(
        "users", where: "usrName = ?", whereArgs: [usrName]);
    await db.close(); // Close the database connection
    return res.isNotEmpty ? UserModel.fromMap(res.first) : null;
  }

  // Update user details
  Future<int> updateUser(int usrId, {String? usrName, String? description, String? imageUrl}) async {
    final Database db = await initDB();
    print("Updating User with usrId: $usrId");

    if (usrId == null) {
      print("Invalid usrId. Cannot update user.");
      return 0;
    }

    try {
      // Retrieve existing user data
      var existingUserData = await db.query(
        "users",
        columns: ["fullName", "email", "usrName", "usrPassword", "imageUrl", "description"],
        where: "usrId = ?",
        whereArgs: [usrId],
      );

      if (existingUserData.isEmpty) {
        print("User not found for update");
        return 0;
      }

      // Convert existing data to Map<String, Object>
      var existingUserDataMap = Map<String, Object?>.from(existingUserData.first);

      // Convert update data to Map<String, Object?>
      var updateData = <String, Object?>{
        "usrName": usrName,
        "description": description,
        "imageUrl": imageUrl,
      };

      // Merge existing data with updateData, keeping existing values if not updated
      updateData.forEach((key, value) {
        if (value != null) {
          existingUserDataMap[key] = value;
        }
      });

      // Remove entries with null or empty values
      existingUserDataMap.removeWhere((key, value) => value == '' || value == null);

      print("Merged Data: $existingUserDataMap");

      // Update the user
      var result = await db.update(
        "users",
        existingUserDataMap,
        where: "usrId = ?",
        whereArgs: [usrId],
      );

      print("Update Result: $result");
      print("Data Updated");

      return result;
    } catch (e) {
      print("Error updating user: $e");
      return 0;
    } finally {
      await db.close();
    }
  }




  Future<int?> getLikesCount() async {
    final Database db = await initDB();
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM likes'));
  }

  Future<int?> getdesignCount() async {
    final Database db = await initDB();
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM designs'));
  }

  Future<int> addLike(int userId, int designId) async {
    final Database db = await initDB();
    try {
      // Insert the like into the database
      int newLikeId = await db.insert(
        'likes',
        {'usrID': userId, 'designID': designId},
      );

      print('Like added with ID: $newLikeId');
      return newLikeId;
    } catch (e) {
      print('Error adding like: $e');
      return 0;
    } finally {
      await db.close();
    }
  }

  Future<void> removeLike(int likeId) async {
    final Database db = await initDB();
    try {
      // Delete the like from the database
      await db.delete('likes', where: 'likeId = ?', whereArgs: [likeId]);

      print('Like removed with ID: $likeId');
    } catch (e) {
      print('Error removing like: $e');
    } finally {
      await db.close();
    }
  }

  Future<List<Map<String, dynamic>>> getLikesForUser(int? userId) async {
    final Database db = await initDB();
    return await db.query('likes', where: 'usrId = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getDesignsForUser(int? userId) async {
    final Database db = await initDB();
    return await db.query('designs', where: 'usrId = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final Database db = await initDB();
    return await db.query('users');
  }
  Future<UserModel?> getUserById(int usrId) async {
    final Database db = await initDB();
    var res = await db.query("users", where: "usrId = ?", whereArgs: [usrId]);
    //await db.close(); // Close the database connection
    return res.isNotEmpty ? UserModel.fromMap(res.first) : null;
  }
  Future<int> uploadDesign(int userId, {String? designDescription, String? imageUrl}) async {
    final Database db = await initDB();

    try {
      // Insert the design details into the designs table
      int newDesignId = await db.insert(
        'designs',
        {'usrID': userId, 'designdescr': designDescription, 'designImage': imageUrl},
      );

      print('Design uploaded with ID: $newDesignId');
      return newDesignId;
    } catch (e) {
      print('Error uploading design: $e');
      return 0;
    } finally {
      await db.close();
    }
  }
  Future<List<Map<String, dynamic>>> getDesigns() async {
    final Database db = await initDB();
    return await db.query('designs');
  }

  Future<List<Map<String, dynamic>>> getDesignsWithDetails() async {
    final Database db = await initDB();

    try {
      // Fetch designs along with user details and likes count
      var result = await db.rawQuery('''
        SELECT designs.designId, designs.designdescr, designs.designImage,
               users.usrName, users.imageUrl,
               COUNT(likes.likeId) AS likesCount
        FROM designs
        LEFT JOIN users ON designs.usrID = users.usrId
        LEFT JOIN likes ON designs.designId = likes.designID
        GROUP BY designs.designId
      ''');

      return result;
    } catch (e) {
      print('Error fetching designs with details: $e');
      return [];
    } finally {
      await db.close();
    }
  }

  Future<bool> doesLikeExist(int userId, int designId) async {
    final Database db = await initDB();

    try {
      var result = await db.query(
        'likes',
        where: 'usrID = ? AND designID = ?',
        whereArgs: [userId, designId],
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Error checking if like exists: $e');
      return false;
    } finally {
      await db.close();
    }
  }

  Future<void> removeLikeByUserAndDesign(int userId, int designId) async {
    final Database db = await initDB();

    try {
      await db.delete(
        'likes',
        where: 'usrID = ? AND designID = ?',
        whereArgs: [userId, designId],
      );

      print('Like removed for userId: $userId, designId: $designId');
    } catch (e) {
      print('Error removing like: $e');
    } finally {
      await db.close();
    }
  }

  Future<List<Map<String, dynamic>>> getLikedDesignsWithDetails(int userId) async {
    final Database db = await initDB(); // Open the database

    try {
      // Fetch designs liked by the specified user along with user details and likes count
      var result = await db.rawQuery('''
      SELECT designs.designId, designs.designdescr, designs.designImage,
             users.usrName, users.imageUrl,
             COUNT(likes.likeId) AS likesCount
      FROM designs
      LEFT JOIN users ON designs.usrID = users.usrId
      LEFT JOIN likes ON designs.designId = likes.designID
      WHERE likes.usrID = ?
      GROUP BY designs.designId
    ''', [userId]);

      return result;
    } catch (e) {
      print('Error fetching liked designs with details: $e');
      return [];
    } finally {
      //await db.close(); // Close the database after the query
    }
  }

  Future<List<Map<String?, dynamic>>> searchDesignsWithDetails(String? searchQuery) async {
    final Database db = await initDB();

    try {
      // Fetch designs along with user details and likes count where designdescr contains the search query
      var result = await db.rawQuery('''
      SELECT designs.designId, designs.designdescr, designs.designImage,
             users.usrName, users.imageUrl,
             COUNT(likes.likeId) AS likesCount
      FROM designs
      LEFT JOIN users ON designs.usrID = users.usrId
      LEFT JOIN likes ON designs.designId = likes.designID
      WHERE designs.designdescr LIKE ?
      GROUP BY designs.designId
    ''', ['%$searchQuery%']);

      return result;
    } catch (e) {
      print('Error searching designs with details: $e');
      return [];
    } finally {
      await db.close();
    }
  }
  Future<List<Map<String, dynamic>>> getMyDesignsWithDetails(int userId) async {
    final Database db = await initDB(); // Open the database

    try {
      // Fetch designs liked by the specified user along with user details and likes count
      var result = await db.rawQuery('''
      SELECT designs.designId, designs.designdescr, designs.designImage,
             users.usrName, users.imageUrl,
             COUNT(likes.likeId) AS likesCount
      FROM designs
      LEFT JOIN users ON designs.usrID = users.usrId
      LEFT JOIN likes ON designs.designId = likes.designID
      WHERE users.usrID = ?
      GROUP BY designs.designId
    ''', [userId]);

      return result;
    } catch (e) {
      print('Error fetching liked designs with details: $e');
      return [];
    } finally {
      //await db.close(); // Close the database after the query
    }
  }
  Future<void> deleteDesign(int designId) async {
    final Database db = await initDB();

    try {
      // Delete the design from the designs table
      await db.delete('designs', where: 'designId = ?', whereArgs: [designId]);

      // Delete the corresponding likes for the design
      await db.delete('likes', where: 'designID = ?', whereArgs: [designId]);

      print('Design deleted with ID: $designId');
    } catch (e) {
      print('Error deleting design: $e');
    } finally {
      await db.close();
    }
  }
}