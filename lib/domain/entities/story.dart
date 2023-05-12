class Story {
  const Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  /// Story unique identifier.
  final String id;

  /// The name of the person who posted the story.
  final String name;

  /// The description of the story
  final String description;

  /// The URL of the photo attached by the story owner.
  final String photoUrl;

  /// Date and time this story was posted.
  final DateTime createdAt;

  /// [lat] (Latitude) is a unit used for geographic coordinate.
  final double? lat;

  /// [lon] (Longitude) is a unit used for geographic coordinate.
  final double? lon;
}
