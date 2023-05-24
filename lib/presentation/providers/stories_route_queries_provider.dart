import 'package:flutter/material.dart';

/// Provide queries for the "/stories" route.
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
