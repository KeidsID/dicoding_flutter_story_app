import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../domain/entities/story.dart';
import '../../domain/use_cases/get_stories.dart';
import '../../domain/use_cases/get_story_detail.dart';
import '../../domain/use_cases/post_story.dart';

enum StoryProviderState {
  /// Asynchronous process running.
  loading,
  success,

  /// On construct provider to make sure state not null.
  init,

  /// On [HttpResponseException] thrown.
  serverFail,

  /// On [SocketException] thrown.
  connectionFail,
}

class StoryProvider extends ChangeNotifier {
  final GetStories _getStories;
  final GetStoryDetail _getStoryDetail;
  final PostStory _postStory;

  StoryProvider({
    required GetStories getStories,
    required GetStoryDetail getStoryDetail,
    required PostStory postStory,
  })  : _postStory = postStory,
        _getStoryDetail = getStoryDetail,
        _getStories = getStories;

  StoryProviderState _storiesState = StoryProviderState.init;
  StoryProviderState _storyState = StoryProviderState.init;
  StoryProviderState _postStoryState = StoryProviderState.init;

  List<Story> _stories = [];
  Story? _story;

  /// Get state for [stories] process.
  StoryProviderState get storiesState => _storiesState;

  /// Get state for [story] process.
  StoryProviderState get storyState => _storyState;

  /// Get state for [postStory] process.
  StoryProviderState get postStoryState => _postStoryState;
  set postStoryState(StoryProviderState value) {
    _postStoryState = value;
    notifyListeners();
  }

  List<Story> get stories => _stories;
  Story? get story => _story;

  void _setStoriesState(StoryProviderState value) {
    _storiesState = value;
    notifyListeners();
  }

  void _setStoryState(StoryProviderState value) {
    _storyState = value;
    notifyListeners();
  }

  /// Fetch stories from the API, then update [storiesState] and [stories] based on the
  /// result.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server,
  /// otherwise it will throw another [Exception] (such as [SocketException]) if
  /// an internal error occurs.
  Future<void> fetchStories({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  }) async {
    _setStoriesState(StoryProviderState.loading);

    try {
      _stories = await _getStories.execute(
        token: token,
        page: page,
        size: size,
        location: location,
      );

      _setStoriesState(StoryProviderState.success);
    } on HttpResponseException {
      _setStoriesState(StoryProviderState.serverFail);
      rethrow;
    } catch (e) {
      _setStoriesState(StoryProviderState.connectionFail);
      rethrow;
    }
  }

  /// Fetch the details of the requested story (based on the story id), then
  /// update [storyState] and [story] based on the result.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server,
  /// otherwise it will throw another [Exception] (such as [SocketException]) if
  /// an internal error occurs.
  Future<void> fetchStoryDetail({
    required String token,
    required String id,
  }) async {
    _setStoryState(StoryProviderState.loading);

    try {
      _story = await _getStoryDetail.execute(token: token, id: id);

      _setStoryState(StoryProviderState.success);
    } on HttpResponseException {
      _setStoryState(StoryProviderState.serverFail);
      rethrow;
    } catch (e) {
      _setStoryState(StoryProviderState.connectionFail);
      rethrow;
    }
  }

  /// Post story to the API, then call [fetchStories] after the register process
  /// is complete. Also update [postStoryState] based on the result.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from the server,
  /// otherwise it will throw another [Exception] (such as [SocketException]) if
  /// an internal error occurs.
  Future<void> postStory({
    required String token,
    required String description,
    required List<int> imageFileBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    postStoryState = StoryProviderState.loading;

    try {
      await _postStory.execute(
        token: token,
        description: description,
        imageFileBytes: imageFileBytes,
        imageFilename: imageFilename,
        lat: lat,
        lon: lon,
      );
      postStoryState = StoryProviderState.success;
    } on HttpResponseException {
      postStoryState = StoryProviderState.serverFail;
      rethrow;
    } catch (e) {
      postStoryState = StoryProviderState.connectionFail;
      rethrow;
    }

    await fetchStories(token: token);
  }
}
