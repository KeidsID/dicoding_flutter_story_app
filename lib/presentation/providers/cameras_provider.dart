import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CamerasProvider extends ChangeNotifier {
  CamerasProvider() {
    fetchCameras();
  }

  List<CameraDescription> _cameras = [];
  List<CameraDescription> get cameras => _cameras;

  Future<void> fetchCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Cameras exception: $e');
      _cameras = [];
    }

    notifyListeners();
  }
}
