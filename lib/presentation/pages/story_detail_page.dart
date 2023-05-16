import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/story.dart';
import '../../router/app_route_paths.dart';
import '../../utils/custom_text_overflow.dart';
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
                    onPressed: () async {
                      await storyProv.fetchStoryDetail(
                        token: loginInfo.name,
                        id: widget.storyId,
                      );
                    },
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
            final storiesRouteQueriesProv =
                context.read<StoriesRouteQueriesProvider>();

            final isSmallDevice = constraint.maxWidth <= 600;

            if (isSmallDevice) {
              return _PageForSmallDevice(
                story,
                storiesRouteQueriesProvider: storiesRouteQueriesProv,
              );
            }

            return _PageForWideDevice(
              story,
              storiesRouteQueriesProvider: storiesRouteQueriesProv,
            );
          });
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

VoidCallback backButtonCallback(
  BuildContext context, {
  required int page,
  required int size,
}) {
  return () => context.go(AppRoutePaths.stories(page: page, size: size));
}

class _PageForSmallDevice extends StatelessWidget {
  const _PageForSmallDevice(
    this.story, {
    required this.storiesRouteQueriesProvider,
  });

  final Story story;
  final StoriesRouteQueriesProvider storiesRouteQueriesProvider;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = context.mediaQuery.size.width;
    final deviceHeight = context.mediaQuery.size.height;

    final colorScheme = context.theme.colorScheme;

    return Stack(
      children: [
        // Background (image)
        CachedNetworkImage(
          imageUrl: story.photoUrl,
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
          child: DraggableScrollableSheet(
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
                    mainContent(context, controller: scrollController),
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
                page: storiesRouteQueriesProvider.page,
                size: storiesRouteQueriesProvider.size,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget mainContent(
    BuildContext context, {
    ScrollController? controller,
  }) {
    final textTheme = context.textTheme;

    final name = story.name;

    final titleMedium = textTheme.titleMedium;
    final dateTimeTextTheme = titleMedium?.copyWith(
      color: titleMedium.color?.withOpacity(0.5),
    );

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customTextOverflow(name, maxLength: 24),
                      style: textTheme.headlineMedium,
                    ),
                    Text(
                      // TODO: Localizations it with 'yMMMMd' format
                      story.createdAt.toString(),
                      style: dateTimeTextTheme,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              story.description,
              style: textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _PageForWideDevice extends StatelessWidget {
  const _PageForWideDevice(
    this.story, {
    required this.storiesRouteQueriesProvider,
  });

  final Story story;
  final StoriesRouteQueriesProvider storiesRouteQueriesProvider;

  @override
  Widget build(BuildContext context) {
    final isWiderDevice = context.screenSize.width >= 900.0;

    const pageMinSize = Size(900.0, 600.0);

    final textTheme = context.textTheme;

    final name = story.name;

    final bodyMedium = textTheme.bodyMedium;
    final dateTimeTextTheme = bodyMedium?.copyWith(
      color: bodyMedium.color?.withOpacity(0.5),
    );

    return Center(
      child: Container(
        width: pageMinSize.width,
        height: pageMinSize.height,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CachedNetworkImage(
                imageUrl: story.photoUrl,
                fit: BoxFit.cover,
                height: pageMinSize.height,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.0,
                          child: Text(
                            name[0].toUpperCase(),
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customTextOverflow(
                                name,
                                maxLength: isWiderDevice ? 40 : 20,
                              ),
                              style: textTheme.titleLarge,
                            ),
                            Text(
                              // TODO: Localizations it with 'yMMMMd' format
                              customTextOverflow(
                                '${story.createdAt}',
                                maxLength: isWiderDevice ? 40 : 20,
                              ),
                              style: dateTimeTextTheme,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      flex: 4,
                      child: Text(
                        story.description,
                        style: textTheme.bodyLarge,
                        // maxLines: context.screenSize.height <= 600 ? 5 : 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: backButtonCallback(
                            context,
                            page: storiesRouteQueriesProvider.page,
                            size: storiesRouteQueriesProvider.size,
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
    );
  }
}
