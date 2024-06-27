import 'dart:convert';
import 'dart:io';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  dynamic database;

  getDB() async {
    // Construct a file path to copy database to
    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    if (Platform.isIOS) PathProviderFoundation.registerWith();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "vetan_panjika_db.sqlite");

    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
        ByteData data =
            await rootBundle.load('assets/local_db/vetan_panjika_db.sqlite');
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
      }

      database = await openDatabase(path);
    } else {
      // Only copy if the database doesn't exist
      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
        // Load database from asset and copy
        ByteData data = await rootBundle
            .load(join('assets/local_db', 'vetan_panjika_db.sqlite'));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Save copied asset to documents
        await File(path).writeAsBytes(bytes);
      }
      database = await openDatabase(
        path,
      );
    }
  }

// Define a function that inserts data into the database
  insertToDB({required String queryForDB}) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the data into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.rawInsert(
      queryForDB,
    );
  }

// A method that retrieves all the data from the local db.
  Future getDataTable({required String queryForDB}) async {
    // Get a reference to the database.
    final db = await database;

    try {
      // Query the table for all data available.
      List maps = await db.rawQuery(queryForDB);
      var mapsToJson = json.encode(maps);
      maps = json.decode(mapsToJson);
      return maps;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future getTextTable({required String queryForDB}) async {
    // Get a reference to the database.
    final db = await database;

    try {
      // Query the table for all data available.
      var maps = await db.rawQuery(queryForDB);
      return maps;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> closeDataBase() async {
    await database.close();
  }

  updateTable({required String queryForDB}) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given data.
    await db.rawUpdate(
      queryForDB,
    );
  }

  emptyTable({required String queryForDB}) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the data from the database.
    await db.rawDelete(
      queryForDB,
    );
  }
}
