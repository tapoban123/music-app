import 'package:client/features/home/models/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadLocalSong(SongModel songModel) {
    box.put(songModel.id, songModel.toJson());
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      var song = SongModel.fromJson(box.get(key));
      songs.add(song);
    }
    return songs;
  }
}
