import 'app_database.dart';

Future<AppDatabase> getDataBase() async {
  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
}
