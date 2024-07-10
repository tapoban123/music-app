import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider)!;
    final songNotifier = ref.watch(currentSongNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToColor(currentSong.hex_code),
            const Color(0xff121212),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/pull-down-arrow.png",
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Hero(
                  tag: "music-image",
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Pallete.subtitleText,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      final position = snapshot.data;
                      final duration = songNotifier.audioPlayer!.duration;
                      double sliderValue = 0.0;
                      if (position != null && duration != null) {
                        sliderValue =
                            position.inMilliseconds / duration.inMilliseconds;
                      }
                      return Column(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Pallete.whiteColor,
                                  inactiveTrackColor:
                                      Pallete.whiteColor.withOpacity(0.117),
                                  thumbColor: Pallete.whiteColor,
                                  trackHeight: 4,
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 1,
                                  value: sliderValue,
                                  onChanged: (value) {
                                    sliderValue = value;
                                  },
                                  onChangeEnd: (value) {
                                    
                                    songNotifier.seek(value);
                                  },
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // "${position?.inMinutes}:${((position?.inSeconds) ?? 0) < 10 ? "0${position?.inSeconds}" : position?.inSeconds}",
                                "${position?.toHHMMSS().substring(3)}",
                                style: const TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "${duration?.toHHMMSS().substring(3)}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Pallete.subtitleText,
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/shuffle.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/previous-song.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(
                          songNotifier.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          size: 80,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/next-song.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/repeat.png",
                          color: Pallete.whiteColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/connect-device.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/playlist.png",
                          color: Pallete.whiteColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
