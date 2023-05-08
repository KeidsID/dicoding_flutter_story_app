import 'dart:convert';

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
  /// Will throw an [Exception] if an error occurs.
  ///
  /// Request Body:
  /// - `name` as `String`
  /// - `email` as `String`, unique
  /// - `password` as `String`, min. 6 characters
  Future<CommonResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (password.length < 6) throw Exception('Password too short');

    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/register'),
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 201) throw Exception('Failed to register');

      return CommonResponse.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to register');
    }
  }

  /// `POST /login`
  ///
  /// Method to login as a registered user.
  ///
  /// Will throw an [Exception] if an error occurs.
  ///
  /// Request Body:
  /// - `email` as `String`
  /// - `password` as `String`
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/register'),
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 201) throw Exception('Failed to login');

      return LoginResponse.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

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
  Future<CommonResponse> postStory({
    required String token,
    required String description,
    required List<int> photo,
    double? lat,
    double? lon,
  }) async {
    final request = MultipartRequest('POST', Uri.parse('$_baseUrl/stories'));

    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };
    final Map<String, String> reqBodyFields = {'description': description};

    if (lat != null) reqBodyFields.addAll({'lat': '$lat'});
    if (lon != null) reqBodyFields.addAll({'lon': '$lon'});

    final photoFile = MultipartFile.fromBytes('photo', photo);

    request.headers.addAll(headers);
    request.fields.addAll(reqBodyFields);
    request.files.add(photoFile);

    try {
      final StreamedResponse responseStream = await client.send(request);
      final int statusCode = responseStream.statusCode;

      if (statusCode != 201) throw Exception('Failed to post your story');

      final List<int> responseBodyBytes = await responseStream.stream.toBytes();
      final String responseBody = String.fromCharCodes(responseBodyBytes);

      return CommonResponse.fromJson(responseBody);
    } catch (e) {
      throw Exception('Failed to post your story');
    }
  }

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
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'size': size,
      'location': (location == null)
          ? location
          : (location == LocationQuery.one)
              ? '1'
              : '0',
    };
    final url = Uri.parse('$_baseUrl/stories').replace(
      queryParameters: queryParams,
    );

    try {
      final response = await client.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch stories');
      }

      return FetchStoriesResponse.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to fetch stories');
    }
  }

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
  }) async {
    final url = Uri.parse('$_baseUrl/stories/$id');

    try {
      final response = await client.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch story detail');
      }

      return FetchStoryDetailResponse.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to fetch story detail');
    }
  }
}
