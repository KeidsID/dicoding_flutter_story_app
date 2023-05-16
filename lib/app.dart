import 'package:core/core.dart';
import 'package:core/l10n/generated/core_localizations.dart';
import 'package:flutter/material.dart';

import 'router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: CoreLocalizations.localizationsDelegates,
      supportedLocales: CoreLocalizations.supportedLocales,
    );
  }
}
