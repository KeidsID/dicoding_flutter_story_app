import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFromNetwork extends StatelessWidget {
  /// Creates a widget that displays an image obtained from the network and
  /// cache it.
  ///
  /// This widget has a placeholder that will be displayed when the image is
  /// loading, as well as an error widget that will be displayed when the image
  /// fails to load.
  const ImageFromNetwork({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  final String imageUrl;

  /// If non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double? width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder widget does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double? height;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    Image.network;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, __) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image_rounded),
      ),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
