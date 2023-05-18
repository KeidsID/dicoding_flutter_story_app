import 'package:core/core.dart';
import 'package:http/http.dart';

import '../models/api/common_response.dart';
import '../models/api/fetch_stories_response.dart';
import '../models/api/fetch_story_detail_response.dart';
import '../models/api/login_response.dart';

enum LocationQuery { one, zero }

typedef ConfigsMap = Map<String, String>;

/// Service to handle the Dicoding Story API.
class ApiService {
  final Client client;

  const ApiService(this.client);

  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  /// `POST /register`
  ///
  /// Method to register as an app user.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from
  /// **the server**. Other [Exception] or [Error] may thrown.
  ///
  /// Request Body:
  /// - `name` as `String`
  /// - `email` as `String`, unique
  /// - `password` as `String`, min. 8 characters
  Future<CommonResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (password.length < 8) {
      throw HttpResponseException(400, message: 'Password too short');
    }

    final rawResponse = await client.post(
      Uri.parse('$baseUrl/register'),
      body: <String, String>{
        'name': name,
        'email': email,
        'password': password,
      },
    );

    final response = CommonResponse.fromJson(rawResponse.body);

    if (rawResponse.statusCode != 201) {
      throw HttpResponseException(
        rawResponse.statusCode,
        message: response.message,
      );
    }

    return response;
  }

  /// `POST /login`
  ///
  /// Method to login as a registered user.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from
  /// **the server**. Other [Exception] or [Error] may thrown.
  ///
  /// Request Body:
  /// - `email` as `String`
  /// - `password` as `String`
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final rawResponse = await client.post(
      Uri.parse('$baseUrl/login'),
      body: <String, String>{
        'email': email,
        'password': password,
      },
    );

    if (rawResponse.statusCode != 200) {
      throw HttpResponseException(
        rawResponse.statusCode,
        message: CommonResponse.fromJson(rawResponse.body).message,
      );
    }

    return LoginResponse.fromJson(rawResponse.body);
  }

  /// `POST /stories`
  ///
  /// Methods for adding story to the API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from
  /// **the server**. Other [Exception] or [Error] may thrown.
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
    required List<int> imageFileBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    final request = MultipartRequest('POST', Uri.parse('$baseUrl/stories'));

    final ConfigsMap headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };
    final ConfigsMap reqBodyFields = {'description': description};

    if (lat != null) reqBodyFields.addAll({'lat': '$lat'});
    if (lon != null) reqBodyFields.addAll({'lon': '$lon'});

    final photoFile = MultipartFile.fromBytes(
      'photo',
      imageFileBytes,
      filename: imageFilename,
    );

    request.headers.addAll(headers);
    request.fields.addAll(reqBodyFields);
    request.files.add(photoFile);

    final StreamedResponse responseStream = await client.send(request);
    final List<int> responseBodyBytes = await responseStream.stream.toBytes();

    final int statusCode = responseStream.statusCode;
    final String rawResponseBody = String.fromCharCodes(responseBodyBytes);

    final response = CommonResponse.fromJson(rawResponseBody);

    if (statusCode != 201) {
      throw HttpResponseException(statusCode, message: response.message);
    }

    return response;
  }

  /// `GET /stories`
  ///
  /// Method to fetch stories from the API.
  ///
  /// Will throw a [HttpResponseException] if an error occurs from
  /// **the server**. Other [Exception] or [Error] may thrown.
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
    final url = fetchStoriesUrlConfigs(
      page: page,
      size: size,
      location: location,
    );

    final headers = {'Authorization': 'Bearer $token'};

    final rawResponse = await client.get(url, headers: headers);

    if (rawResponse.statusCode != 200) {
      throw HttpResponseException(
        rawResponse.statusCode,
        message: CommonResponse.fromJson(rawResponse.body).message,
      );
    }

    return FetchStoriesResponse.fromJson(rawResponse.body);
  }

  static Uri fetchStoriesUrlConfigs({
    int? page,
    int? size,
    LocationQuery? location,
  }) {
    final ConfigsMap pageQuery = (page != null) ? {'page': '$page'} : {};
    final ConfigsMap sizeQuery = (size != null) ? {'size': '$size'} : {};
    final ConfigsMap locationQuery = (location != null)
        ? {'location': (location == LocationQuery.zero) ? '0' : '1'}
        : {};

    // Map<String, String?> still include the key on the URL
    final ConfigsMap queryParams = {
      ...pageQuery,
      ...sizeQuery,
      ...locationQuery,
    };

    final url = Uri.parse('$baseUrl/stories').replace(
      queryParameters: (queryParams.isEmpty) ? null : queryParams,
    );

    return url;
  }

  /// `GET /stories/:id`
  ///
  /// Method to fetch the details of the requested story (based on the story id).
  ///
  /// Will throw a [HttpResponseException] if an error occurs from
  /// **the server**. Other [Exception] or [Error] may thrown.
  ///
  /// Headers:
  /// - `Authorization`: `Bearer <token>`
  Future<FetchStoryDetailResponse> fetchStoryDetail({
    required String token,
    required String id,
  }) async {
    final url = Uri.parse('$baseUrl/stories/$id');
    final headers = {'Authorization': 'Bearer $token'};

    final rawResponse = await client.get(url, headers: headers);

    if (rawResponse.statusCode != 200) {
      throw HttpResponseException(
        rawResponse.statusCode,
        message: CommonResponse.fromJson(rawResponse.body).message,
      );
    }

    return FetchStoryDetailResponse.fromJson(rawResponse.body);
  }
}
