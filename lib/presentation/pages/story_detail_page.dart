import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:dicoding_flutter_story_app/router/app_route_paths.dart';
import 'package:dicoding_flutter_story_app/utils/custom_text_overflow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/story.dart';
import '../providers/auth_provider.dart';
import '../providers/story_provider.dart';
import '../widgets/text_button_to_home.dart';

class StoryDetailPage extends StatefulWidget {
  const StoryDetailPage(this.storyId, {super.key});

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

          return _PageForSmallDevice(story);
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _PageForSmallDevice extends StatelessWidget {
  const _PageForSmallDevice(this.story);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = context.mediaQuery.size.width;
    final deviceHeight = context.mediaQuery.size.height;

    final colorScheme = context.theme.colorScheme;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: story.photoUrl,
          placeholder: (_, __) => const Center(
            child: CircularProgressIndicator(),
          ),
          width: deviceWidth,
          height: deviceHeight - (deviceHeight / 3),
          fit: BoxFit.cover,
        ),
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
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.background,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: colorScheme.onBackground,
              onPressed: () => context.go(AppRoutePaths.stories()),
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
