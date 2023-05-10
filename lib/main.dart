import 'package:core/core.dart' as core;
import 'package:core/l10n/generated/core_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/auth_provider.dart';
import 'router/router.dart';
import 'service_locator/locator.dart' as service_locator;

void main() async {
  core.init(
    appName: 'Dicoding Story',
    appPrimaryColor: const Color(0xff2d3e50),
    useMaterial3: true,
  );

  await service_locator.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(
        value: service_locator.locator(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: core.appName,
      theme: core.AppThemes.light,
      darkTheme: core.AppThemes.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: CoreLocalizations.localizationsDelegates,
      supportedLocales: CoreLocalizations.supportedLocales,
    );
  }
}
