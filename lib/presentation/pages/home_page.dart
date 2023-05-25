import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/login_info.dart';
import '../../router/app_route_paths.dart';
import '../providers/auth_provider.dart';
import '../providers/cameras_provider.dart';
import '../providers/stories_route_queries_provider.dart';
import '../providers/story_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../widgets/app_alert_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/story_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.page,
    this.size,
  });

  /// The current page of stories.
  ///
  /// Provided by router web (route builder).
  final int? page;

  /// Number of stories to load on each page.
  ///
  /// Provided by router web (route builder).
  final int? size;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthProvider unListenAuthProv;

  @override
  void initState() {
    super.initState();

    unListenAuthProv = context.read();

    Future.microtask(() async {
      final token = unListenAuthProv.loginInfo!.token;

      final queriesProvider = context.read<StoriesRouteQueriesProvider>();

      try {
        await context
            .read<StoryProvider>()
            .fetchStories(token: token, page: widget.page, size: widget.size);

        queriesProvider.page = widget.page ?? 1;
        queriesProvider.size = widget.size ?? 10;
      } on HttpResponseException catch (e) {
        debugPrint('$e - ${e.message}');
      } catch (e) {
        debugPrint('$e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = unListenAuthProv.loginInfo;

    if (loginInfo == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        final isOneColumnGrid = constraint.maxWidth <= 600.0;
        final isThreeColumnGrid = constraint.maxWidth >= 900.0;

        return Scaffold(
          appBar: AppBar(title: Text(appName), centerTitle: !isOneColumnGrid),
          drawer: _PageDrawer(unListenAuthProv),
          body: _PageBody(
            loginInfo,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isOneColumnGrid
                  ? 1
                  : isThreeColumnGrid
                      ? 3
                      : 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 3 / 4,
            ),
            padding: const EdgeInsets.all(16.0),
            maxWidth: isOneColumnGrid
                ? 300.0
                : isThreeColumnGrid
                    ? 900.0
                    : 600.0,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () => navToPostStory(),
              icon: const Icon(Icons.add),
              label: const Text('Post Story'),
            ),
          ),
        );
      },
    );
  }

  Future<void> navToPostStory() async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;
    final navigateTo = context.go;

    final camerasProvider = context.read<CamerasProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) {
      showSnackBar(const SnackBar(
        content: Text(
          'This feature is not available on this device',
        ),
      ));
      return;
    }

    await camerasProvider.fetchCameras();

    navigateTo(AppRoutePaths.camera);
  }
}

class _PageDrawer extends StatelessWidget {
  const _PageDrawer(this.unListenAuthProv);

  final AuthProvider unListenAuthProv;

  @override
  Widget build(BuildContext context) {
    final loginInfo = unListenAuthProv.loginInfo!;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(children: [
              const SizedBox(height: 16.0),
              CircleAvatar(
                maxRadius: 30.0,
                child: Text(
                  loginInfo.name[0],
                  style: context.textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('Welcome back ${loginInfo.name}'),
            ]),
          ),
          Builder(
            builder: (context) => ListTile(
              leading: Icon(
                context.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
              ),
              title: const Text('App theme'),
              trailing: Consumer<ThemeModeProvider>(
                builder: (context, themeModeProv, _) {
                  return DropdownButton<ThemeMode>(
                    value: themeModeProv.themeMode,
                    items: ThemeMode.values.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if (value == null) return;

                      await themeModeProv.setThemeMode(value);
                    },
                  );
                },
              ),
            ),
          ),
          ListTile(
            onTap: () => logout(context),
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
          ),
          ListTile(
            onTap: () => aboutAppDialog(context),
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About app'),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;

    try {
      await unListenAuthProv.logout();
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(e.message ?? '${e.statusCode}: ${e.name}'),
      ));
    }
  }

  Future<void> aboutAppDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final applicationName = packageInfo.appName;
    final appVersion = packageInfo.version;

    void showAppAboutDialog() {
      showAboutDialog(
        context: context,
        applicationName: applicationName,
        applicationIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Image.asset(
            'assets/app-icon.png',
            width: 60,
            height: 60,
          ),
        ),
        applicationLegalese:
            'Projects from dicoding.com as a practice in advanced navigation, and use of media (audio, images, and video).',
        applicationVersion: 'v$appVersion',
      );
    }

    showAppAboutDialog();
  }
}

enum _StoriesPageNavigateTo { nextPage, previousPage, homePage }

class _PageBody extends StatelessWidget {
  const _PageBody(
    this.loginInfo, {
    required this.gridDelegate,
    this.padding,
    this.maxWidth,
  });

  final LoginInfo loginInfo;

  /// A delegate that controls the layout of the children within the [GridView].
  final SliverGridDelegate gridDelegate;

