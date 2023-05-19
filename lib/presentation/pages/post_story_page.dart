import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/app_route_paths.dart';
import '../providers/auth_provider.dart';
import '../providers/picked_image_provider.dart';
import '../providers/story_provider.dart';
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

    return Scaffold(
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
                    final isLoading =
                        storyProv.state == StoryProviderState.loading;

                    if (isLoading) return child!;

                    return FloatingActionButton.extended(
                      onPressed: onPostStory,
                      icon: const Icon(Icons.upload),
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
    );
  }

  void onAppBarLeadingTap() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discard Story'),
          content: const Text('Are you sure?'),
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
    final navigateTo = context.go;

    final loginInfo = context.read<AuthProvider>().loginInfo!;
    final storyProvider = context.read<StoryProvider>();
    final imageFile = imagePickerProvider.imageFile;

    final imageFileByte = await imageFile!.readAsBytes();
    final imageFilename = imageFile.name;

    try {
      await storyProvider.postStory(
        token: loginInfo.token,
        description: descriptionController.text,
        imageFileBytes: imageFileByte,
        imageFilename: imageFilename,
      );

      imagePickerProvider.imageFile = null;

      navigateTo(AppRoutePaths.stories());
    } on HttpResponseException catch (e) {
      showSnackBar(SnackBar(content: Text('${e.message}')));
    }
  }
}
