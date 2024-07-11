// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:client/features/home/models/favourite_song_model.dart';

class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;
  final List<FavouriteSongModel> favourites;

  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    required this.favourites,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
    List<FavouriteSongModel>? favourites,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
      favourites: favourites ?? this.favourites,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'token': token,
      'favourites': favourites.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      id: map['id'] ?? "",
      token: map['token'] ?? "",
      favourites: List<FavouriteSongModel>.from(
        (map['favourites'] ?? []).map(
          (x) => FavouriteSongModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, token: $token, favourites: $favourites)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.token == token &&
        listEquals(other.favourites, favourites);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        token.hashCode ^
        favourites.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
