import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required String artistName,
    required String songName,
    required String hexColorCode,
    required String xAuthToken,
    required File songFile,
    required File thumbnailFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ServerConstants.serverURL}/song/upload"),
      );
      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath("song", songFile.path),
            await http.MultipartFile.fromPath("thumbnail", thumbnailFile.path),
          ],
        )
        ..fields.addAll(
          {
            "artist": artistName,
            "song_name": songName,
            "hex_code": hexColorCode,
          },
        )
        ..headers.addAll(
          {"x-auth-token": xAuthToken},
        );

      final response = await request.send();

      if (response.statusCode != 201) {
        return Left(AppFailure(message: await response.stream.bytesToString()));
      }

      return Right(await response.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverURL}/song/list"),
        headers: {
          "Content-type": "application/json",
          "x-auth-token": token,
        },
      );

      var responseBodyMap = jsonDecode(response.body);

      if (response.statusCode != 200) {
        responseBodyMap = responseBodyMap as Map<String, dynamic>;
        return Left(AppFailure(message: responseBodyMap["detail"]));
      }

      responseBodyMap = responseBodyMap as List;

      List<SongModel> songs = [];
      for (final map in responseBodyMap) {
        final songData = SongModel.fromMap(map);
        songs.add(songData);
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
