import 'package:core/core.dart' as core;
import 'package:core/l10n/generated/core_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/api_service.dart';
import 'data/cache/login_token_preferences.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  core.init(
    appName: 'Dicoding Story',
    appPrimaryColor: const Color(0xff2d3e50),
    useMaterial3: true,
  );

  ApiService(http.Client());

  final pref = await SharedPreferences.getInstance();

  LoginTokenPreferences(pref);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: core.appName,
      theme: core.AppThemes.light,
      darkTheme: core.AppThemes.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: CoreLocalizations.localizationsDelegates,
      supportedLocales: CoreLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
