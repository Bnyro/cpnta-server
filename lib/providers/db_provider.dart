import '../database/app_database.dart';

class DbProvider {
  static final DbProvider _singleton = DbProvider._internal();
  AppDatabase? _db;

  factory DbProvider() {
    return _singleton;
  }

  Future<AppDatabase> _createDataBase() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  Future<AppDatabase> getDatabase() async {
    if (_db == null) {
      return await _createDataBase();
    } else {
      return _db!;
    }
  }

  DbProvider._internal();
}
