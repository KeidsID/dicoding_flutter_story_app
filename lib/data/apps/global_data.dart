import 'package:camera/camera.dart';

late final List<CameraDescription> deviceCameras;

Future<void> init() async {
  deviceCameras = await availableCameras();
}
