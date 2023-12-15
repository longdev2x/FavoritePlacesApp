import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath =
      await sql.getDatabasesPath(); // lấy đường dẫn database trên máy

  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  // Lấy dữ liệu từ Databasse về để dùng, nó trả về map qua query
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String, 
        image: File(row['image'] as String),);
    }).toList();
    state = places;
  }

  void addPlace(String title, File image) async {
    // 3 dòng dưới để lưu ảnh đúng đường dẫn
    final appDir = await syspaths
        .getApplicationDocumentsDirectory(); // Lấy đường dẫn ứng dụng
    final filename = path.basename(image
        .path); //lấy tên từ đường dẫn đầy đủ của ảnh, vì ảnh đang lưu ở bộ nhớ đệm
    final copiedImage = await image.copy(
        '${appDir.path}/$filename'); //copy đường dẫn hiện tại đến đường dẫn mới trong thư mục Documents của ứng dụng.

    final newPlace = Place(title: title, image: copiedImage);

    final db = await _getDatabase();
    db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
      },
    );

    state = [...state, newPlace];
  }

  void removeItem(Place placeRemove) {
    state = state.where((place) {
      return place != placeRemove;
    }).toList();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>((ref) {
  return UserPlacesNotifier();
});
