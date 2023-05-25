import 'package:core/core.dart';

import '../../domain/entities/login_info.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../api/api_service.dart';
import '../cache/login_info_preferences.dart';
import '../models/cache/login_info_model.dart';

class StoryRepositoryImpl implements StoryRepository {
  final ApiService apiService;
  final LoginInfoPreferences loginTokenPreferences;

  const StoryRepositoryImpl({
    required this.apiService,
    required this.loginTokenPreferences,
  });

  @override
  Future<LoginInfo?> getLoginInfo() async {
    try {
      final loginInfoModel = await loginTokenPreferences.getLoginInfo();

      return (loginInfoModel != null) ? loginInfoModel.toEntity() : null;
    } catch (e) {
      throw HttpResponseException(
        500,
        message: 'Failed to fetch login info in the cache',
      );
    }
  }

  @override
  Future<void> doLogin({
    required String email,
    required String password,
  }) async {
    final response = await apiService.login(
      email: email,
      password: password,
    );

    final token = response.loginResult.token;
    final username = response.loginResult.name;
    final isCached = await loginTokenPreferences.saveLoginInfo(LoginInfoModel(
      name: username,
      token: token,
    ));

    if (!isCached) {
      throw HttpResponseException(
        500,
        message: 'Login info is not cached. Please re-login',
      );
    }
  }

  @override
  Future<void> doLogout() async {
    final isSuccess = await loginTokenPreferences.removeLoginInfo();

    if (!isSuccess) {
      throw throw HttpResponseException(
        500,
        message: 'Login info is not removed. Please re-logout',
      );
    }
  }

  @override
  Future<void> doRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    await apiService.register(name: name, email: email, password: password);
  }

  @override
  Future<List<Story>> getStories({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  }) async {
    final response = await apiService.fetchStories(
      token: token,
      page: page,
      size: size,
      location: location,
    );

    return response.listStory.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Story> getStoryDetail({
    required String token,
    required String id,
  }) async {
    final response = await apiService.fetchStoryDetail(token: token, id: id);

    return response.story.toEntity();
  }

  @override
  Future<void> postStory({
    required String token,
    required String description,
    required List<int> imageFileBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    await apiService.postStory(
      token: token,
      description: description,
      imageFileBytes: imageFileBytes,
      imageFilename: imageFilename,
      lat: lat,
      lon: lon,
    );
  }
}
