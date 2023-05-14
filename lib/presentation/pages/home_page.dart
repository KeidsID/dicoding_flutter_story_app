import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/login_info.dart';
import '../../router/app_route_paths.dart';
import '../providers/auth_provider.dart';
import '../providers/story_provider.dart';
import '../widgets/stories_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.page, this.size});

  /// The current page of stories.
  final int? page;

  /// Number of stories to load on each page.
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

      try {
        await context
            .read<StoryProvider>()
            .fetchStories(token: token, page: widget.page, size: widget.size);
      } on HttpResponseException catch (e) {
        debugPrint('$e ${e.message}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Won't null because the auth state is loggedIn
    final loginInfo = unListenAuthProv.loginInfo!;

    return LayoutBuilder(
      builder: (context, constraint) {
        final isOneColumnGrid = constraint.maxWidth <= 600.0;
        final isThreeColumnGrid = constraint.maxWidth >= 900.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(appName),
            centerTitle: !isOneColumnGrid,
          ),
          drawer: _PageDrawer(unListenAuthProv),
          body: _PageBody(
            loginInfo,
            page: widget.page,
            size: widget.size,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isOneColumnGrid
                  ? 1
                  : isThreeColumnGrid
                      ? 3
                      : 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 1,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            maxWidth: isOneColumnGrid
                ? 300.0
                : isThreeColumnGrid
                    ? 900.0
                    : 600.0,
          ),
        );
      },
    );
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
          ListTile(
            onTap: () async {
              final showSnackBar = context.scaffoldMessenger.showSnackBar;

              try {
                await unListenAuthProv.logout();
              } on HttpResponseException catch (e) {
                showSnackBar(SnackBar(
                  content: Text(e.message ?? '${e.statusCode}: ${e.name}'),
                ));
              }
            },
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody(
    this.loginInfo, {
    this.page,
    this.size,
    required this.gridDelegate,
    this.padding,
    this.maxWidth,
  });

  final LoginInfo loginInfo;
  final int? page;
  final int? size;

  /// A delegate that controls the layout of the children within the [GridView].
  final SliverGridDelegate gridDelegate;

  /// [GridView] padding.
  final EdgeInsetsGeometry? padding;

  /// [GridView] max width.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProv, child) {
        final isLoading = storyProv.state == StoryProviderState.loading;
        final isFail = storyProv.state == StoryProviderState.fail;
        final stories = storyProv.stories;

        if (isLoading) return child!;

        if (stories.isEmpty || isFail) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((isFail) ? 'Fail to fetch stories' : 'No Data'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: refreshCallback(context, storyProvider: storyProv),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return SizedBox.expand(
          child: Center(
            child: SizedBox(
              width: maxWidth,
              child: GridView.builder(
                gridDelegate: gridDelegate,
                itemCount: stories.length,
                padding: padding,
                itemBuilder: (context, index) {
                  final story = stories[index];

                  return StoriesListItem(story, onTap: () {
                    context.go(AppRoutePaths.storyDetail(story.id));
                  });
                },
              ),
            ),
          ),
        );
      },
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  VoidCallback refreshCallback(
    BuildContext context, {
    required StoryProvider storyProvider,
  }) {
    return () async {
      final showSnackBar = context.scaffoldMessenger.showSnackBar;

      try {
        await storyProvider.fetchStories(
          token: loginInfo.token,
          page: page,
          size: size,
        );
      } on HttpResponseException catch (e) {
        debugPrint('$e ${e.message}');
        showSnackBar(SnackBar(
          content: Text(
            e.message ?? '${e.statusCode}: ${e.name}',
          ),
        ));
      }
    };
  }
}
