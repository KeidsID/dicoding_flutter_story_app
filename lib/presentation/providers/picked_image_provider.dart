import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Used to store and provide image that have been picked either by the camera
/// or image_picker.
class PickedImageProvider extends ChangeNotifier {
  PickedImageProvider();

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;
  set imageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }
}
