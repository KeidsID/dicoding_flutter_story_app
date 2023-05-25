import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../router/app_route_paths.dart';
import '../../../router/utils/navigate_to_stories_page.dart';
import '../../providers/picked_image_provider.dart';

class CameraNotFoundPage extends StatelessWidget {
  const CameraNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => navigateToStoriesPage(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
      ),
      body: const HttpErrorPage(
        statusCode: 404,
        message: 'Camera not found. Pick image from gallery instead',
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton.tonalIcon(
          onPressed: () => pickImageFromGallery(context),
          icon: const Icon(Icons.image),
          label: const Text('Upload'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Pick image from gallery and store it to [PickedImageProvider], then
  /// navigate user to post story page ("/stories/post").
  Future<void> pickImageFromGallery(BuildContext context) async {
    final navigateTo = context.go;

    final pickedImageProv = context.read<PickedImageProvider>();
    final imgPicker = ImagePicker();

    final XFile? pickedImage = await imgPicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    pickedImageProv.imageFile = pickedImage;

    navigateTo(AppRoutePaths.postStory);
  }
}
