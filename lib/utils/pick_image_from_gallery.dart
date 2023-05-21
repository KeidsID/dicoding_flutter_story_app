import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../presentation/providers/picked_image_provider.dart';
import '../router/app_route_paths.dart';

Future<void> pickImageFromGallery(BuildContext context) async {
  final navigateTo = context.go;
  final showSnackBar = context.scaffoldMessenger.showSnackBar;

  final pickedImageProv = context.read<PickedImageProvider>();
  final imgPicker = ImagePicker();

  final XFile? pickedImage = await imgPicker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedImage == null) {
    showSnackBar(const SnackBar(content: Text('No image selected')));
    return;
  }

  pickedImageProv.imageFile = pickedImage;

  navigateTo(AppRoutePaths.postStory);
}
