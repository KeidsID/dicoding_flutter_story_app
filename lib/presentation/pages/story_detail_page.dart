import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/story.dart';
import '../../router/app_route_paths.dart';
import '../providers/auth_provider.dart';
import '../providers/stories_route_queries_provider.dart';
import '../providers/story_provider.dart';
import '../widgets/text_button_to_home.dart';

class StoryDetailPage extends StatefulWidget {
  const StoryDetailPage(
    this.storyId, {
    super.key,
  });

  final String storyId;

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late final AuthProvider unListenAuthProv;

  @override
  void initState() {
    super.initState();

    unListenAuthProv = context.read();

    Future.microtask(() async {
      final token = context.read<AuthProvider>().loginInfo!.token;

      try {
        await context
            .read<StoryProvider>()
            .fetchStoryDetail(token: token, id: widget.storyId);
      } catch (e) {
        debugPrint('$e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = unListenAuthProv.loginInfo!;

    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, storyProv, child) {
          final isProvFirstInit = storyProv.state == StoryProviderState.init;
          final isLoading = storyProv.state == StoryProviderState.loading;
          final isFail = storyProv.state == StoryProviderState.fail;
          final story = storyProv.story;

          if (isLoading || isProvFirstInit) return child!;

          if (isFail) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Fail to fetch story detail'),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () => refreshStoryDetail(loginInfo.token),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          if (story == null) {
            return const HttpErrorPage(
              statusCode: 404,
              child: TextButtonToHome(),
            );
          }

          return LayoutBuilder(builder: (context, constraint) {
            final isSmallDevice = constraint.maxWidth <= 600;

            if (isSmallDevice) {
              return _PageForSmallDevice(story);
            }

            return _PageForWideDevice(story);
          });
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> refreshStoryDetail(String token) async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;

    try {
      await context
          .read<StoryProvider>()
          .fetchStoryDetail(token: token, id: widget.storyId);
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(
          e.message ?? '${e.statusCode}: ${e.name}',
        ),
      ));
    } catch (e) {
      showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

VoidCallback? backButtonCallback(BuildContext context,
    {required int page, required int size}) {
  return () => context.go(AppRoutePaths.stories(page: page, size: size));
}

class _PageForSmallDevice extends StatefulWidget {
  const _PageForSmallDevice(this.story);

  final Story story;

  @override
  State<_PageForSmallDevice> createState() => _PageForSmallDeviceState();
}

class _PageForSmallDeviceState extends State<_PageForSmallDevice> {
  late DraggableScrollableController draggableScrollableController;

  @override
  void initState() {
    super.initState();
    draggableScrollableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    super.dispose();
    draggableScrollableController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = context.mediaQuery.size.width;
    final deviceHeight = context.mediaQuery.size.height;
    final colorScheme = context.theme.colorScheme;

    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();

    return SafeArea(
      child: Stack(
        children: [
          // Background (image)
          CachedNetworkImage(
            imageUrl: widget.story.photoUrl,
            placeholder: (_, __) => const Center(
              child: CircularProgressIndicator(),
            ),
            width: deviceWidth,
            height: deviceHeight - (deviceHeight / 3),
            fit: BoxFit.cover,
          ),
          // Main content draggable container.
          Padding(
            padding: const EdgeInsets.only(top: 72.0),
            child: GestureDetector(
              // Draggable using mouse pointer on desktop.
              onVerticalDragUpdate: onMainContainerDrag,
              child: DraggableScrollableSheet(
                controller: draggableScrollableController,
                minChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        mainContent(controller: scrollController),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.onBackground,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            height: 4.0,
                            width: 80.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // AppBar actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              backgroundColor: colorScheme.background,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: colorScheme.onBackground,
                onPressed: backButtonCallback(
                  context,
                  page: storiesRouteQueries.page,
                  size: storiesRouteQueries.size,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainContent({ScrollController? controller}) {
    final textTheme = context.textTheme;

    // Displayed contents
    final name = widget.story.name;
    final createdAt = '${widget.story.createdAt}';
    final description = widget.story.description;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  child: Text(
                    name[0].toUpperCase(),
                    style: textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineMedium,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          // TODO: Localizations it with 'yMMMMd' format
                          createdAt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  void onMainContainerDrag(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0.0;
    final controllerSize = draggableScrollableController.size;
    final dragSize = controllerSize + (-(delta / 500));

    draggableScrollableController.jumpTo(
      (dragSize < 0.5)
          ? 0.5
          : (dragSize > 1.0)
              ? 1.0
              : dragSize,
    );
  }
}

class _PageForWideDevice extends StatelessWidget {
  const _PageForWideDevice(this.story);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    // displayed contents
    final name = story.name;
    final createdAt = '${story.createdAt}';
    final description = story.description;

    const pageMinSize = Size(900.0, 600.0);
    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();

    return SafeArea(
      child: Center(
        child: Container(
          width: pageMinSize.width,
          height: pageMinSize.height,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colorScheme.onBackground.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CachedNetworkImage(
                    imageUrl: story.photoUrl,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: pageMinSize.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 27.5,
                              child: Text(
                                name[0].toUpperCase(),
                                style: textTheme.headlineLarge,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.headlineMedium,
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    // TODO: Localizations it with 'yMMMMd' format
                                    createdAt,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        flex: 4,
                        child: Text(
                          description,
                          style: textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: backButtonCallback(
                              context,
                              page: storiesRouteQueries.page,
                              size: storiesRouteQueries.size,
                            ),
                            child: const Text('Go Back'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
