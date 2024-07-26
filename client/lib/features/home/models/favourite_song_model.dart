// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class FavouriteSongModel {
  final String id;
  final String song_id;
  final String user_id;
  FavouriteSongModel({
    required this.id,
    required this.song_id,
    required this.user_id,
  });

  FavouriteSongModel copyWith({
    String? id,
    String? song_id,
    String? user_id,
  }) {
    return FavouriteSongModel(
      id: id ?? this.id,
      song_id: song_id ?? this.song_id,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_id': song_id,
      'user_id': user_id,
    };
  }

  factory FavouriteSongModel.fromMap(Map<String, dynamic> map) {
    return FavouriteSongModel(
      id: map['id'] as String,
      song_id: map['song_id'] as String,
      user_id: map['user_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteSongModel.fromJson(String source) =>
      FavouriteSongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FavouriteSongModel(id: $id, song_id: $song_id, user_id: $user_id)';

  @override
  bool operator ==(covariant FavouriteSongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_id == song_id &&
        other.user_id == user_id;
  }

  @override
  int get hashCode => id.hashCode ^ song_id.hashCode ^ user_id.hashCode;
}
