import 'package:client/core/constants/loader.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSong();
    final currentSong = ref.watch(currentSongNotifierProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3],
                colors: [
                  hexToColor(currentSong.hex_code),
                  Pallete.transparentColor,
                ],
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recentlyPlayedSongs.isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    bottom: 36,
                  ),
                  child: SizedBox(
                    height: 280,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: recentlyPlayedSongs.length,
                      itemBuilder: (context, index) {
                        final song = recentlyPlayedSongs[index];

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(currentSongNotifierProvider.notifier)
                                .updateSong(song);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Pallete.borderColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(song.thumbnail_url),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    song.song_name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Latest today",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(currentSongNotifierProvider.notifier)
                                .updateSong(song);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        songs[index].thumbnail_url,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Pallete.subtitleText,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
