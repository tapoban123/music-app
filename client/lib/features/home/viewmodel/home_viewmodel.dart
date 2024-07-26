import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/favourite_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final response = await ref.watch(homeRepositoryProvider).getAllSongs(
        token: token,
      );

  return switch (response) {
    Left(value: final l) => throw l.toString(),
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavouriteSongs(GetFavouriteSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final response = await ref.watch(homeRepositoryProvider).getFavouriteSongs(
        token: token,
      );

  return switch (response) {
    Left(value: final l) => throw l.toString(),
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required String artistName,
    required String songName,
    required Color selectedColor,
    required File songFile,
    required File thumbnailFile,
  }) async {
    state = const AsyncValue.loading();
    final response = await _homeRepository.uploadSong(
      artistName: artistName,
      songName: songName,
      hexColorCode: rgbToHex(selectedColor),
      xAuthToken: ref.read(currentUserNotifierProvider)!.token,
      songFile: songFile,
      thumbnailFile: thumbnailFile,
    );

    final val = switch (response) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    debugPrint(val.toString());
  }

  Future<void> favouriteSong({
    required String songId,
  }) async {
    state = const AsyncValue.loading();
    final response = await _homeRepository.favouriteSong(
      token: ref.read(currentUserNotifierProvider)!.token,
      songId: songId,
    );

    final val = switch (response) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _favSongSuccess(r, songId),
    };

    debugPrint(val.toString());
  }

  _favSongSuccess(bool isFavourited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);

    if (isFavourited) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favourites: [
            ...ref.read(currentUserNotifierProvider)!.favourites,
            FavouriteSongModel(
              id: '',
              song_id: songId,
              user_id: "",
            ),
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
              favourites: ref
                  .read(currentUserNotifierProvider)!
                  .favourites
                  .where(
                    (favSong) => favSong.song_id != songId,
                  )
                  .toList(),
            ),
      );
    }
    ref.invalidate(getFavouriteSongsProvider);
    return state = AsyncValue.data(isFavourited);
  }

  List<SongModel> getRecentlyPlayedSong() {
    return _homeLocalRepository.loadSongs();
  }
}
