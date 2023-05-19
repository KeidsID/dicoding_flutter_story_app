import 'package:camera/camera.dart';

late List<CameraDescription> deviceCameras;

Future<void> init() async {
  deviceCameras = await availableCameras();
}
