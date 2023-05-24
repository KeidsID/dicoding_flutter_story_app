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

  /// On provider construct
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
  /// Will throw an [Exception] if an error occurs.
  Future<void> fetchStories({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  }) async {
    _setState = StoryProviderState.loading;

    try {
      _stories = await _getStories.execute(
        token: token,
        page: page,
        size: size,
        location: location,
      );

      _setState = StoryProviderState.success;
    } on HttpResponseException {
      _setState = StoryProviderState.serverFail;
      rethrow;
    } on SocketException {
      _setState = StoryProviderState.connectionFail;
      rethrow;
    }
  }

  /// Fetch the details of the requested story (based on the story id), then
  /// update [state] and [story] based on the result.
  ///
  /// Will throw an [Exception] if an error occurs.
  Future<void> fetchStoryDetail({
    required String token,
    required String id,
  }) async {
    _setState = StoryProviderState.loading;

    try {
      _story = await _getStoryDetail.execute(token: token, id: id);

      _setState = StoryProviderState.success;
    } on HttpResponseException {
      _setState = StoryProviderState.serverFail;
      rethrow;
    } on SocketException {
      _setState = StoryProviderState.connectionFail;
      rethrow;
    }
  }

  /// Post story to the API, then call [fetchStories] after the register process
  /// is complete.
  ///
  /// Note that [fetchStories] only takes token parameters in this method.
  ///
  /// Will throw an [Exception] if an error occurs.
  Future<void> postStory({
    required String token,
    required String description,
    required List<int> imageFileBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    _setState = StoryProviderState.loading;

    try {
      await _postStory.execute(
        token: token,
        description: description,
        imageFileBytes: imageFileBytes,
        imageFilename: imageFilename,
        lat: lat,
        lon: lon,
      );

      await fetchStories(token: token);
    } on HttpResponseException {
      _setState = StoryProviderState.serverFail;
      rethrow;
    } on SocketException {
      _setState = StoryProviderState.connectionFail;
      rethrow;
    }
  }
}
