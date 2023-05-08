import 'package:core/core.dart' as core;
import 'package:core/l10n/generated/core_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  core.init(
    appName: 'Dicoding Story',
    appPrimaryColor: const Color(0xff2d3e50),
    useMaterial3: true,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: core.AppThemes.light,
      darkTheme: core.AppThemes.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: CoreLocalizations.localizationsDelegates,
      supportedLocales: CoreLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
