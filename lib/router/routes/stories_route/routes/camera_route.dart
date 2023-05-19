part of '../stories_route.dart';

final _cameraRoute = GoRoute(
  path: 'camera',
  builder: (_, __) => InAppCameraPage(global_data.deviceCameras),
);
