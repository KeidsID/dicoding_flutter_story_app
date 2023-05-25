part of '../locator.dart';

void _providerInit() {
  locator.registerLazySingleton(() {
    return AuthProvider(
      doLogin: locator(),
      doLogout: locator(),
      doRegister: locator(),
      getLoginToken: locator(),
    );
  });

  locator.registerFactory(() {
    return ThemeModeProvider(
      themeModePreferences: locator(),
    );
  });

  locator.registerFactory(() => CamerasProvider());
  locator.registerFactory(() => PickedImageProvider());
  locator.registerFactory(() => StoriesRouteQueriesProvider());

  locator.registerFactory(() {
    return StoryProvider(
      getStories: locator(),
      getStoryDetail: locator(),
      postStory: locator(),
    );
  });
}
