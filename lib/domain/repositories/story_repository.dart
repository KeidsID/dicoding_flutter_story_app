import '../../data/api/api_service.dart';
import '../entities/login_info.dart';
import '../entities/story.dart';

abstract class StoryRepository {
  Future<void> doLogin({
    required String email,
    required String password,
  });

  Future<void> doLogout();

  Future<void> doRegister({
    required String name,
    required String email,
    required String password,
  });

  Future<LoginInfo?> getLoginInfo();

  Future<List<Story>> getStories({
    required String token,
    int? page,
    int? size,
    LocationQuery? location,
  });

  Future<Story> getStoryDetail({
    required String token,
    required String id,
  });

  Future<void> postStory({
    required String token,
    required String description,
    required List<int> photo,
    double? lat,
    double? lon,
  });
}
