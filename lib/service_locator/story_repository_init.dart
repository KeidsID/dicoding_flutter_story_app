part of 'locator.dart';

void _storyRepositoryInit() {
  locator.registerLazySingleton<StoryRepository>(() {
    return StoryRepositoryImpl(
      apiService: locator(),
      loginTokenPreferences: locator(),
    );
  });

  locator.registerLazySingleton(() => DoLogin(locator()));
  locator.registerLazySingleton(() => DoLogout(locator()));
  locator.registerLazySingleton(() => DoRegister(locator()));
  locator.registerLazySingleton(() => GetLoginToken(locator()));
}
