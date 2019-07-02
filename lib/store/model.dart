import 'dart:ui';

class CoverModel {
  final Uri uri;
  final Size size;

  CoverModel({
    String uri,
    double width,
    double height,
  }) : this.uri = Uri.parse(uri),
    this.size = Size(width, height);
}

class RunModel {
  final String id;
  final CoverModel cover;
  final String game;
  final String level;
  final String category;
  final String comment;
  final List<String> videos;

  RunModel({
    this.id,
    this.cover,
    this.game,
    this.level,
    this.category,
    this.comment,
    this.videos,
  });

  factory RunModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic> gameJson =
      json['game'] is Map<String, dynamic> &&
        json['game']['data'] is Map<String, dynamic>
          ? json['game']['data'] : null;
    final Map<String, dynamic> coverJson =
      gameJson != null ?
        gameJson['assets']['cover-small'] : null;
    final Map<String, dynamic> levelJson =
      json['level'] is Map<String, dynamic> &&
        json['level']['data'] is Map<String, dynamic>
          ? json['level']['data'] : null;
    final Map<String, dynamic> categoryJson =
      json['category'] is Map<String, dynamic> &&
        json['category']['data'] is Map<String, dynamic>
          ? json['category']['data'] : null;
    final List<dynamic> videosJson =
      json['videos'] is Map<String, dynamic> &&
        json['videos']['links'] is List<dynamic>
          ? json['videos']['links'] : [];

    final String id = json['id'];
    final String coverUri = coverJson != null ? coverJson['uri'] : null;
    final int coverWidth = coverJson != null ? coverJson['width'] : null;
    final int coverHeight = coverJson != null ? coverJson['height'] : null;
    final String game = gameJson != null ? gameJson['names']['international'] : null;
    final String level = levelJson != null ? levelJson['name'] : null;
    final String category = categoryJson != null ? categoryJson['name'] : null;
    final String comment = json['comment'];
    final List<String> videos = videosJson.map((videoJson) => videoJson['uri'] as String).toList(growable: false);

    final CoverModel cover = coverUri != null
      ? CoverModel(
        uri: coverUri,
        width: coverWidth != null ? coverWidth.toDouble() : double.infinity,
        height: coverHeight != null ? coverHeight.toDouble() : double.infinity,
      ) : null;
    return RunModel(
      id: id,
      cover: cover,
      game: game,
      level: level,
      category: category,
      comment: comment,
      videos: videos,
    );
  }
}
