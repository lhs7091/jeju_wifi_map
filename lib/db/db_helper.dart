import 'package:jeju_wifi_map/model/data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = openDatabase(
      join(await getDatabasesPath(), 'wifi.db'),
      onCreate: (db, version) {
        return db.execute(
            'create table wifi(baseDate text, macAddress text, apGroupName text, installLocationDetail text, category text, categoryDetail text, addressDong text, addressDetail text, latitude text, longitude text, PRIMARY KEY (macAddress, latitude, longitude))');
      },
      version: 1,
    );

    return _db;
  }

  Future<void> insertWifi(List<Data> dataList) async {
    print("insertWifi start");
    final db = await database;
    var batch = db.batch();

    print(dataList.length);

    dataList.forEach((element) {
      batch.insert('wifi', element.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit().whenComplete(() {
      print('complete');
    });
  }

  Future<List<Data>> selectWifi() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('wifi');
    if (maps.length == 0) return null;
    return List.generate(maps.length, (index) {
      return Data(
        baseDate: maps[index]['baseDate'],
        macAddress: maps[index]['macAddress'],
        apGroupName: maps[index]['apGroupName'],
        installLocationDetail: maps[index]['installLocationDetail'],
        category: maps[index]['category'],
        categoryDetail: maps[index]['categoryDetail'],
        addressDong: maps[index]['addressDong'],
        addressDetail: maps[index]['addressDetail'],
        latitude: maps[index]['latitude'],
        longitude: maps[index]['longitude'],
      );
    });
  }

  Future<void> updateWifi(Data data) async {
    final db = await database;

    await db.update('wifi', data.toMap(),
        where: 'macAddress=?', whereArgs: [data.macAddress]);
  }

  Future<void> deleteWifi(Data data) async {
    final db = await database;

    await db.delete(
      'wifi',
      where: 'macAddress = ?',
      whereArgs: [data.macAddress],
    );
  }

  Future<int> getCount() async {
    final db = await database;

    var x = await db.rawQuery('SELECT COUNT (*) from wifi');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<void> deleteTable() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'wifi.db');

    // Delete the database
    await deleteDatabase(path);
  }
}