  /// [GridView] padding.
  final EdgeInsetsGeometry? padding;

  /// [GridView] max width.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoryProvider, StoriesRouteQueriesProvider>(
      builder: (context, storyProv, storiesRouteQueries, child) {
        final state = storyProv.storiesState;
        final isConnectionFail = state == StoryProviderState.connectionFail;
        final isFail = state == StoryProviderState.serverFail;
        final isInit = state == StoryProviderState.init;
        final isLoading = state == StoryProviderState.loading;

        final stories = storyProv.stories;

        if (isLoading || isInit) return child!;

        if (stories.isEmpty || isFail || isConnectionFail) {
          return Center(
            child: AppAlertDialog(
              content: Text(
                (isFail)
                    ? 'Fail to fetch stories'
                    : (isConnectionFail)
                        ? 'No internet connection'
                        : 'No Data',
              ),
              isDefaultActionIncluded: false,
              actions: [
                TextButton(
                  onPressed: () => refreshStories(context),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final currentPage = storiesRouteQueries.page;
        final isStoriesFirstPage = currentPage == 1;
        final isStoriesSecondPage = currentPage == 2;

        final gridItemCount = isStoriesFirstPage
            ? stories.length + 1
            : isStoriesSecondPage
                ? stories.length + 2
                : stories.length + 3;

        return SizedBox.expand(
          child: Center(
            child: SizedBox(
              width: maxWidth,
              height: context.screenSize.height,
              child: GridView.builder(
                gridDelegate: gridDelegate,
                itemCount: gridItemCount,
                padding: padding,
                itemBuilder: (context, index) {
                  final homePageCardConditions =
                      !isStoriesFirstPage && !isStoriesSecondPage && index == 0;

                  final previousPageCardConditions = !isStoriesFirstPage &&
                      ((isStoriesSecondPage) ? index == 0 : index == 1);

                  final nextPageCardConditions = index == gridItemCount - 1;

                  if (homePageCardConditions) {
                    return CustomCard(
                      onTap: () => storiesPageNavigator(
                        context,
                        navigateTo: _StoriesPageNavigateTo.homePage,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Back to home',
                              style: context.textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            const Icon(Icons.home_rounded, size: 40.0),
                          ],
                        ),
                      ),
                    );
                  }

                  if (previousPageCardConditions) {
                    return CustomCard(
                      onTap: () => storiesPageNavigator(
                        context,
                        navigateTo: _StoriesPageNavigateTo.previousPage,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Previous page',
                              style: context.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8.0),
                            const Icon(Icons.arrow_back_rounded, size: 40.0),
                          ],
                        ),
                      ),
                    );
                  }

                  if (nextPageCardConditions) {
                    return CustomCard(
                      onTap: () => storiesPageNavigator(
                        context,
                        navigateTo: _StoriesPageNavigateTo.nextPage,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next page',
                              style: context.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8.0),
                            const Icon(Icons.arrow_forward_rounded, size: 40.0),
                          ],
                        ),
                      ),
                    );
                  }

                  final storyFilteredIndex = (isStoriesFirstPage)
                      ? index
                      : (isStoriesSecondPage)
                          ? index - 1
                          : index - 2;
                  final story = stories[storyFilteredIndex];

                  return StoryCard(
                    story,
                    onTap: () => navToStoryDetailPage(context, story.id),
                  );
                },
              ),
            ),
          ),
        );
      },
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> refreshStories(BuildContext context) async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;

    final storyProv = context.read<StoryProvider>();
    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();

    try {
      await storyProv.fetchStories(
        token: loginInfo.token,
        page: storiesRouteQueries.page,
        size: storiesRouteQueries.size,
      );
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(
          e.message ?? '${e.statusCode}: ${e.name}',
        ),
      ));
    } catch (e) {
      showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }

  void navToStoryDetailPage(BuildContext context, String storyId) {
    context.go(AppRoutePaths.storyDetail(storyId));
  }

  Future<void> storiesPageNavigator(
    BuildContext context, {
    required _StoriesPageNavigateTo navigateTo,
  }) async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;

    final storyProv = context.read<StoryProvider>();
    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();

    final targetPage = (navigateTo == _StoriesPageNavigateTo.nextPage)
        ? storiesRouteQueries.page + 1
        : (navigateTo == _StoriesPageNavigateTo.previousPage)
            ? storiesRouteQueries.page - 1
            : 1;

    // Only update route info
    context.go(AppRoutePaths.stories(
      page: targetPage,
    ));

    // load new content and store the page state into
    // provider.
    storiesRouteQueries.page = targetPage;

    try {
      await storyProv.fetchStories(token: loginInfo.token, page: targetPage);
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(
          e.message ?? '${e.statusCode}: ${e.name}',
        ),
      ));
    } catch (e) {
      showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }
}
