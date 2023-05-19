import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickedImageProvider extends ChangeNotifier {
  PickedImageProvider();

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;
  set imageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }
}
