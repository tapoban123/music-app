import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repository/auth_local_repository.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

/// `ViewModel for Authentication`
/// 
/// Fetches data from [AuthRemoteRepository]
@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    return null;
  }

  /// Initialising [SharedPreferences] from [AuthLocalRepository]
  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  /// `Creating new user` in the database
  ///
  /// Calling API from [AuthRemoteRepository]
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _loginSuccess(r),
    };

    debugPrint(val.toString());
  }

  /// `Logging in user` in the database
  ///
  /// Calling API from [AuthRemoteRepository]
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _loginSuccess(r),
    };

    debugPrint(val.toString());
  }

  /// Creating token and saving in local storage using [AuthLocalRepository.setToken] for maintaining AuthStateChanges
  ///
  /// Also notifying [CurrentUserNotifier] to change app state from `logged out` to `logged in`
  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);

    return state = AsyncValue.data(user);
  }

  /// `Logging out user` by deleting auth_token from local storage using [AuthLocalRepository.deleteToken]
  void logOutUser() {
    _authLocalRepository.deleteToken();
  }

  /// `Fetches current user data` from database 
  /// 
  /// API called from [AuthRemoteRepository.getCurrentUserAuthData]
  Future<UserModel?> getAuthData() async {
    state = const AsyncValue.loading();

    final token = _authLocalRepository.getToken();

    if (token != null) {
      final result =
          await _authRemoteRepository.getCurrentUserAuthData(xAuthToken: token);

      final val = switch (result) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _getDataSuccess(r),
      };

      return val.value;
    }

    return null;
  }

  /// If AuthData fetched successfully: [CurrentUserNotifier] is updated with user data
  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
