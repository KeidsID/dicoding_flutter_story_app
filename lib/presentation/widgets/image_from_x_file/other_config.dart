import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFromXFile extends StatelessWidget {
  const ImageFromXFile(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit,
  });

  final XFile file;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(file.path),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
