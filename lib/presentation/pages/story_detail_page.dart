import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:dicoding_flutter_story_app/presentation/providers/stories_route_queries_provider.dart';
import 'package:dicoding_flutter_story_app/router/app_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/story.dart';
import '../../utils/navigate_to_home.dart';
import '../providers/auth_provider.dart';
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
  @override
  void initState() {
    super.initState();

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
    final loginInfo = context.read<AuthProvider>().loginInfo!;

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

/// This class keeps the content widgets on wide and small device pages
/// consistent.
abstract class _PageContentWidgets {
  static CircleAvatar uploaderAvatar(BuildContext context, String name) {
    return CircleAvatar(
      radius: 27.5,
      child: Text(
        name[0].toUpperCase(),
        style: context.textTheme.headlineLarge,
      ),
    );
  }

  static Text fullName(BuildContext context, String name) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.headlineMedium,
    );
  }

  static Widget createdAt(BuildContext context, DateTime createdAt) {
    return Opacity(
      opacity: 0.5,
      child: Text(
        // TODO: 'yMMMMd' format
        '$createdAt',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleMedium,
      ),
    );
  }

  static Text description(BuildContext context, String description) {
    return Text(description, style: context.textTheme.titleLarge);
  }
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

          // Main content draggable container
          Padding(
            padding: const EdgeInsets.only(top: 72.0),
            child: GestureDetector(
              // Draggable using mouse pointer on web/desktop
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
                              borderRadius: BorderRadius.circular(16.0),
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
                onPressed: () => navigateToHome(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainContent({ScrollController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story uploader info
            Row(
              children: [
                _PageContentWidgets.uploaderAvatar(context, widget.story.name),
                const SizedBox(width: 16.0),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PageContentWidgets.fullName(context, widget.story.name),
                      _PageContentWidgets.createdAt(
                        context,
                        widget.story.createdAt,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Desc
            _PageContentWidgets.description(context, widget.story.description),
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

    const pageMinSize = Size(900.0, 600.0);
    final containerBorderRadius = BorderRadius.circular(16.0);

    return SafeArea(
      child: Center(
        child: Container(
          width: pageMinSize.width,
          height: pageMinSize.height,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colorScheme.onBackground.withOpacity(0.05),
            borderRadius: containerBorderRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: containerBorderRadius,
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

              // Story details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story uploader info
                      Row(
                        children: [
                          Center(
                            child: _PageContentWidgets.uploaderAvatar(
                              context,
                              story.name,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _PageContentWidgets.fullName(
                                  context,
                                  story.name,
                                ),
                                _PageContentWidgets.createdAt(
                                  context,
                                  story.createdAt,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Story details
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              _PageContentWidgets.description(
                                context,
                                story.description,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Actions
                      Flexible(
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () => navigateToHome(context),
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
