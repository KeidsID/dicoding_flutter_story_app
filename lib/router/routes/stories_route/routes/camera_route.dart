part of '../stories_route.dart';

final _cameraRoute = GoRoute(
  path: 'camera',
  builder: (context, _) {
    final cameras = context.read<CamerasProvider>().cameras;

    if (cameras.isEmpty) return const CameraNotFoundPage();

    return InAppCameraPage(cameras);
  },
);
