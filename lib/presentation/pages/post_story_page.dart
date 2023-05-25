import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/app_route_paths.dart';
import '../../router/utils/navigate_to_stories_page.dart';
import '../providers/auth_provider.dart';
import '../providers/picked_image_provider.dart';
import '../providers/stories_route_queries_provider.dart';
import '../providers/story_provider.dart';
import '../widgets/app_alert_dialog.dart';
import '../widgets/image_from_x_file/image_from_x_file.dart';

class PostStoryPage extends StatefulWidget {
  const PostStoryPage({super.key});

  @override
  State<PostStoryPage> createState() => _PostStoryPageState();
}

class _PostStoryPageState extends State<PostStoryPage> {
  late final TextEditingController descriptionController;

  late final PickedImageProvider imagePickerProvider;

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController();
    imagePickerProvider = context.read<PickedImageProvider>();
  }

  @override
  void dispose() {
    super.dispose();

    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = imagePickerProvider.imageFile;

    if (imageFile == null) {
      return HttpErrorPages.client.badRequest(
        message:
            'Image file not found. This happens if you navigate directly to this URL without uploading an image from "/stories/camera" path',
        child: TextButton(
          onPressed: () => context.go(AppRoutePaths.camera),
          child: const Text('Go to Camera'),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        onAppBarLeadingTap();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: onAppBarLeadingTap,
            icon: const Icon(Icons.clear),
            tooltip: 'Discard',
          ),
          title: const Text("Post Story"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 900.0,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ImageFromXFile(
                    imageFile,
                    width: 900.0,
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                  TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      hintText: 'Tell your story',
                    ),
                    // minLines: 1,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16.0),
                  Consumer<StoryProvider>(
                    builder: (context, storyProv, child) {
                      final showSnackBar =
                          context.scaffoldMessenger.showSnackBar;

                      final postState = storyProv.postStoryState;
                      final storiesState = storyProv.storiesState;

                      final isPostSuccess =
                          postState == StoryProviderState.success;
                      final isLoading =
                          postState == StoryProviderState.loading ||
                              storiesState == StoryProviderState.loading;

                      if (isPostSuccess) {
                        Future.microtask(() {
                          showSnackBar(const SnackBar(
                            content: Text(
                              'Story has been posted. Redirects to the home page',
                            ),
                          ));
                        });
                      }

                      if (isLoading) return child!;

                      return FilledButton.icon(
                        onPressed: onPostStory,
                        icon: const Icon(Icons.cloud_upload_rounded),
                        label: const Text('Post'),
                      );
                    },
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onAppBarLeadingTap() {
    showDialog(
      context: context,
      builder: (context) {
        return AppAlertDialog(
          title: const Text('Discard Story'),
          content: const Text('Are you sure?'),
          isDefaultActionIncluded: false,
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                imagePickerProvider.imageFile = null;
                context.go(AppRoutePaths.camera);
              },
              child: const Text('Discard'),
            )
          ],
        );
      },
    );
  }

  Future<void> onPostStory() async {
    final showSnackBar = context.scaffoldMessenger.showSnackBar;

    // To avoid using context on async gap.
    void navToHome({bool isQueriesProvided = true}) {
      return navigateToStoriesPage(
        context,
        isQueriesProvided: isQueriesProvided,
      );
    }

    final loginInfo = context.read<AuthProvider>().loginInfo!;
    final storiesRouteQueries = context.read<StoriesRouteQueriesProvider>();
    final storyProvider = context.read<StoryProvider>();

    final imageFile = imagePickerProvider.imageFile;

    if (imageFile == null) {
      navToHome();
      return;
    }

    final imageFileByte = await imageFile.readAsBytes();
    final imageFilename = imageFile.name;

    try {
      await storyProvider.postStory(
        token: loginInfo.token,
        description: descriptionController.text,
        imageFileBytes: imageFileByte,
        imageFilename: imageFilename,
      );

      imagePickerProvider.imageFile = null;

      storiesRouteQueries.page = 1;
      navToHome(isQueriesProvided: false);

      // reset post story state
      storyProvider.postStoryState = StoryProviderState.init;
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(
        content: Text(e.message ?? '${e.statusCode}: ${e.name}'),
      ));
    } catch (e) {
      showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }
}
