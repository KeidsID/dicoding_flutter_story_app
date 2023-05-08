import 'package:http/http.dart';

import '../models/api/fetch_stories_response.dart';
import '../models/api/login_response.dart';
import '../models/api/fetch_story_detail_response.dart';
import '../models/api/common_response.dart';

enum LocationQuery { one, zero }

/// Service to handle the Dicoding Story API.
class ApiService {
  final Client client;
  static ApiService? instance;

  factory ApiService(Client client) => instance ?? ApiService._init(client);

  ApiService._init(this.client) {
    instance = this;
  }

  static const _baseUrl = 'https://story-api.dicoding.dev/v1';

  /// `POST /register`
  ///
  /// Method to register as an app user.
  ///
  /// Will throw an [Exception] if an error occurs (such as invalid password).
  ///
  /// Request Body:
  /// - `name` as `String`
  /// - `email` as `String`, unique
  /// - `password` as `String`, min. 6 characters
  Future<CommonResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {}

  /// `POST /login`
  ///
  /// Method to login as a registered user.
  ///
  /// Will throw an [Exception] if an error occurs (such as invalid password).
  ///
  /// Request Body:
  /// - `email` as `String`
  /// - `password` as `String`
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {}

  /// `POST /stories`
  ///
  /// Methods for adding story to the API.
  ///
  /// Will throw an [Exception] if an error occurs.
  ///
  /// Headers:
  /// - `Content-Type`: `multipart/form-data`
  /// - `Authorization`: `Bearer <token>`
  ///
  /// Request Body:
  /// - `description` as `String`
  /// - `photo` as `Image File`, max size 1MB
  /// - `lat` as `double`, optional
  /// - `lon` as `double`, optional
  Future<CommonResponse> addStory({
    required String token,
    required String description,
    required List<int> photo,
    double? lat,
    double? lon,
  }) async {}

  /// `GET /stories`
  ///
  /// Method to fetch stories from the API.
  ///
  /// Will throw an [Exception] if an error occurs.
  ///
  /// Headers:
  /// - `Authorization`: `Bearer <token>`
  ///
  /// Queries:
  /// - `page` as `int`, optional
  /// - `size` as `int`, optional
  /// - `location` as `1 | 0`, optional, default 0
  ///   - Notes:
  ///     - 1 for get all stories with location
  ///     - 0 for all stories without considering location
  Future<FetchStoriesResponse> fetchStories({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  }) async {}

  /// `GET /stories/:id`
  ///
  /// Method to fetch the details of the requested story (based on the story id).
  ///
  /// Will throw an [Exception] if an error occurs.
  ///
  /// Headers:
  /// - `Authorization`: `Bearer <token>`
  Future<FetchStoryDetailResponse> fetchStoryDetail({
    required String token,
    required String id,
  }) async {}
}
