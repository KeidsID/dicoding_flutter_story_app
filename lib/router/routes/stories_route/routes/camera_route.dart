part of '../stories_route.dart';

final _cameraRoute = GoRoute(
  path: 'camera',
  builder: (_, __) => CustomCameraPage(global_data.deviceCameras),
);
