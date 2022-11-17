import 'package:cpnta/models/commit.dart';
import 'package:floor/floor.dart';

@dao
abstract class CommitDao {
  @Query('SELECT * FROM Commit')
  Future<List<Commit>> getAllCommits();
  @insert
  Future<void> insertCommit(Commit commit);
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertCommits(List<Commit> commits);
  @update
  Future<void> updateCommit(Commit commit);
  @Query("DELETE FROM Commit where id = :id")
  Future<void> deleteCommit(int id);
  @delete
  Future<int> deleteAll(List<Commit> commits);
  @Query('DELETE FROM Commit')
  Future<void> clear();
}
