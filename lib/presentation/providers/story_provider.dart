import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../domain/entities/story.dart';
import '../../domain/use_cases/get_stories.dart';
import '../../domain/use_cases/get_story_detail.dart';
import '../../domain/use_cases/post_story.dart';

enum StoryProviderState { loading, success, fail, init }

class StoryProvider extends ChangeNotifier {
  final GetStories getStories;
  final GetStoryDetail getStoryDetail;
  final PostStory postStory;

  StoryProvider({
    required this.getStories,
    required this.getStoryDetail,
    required this.postStory,
  });

  StoryProviderState _state = StoryProviderState.init;
  List<Story> _stories = [];
  Story? _story;

  StoryProviderState get state => _state;
  List<Story> get stories => _stories;
  Story? get story => _story;

  set _setState(StoryProviderState value) {
    _state = value;
    notifyListeners();
  }

  /// Fetch stories from the API, then update [state] and [stories] based on the
  /// result.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> fetchStories({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  }) async {
    _setState = StoryProviderState.loading;

    try {
      _stories = await getStories.execute(
        token: token,
        page: page,
        size: size,
        location: location,
      );

      _setState = StoryProviderState.success;
    } catch (e) {
      _setState = StoryProviderState.fail;
      rethrow;
    }
  }

  /// Fetch the details of the requested story (based on the story id), then
  /// update [state] and [story] based on the result.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> fetchStoryDetail({
    required String token,
    required String id,
  }) async {
    _setState = StoryProviderState.loading;

    try {
      _story = await getStoryDetail.execute(token: token, id: id);

      _setState = StoryProviderState.success;
    } catch (e) {
      _setState = StoryProviderState.fail;
      rethrow;
    }
  }

  /// Post story to the API, then call [fetchStories] after the register process
  /// is complete.
  ///
  /// Note that [fetchStories] only takes token parameters in this method.
  ///
  /// Will throw a [HttpResponseException] if an error occurs.
  Future<void> addStory({
    required String token,
    required String description,
    required List<int> photo,
    double? lat,
    double? lon,
  }) async {
    _setState = StoryProviderState.loading;

    await postStory.execute(
      token: token,
      description: description,
      photo: photo,
      lat: lat,
      lon: lon,
    );

    await fetchStories(token: token);
  }
}
