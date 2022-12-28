import 'package:cpnta/models/commit.dart';
import 'package:floor/floor.dart';

@dao
abstract class CommitDao {
  @Query('SELECT * FROM Commits')
  Future<List<Commit>> getAllCommits();
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCommit(Commit commit);
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertCommits(List<Commit> commits);
  @update
  Future<void> updateCommit(Commit commit);
  @Query("DELETE FROM Commits where id = :id")
  Future<void> deleteCommit(int id);
  @delete
  Future<int> deleteAll(List<Commit> commits);
  @Query('DELETE FROM Commits')
  Future<void> clear();
}
