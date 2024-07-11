import 'dart:convert';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  // Either<Failure_Dtype, Success_Dtype>
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverURL}/auth/signup'),
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "password": password,
          },
        ),
      );

      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        return Left(AppFailure(message: responseBodyMap['detail']));
      }

      // We need to return Right in case of success.
      return Right(
        UserModel.fromMap(responseBodyMap["user"]).copyWith(
          token: responseBodyMap["token"],
        ),
      );
    } catch (e) {
      // We need to return Left in case of failure.
      return Left(AppFailure(message: e.toString()));
    }
    // We are returning Right and Left because we are using Either return type
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverURL}/auth/login"),
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      final responseBodyMap = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Left(AppFailure(message: responseBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(responseBodyMap["user"]).copyWith(
          token: responseBodyMap["token"],
        ),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData({
    required String xAuthToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.serverURL}/auth/"),
        headers: {
          "content-type": "application/json",
          "x-auth-token": xAuthToken,
        },
      );

      final responseBodyMap = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Left(AppFailure(message: responseBodyMap['detail']));
      }

      return Right(
        UserModel.fromMap(responseBodyMap).copyWith(token: xAuthToken),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
