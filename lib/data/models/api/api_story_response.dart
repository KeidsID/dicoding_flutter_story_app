/// The object model for the `Story` object in the API response
class ApiStoryResponse {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double lat;
  final double lon;

  const ApiStoryResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lat': lat,
      'lon': lon,
    };
  }

  factory ApiStoryResponse.fromMap(Map<String, dynamic> map) {
    return ApiStoryResponse(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      photoUrl: map['photoUrl'] as String,
      createdAt: map['createdAt'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }
}
