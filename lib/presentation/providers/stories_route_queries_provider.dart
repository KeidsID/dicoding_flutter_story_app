import 'package:flutter/material.dart';

import '../pages/home_page.dart';

/// Provides queries from [HomePage] route.
///
/// Use only on widgets (Not on the router).
class StoriesRouteQueriesProvider extends ChangeNotifier {
  StoriesRouteQueriesProvider();

  int _page = 1;
  int _size = 10;

  int get page => _page;
  set page(int value) {
    _page = value;
    notifyListeners();
  }

  int get size => _size;
  set size(int value) {
    _size = value;
    notifyListeners();
  }
}
