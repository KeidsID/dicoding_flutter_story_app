import 'package:dicoding_flutter_story_app/domain/entities/story.dart';

/// The object model for the `Story` object in the API response
class StoryObjResponse {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  const StoryObjResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  Story toEntity() {
    return Story(
      id: id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lat: lat,
      lon: lon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lat': lat,
      'lon': lon,
    };
  }

  factory StoryObjResponse.fromMap(Map<String, dynamic> map) {
    return StoryObjResponse(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      photoUrl: map['photoUrl'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lat: double.tryParse('${map['lat']}'),
      lon: double.tryParse('${map['lon']}'),
    );
  }
}
