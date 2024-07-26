import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

/// `Non-AutoDisposeProvider` for [AuthLocalRepository]
///
/// `keepAlive: true`
@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository();
}

/// Create local database on the user's device using [SharedPreferences]
class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  /// Initialise [SharedPreferences] for local storage
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Store X-auth-token in local storage for maintaining `userAuthState`
  void setToken(String? token) async {
    if (token != null) {
      await _sharedPreferences.setString("x-auth-token", token);
    }
  }

  /// `Fetch X-Auth-token` from local storage
  String? getToken() {
    return _sharedPreferences.getString("x-auth-token");
  }

  /// `Deletes X-auth-token` from storage
  /// 
  /// Sign out current user
  void deleteToken() async {
    await _sharedPreferences.remove("x-auth-token");
  }
}
