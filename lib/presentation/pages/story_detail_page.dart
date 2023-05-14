import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/story_provider.dart';

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
      final token = unListenAuthProv.loginInfo!.token;

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
          final isLoading = storyProv.state == StoryProviderState.loading;
          final isFail = storyProv.state == StoryProviderState.fail;
          final story = storyProv.story;
          final isNoData = story == null;

          if (isLoading) return child!;

          if (isFail || isNoData) {
            if (isNoData) return HttpErrorPages.client.notFound();

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Fail to fetch story detail'),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () => storyProv.fetchStoryDetail(
                      token: loginInfo.name,
                      id: widget.storyId,
                    ),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text(story.name));
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
