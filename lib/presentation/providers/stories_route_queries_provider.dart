import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/story_detail_page.dart';

/// Use only on widgets (Not on the router).
///
/// Use on [HomePage] to set the values, and use it on [StoryDetailPage] to get
/// the values. It is recommended not to listen/watch this provider as both
/// pages are frequently rebuilt by the router.
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
