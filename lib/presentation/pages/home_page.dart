import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/story_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final unListenAuthProv = context.read<AuthProvider>();
      final unListenStoryProv = context.read<StoryProvider>();

      final loginInfo = unListenAuthProv.loginInfo!;

      try {
        await unListenStoryProv.fetchStories(token: loginInfo.token);
      } on HttpResponseException catch (e) {
        debugPrint('$e ${e.message}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unListenAuthProv = context.read<AuthProvider>();

    // Won't null because the auth state is loggedIn
    final loginInfo = unListenAuthProv.loginInfo!;

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      drawer: Drawer(
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
      ),
      body: Consumer<StoryProvider>(
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
                    onPressed: () async {
                      final showSnackBar =
                          context.scaffoldMessenger.showSnackBar;

                      try {
                        await storyProv.fetchStories(token: loginInfo.token);
                      } on HttpResponseException catch (e) {
                        debugPrint('$e ${e.message}');
                        showSnackBar(SnackBar(
                          content: Text(
                            e.message ?? '${e.statusCode}: ${e.name}',
                          ),
                        ));
                      }
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final story = stories[index];

              return ListTile(
                isThreeLine: true,
                leading: SizedBox(
                  width: 160.0,
                  child: Image.network(story.photoUrl, fit: BoxFit.cover),
                ),
                title: Text(story.name),
                subtitle: Text(story.description, maxLines: 2),
              );
            },
            itemCount: storyProv.stories.length,
          );
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
