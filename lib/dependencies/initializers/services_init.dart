part of '../locator.dart';

Future<void> _servicesInit() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  locator.registerLazySingleton(() => ApiService(http.Client()));
  locator.registerLazySingleton(() => LoginInfoPreferences(sharedPreferences));
}
