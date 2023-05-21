import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../utils/navigate_to_home.dart';
import '../../utils/pick_image_from_gallery.dart';

class CameraNotFoundPage extends StatelessWidget {
  const CameraNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => navigateToHome(context),
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
        child: FloatingActionButton.extended(
          onPressed: () => pickImageFromGallery(context),
          icon: const Icon(Icons.image),
          label: const Text('From gallery'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
