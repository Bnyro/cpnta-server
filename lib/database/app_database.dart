import 'dart:async';
import 'package:cpnta/database/commit_dao.dart';
import 'package:cpnta/database/note_dao.dart';
import 'package:cpnta/models/commit.dart';
import 'package:cpnta/models/note.dart';
import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
part 'app_database.g.dart';

@Database(version: 1, entities: [Note, Commit])
abstract class AppDatabase extends FloorDatabase {
  NoteDao get noteDao;
  CommitDao get commitDao;
}
