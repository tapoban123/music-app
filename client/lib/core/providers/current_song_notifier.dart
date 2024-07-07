import 'package:client/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
    );

    audioPlayer!.playerStateStream.listen(
      (playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;

          state = state?.copyWith(song_name: state?.song_name);
        }
      },
    );

    audioPlayer!.setAudioSource(audioSource);

    isPlaying = true;
    audioPlayer!.play();

    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }

    isPlaying = !isPlaying;

    state = state?.copyWith(song_name: state?.song_name);
  }
}
