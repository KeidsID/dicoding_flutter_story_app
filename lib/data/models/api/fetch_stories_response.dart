import 'dart:convert';

import 'api_story_response.dart';

/// Object model for `GET /stories` endpoint response from API.
class FetchStoriesResponse {
  final bool error;
  final String message;
  final List<ApiStoryResponse> listStory;

  const FetchStoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'listStory': listStory.map((x) => x.toMap()).toList(),
    };
  }

  factory FetchStoriesResponse.fromMap(Map<String, dynamic> map) {
    return FetchStoriesResponse(
      error: map['error'] as bool,
      message: map['message'] as String,
      listStory: List<ApiStoryResponse>.from(
        (map['listStory'] as List).map<ApiStoryResponse>(
          (x) => ApiStoryResponse.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchStoriesResponse.fromJson(String source) {
    return FetchStoriesResponse.fromMap(
      json.decode(source) as Map<String, dynamic>,
    );
  }
}
