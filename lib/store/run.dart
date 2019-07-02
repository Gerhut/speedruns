class Run {
  const Run({
    this.id,
    this.cover,
    this.game,
    this.level,
    this.category,
    this.comment,
    this.videos,
  });

  Run.fromRaw(dynamic raw) : id = raw['id'],
    cover = raw['game']['data']['assets']['cover-large']['uri'],
    game = raw['game']['data']['names']['international'],
    level = raw['level'] != null
      ? raw['level']['data']['name']
      : null,
    category = raw['category'] != null
      ? raw['category']['data']['name']
      : null,
    comment = raw['comment'],
    videos = raw['videos'] != null
      ? raw['videos']['links'].map((rawVideo) => rawVideo['uri'])
      : [];

  final String id;
  final String cover;
  final String game;
  final String level;
  final String category;
  final String comment;
  final List<String> videos;
}
