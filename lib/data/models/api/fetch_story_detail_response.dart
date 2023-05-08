// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'story_obj_response.dart';

/// Object model for `GET /stories/:id` endpoint response from API.
class FetchStoryDetailResponse {
  final bool error;
  final String message;
  final StoryObjResponse story;

  const FetchStoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'story': story.toMap(),
    };
  }

  factory FetchStoryDetailResponse.fromMap(Map<String, dynamic> map) {
    return FetchStoryDetailResponse(
      error: map['error'] as bool,
      message: map['message'] as String,
      story: StoryObjResponse.fromMap(map['story'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchStoryDetailResponse.fromJson(String source) {
    return FetchStoryDetailResponse.fromMap(
      json.decode(source) as Map<String, dynamic>,
    );
  }
}
