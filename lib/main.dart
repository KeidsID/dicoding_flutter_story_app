import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'dependencies/locator.dart' as dependencies;
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/stories_route_queries_provider.dart';
import 'presentation/providers/story_provider.dart';
import 'router/utils/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  core.init(
    appName: 'Dicoding Story',
    appPrimaryColor: const Color(0xff2d3e50),
    useMaterial3: true,
  );

  await dependencies.init();

  usePathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(
        value: dependencies.locator(),
      ),
      ChangeNotifierProvider<StoryProvider>.value(
        value: dependencies.locator(),
      ),
      ChangeNotifierProvider<StoriesRouteQueriesProvider>.value(
        value: dependencies.locator(),
      ),
    ],
    child: const App(),
  ));
}
