import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavourites = ref.watch(currentUserNotifierProvider.select(
      (data) => data!.favourites,
    ));

    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const MusicPlayer();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween =
                Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeIn),
            );

            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ));
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: hexToColor(currentSong.hex_code),
            ),
            padding: const EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "music-image",
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.song_name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Pallete.subtitleText,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(homeViewModelProvider.notifier)
                            .favouriteSong(songId: currentSong.id);
                      },
                      icon: Icon(
                        userFavourites
                                .where(
                                  (favSong) => favSong.id == currentSong.id,
                                )
                                .toList()
                                .isNotEmpty
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Pallete.whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: songNotifier.playPause,
                      icon: Icon(
                        songNotifier.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Pallete.whiteColor,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                double screenWidth = MediaQuery.of(context).size.width;
                double silderValue = 0.0;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                final position = snapshot.data;
                final duration = songNotifier.audioPlayer!.duration;

                if (position != null && duration != null) {
                  silderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }
                return Positioned(
                  bottom: 0,
                  left: 8,
                  child: Container(
                    height: 2,
                    width: silderValue * (screenWidth - 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Pallete.whiteColor,
                    ),
                  ),
                );
              }),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Pallete.inactiveSeekColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
