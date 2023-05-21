part of '../stories_route.dart';

final _cameraRoute = GoRoute(
  path: 'camera',
  builder: (_, __) {
    final List<CameraDescription> cameras = global_data.deviceCameras;

    if (cameras.isEmpty) return const CameraNotFoundPage();

    return InAppCameraPage(cameras);
  },
);
