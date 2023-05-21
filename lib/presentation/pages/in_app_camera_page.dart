import 'package:camera/camera.dart';
import 'package:core/core.dart';
import 'package:dicoding_flutter_story_app/utils/navigate_to_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/app_route_paths.dart';
import '../../utils/pick_image_from_gallery.dart';
import '../providers/picked_image_provider.dart';
import '../widgets/image_from_x_file/image_from_x_file.dart';

class InAppCameraPage extends StatefulWidget {
  /// Use [availableCameras] method to get the camera list.
  final List<CameraDescription> cameras;

  const InAppCameraPage(this.cameras, {super.key});

  @override
  State<InAppCameraPage> createState() => _InAppCameraPageState();
}

class _InAppCameraPageState extends State<InAppCameraPage>
    with WidgetsBindingObserver {
  bool isCamInitialized = false;

  CameraController? cameraController;

  XFile? cameraResult;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    setCamController(widget.cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = cameraController;

    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setCamController(controller.description);
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
  }

  Future<void> setCamController(CameraDescription camDesc) async {
    final previousController = cameraController;
    final newController = CameraController(camDesc, ResolutionPreset.medium);

    await previousController?.dispose();

    try {
      await newController.initialize();
    } on CameraException catch (e) {
      debugPrint('Set camera controller error: $e');
    }

    if (mounted) {
      setState(() {
        cameraController = newController;
        isCamInitialized = cameraController!.value.isInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCamResultNull = cameraResult == null;

    final isSmallDevice = context.screenSize.width <= 600.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onAppBarLeadingTap(),
          icon: Icon(isCamResultNull ? Icons.arrow_back : Icons.clear),
          tooltip: isCamResultNull
              ? MaterialLocalizations.of(context).backButtonTooltip
              : 'Discard',
        ),
        actions: !isCamResultNull
            ? null
            : [
                (kIsWeb || defaultTargetPlatform == TargetPlatform.windows)
                    ? _CameraSwitchDesktop(
                        value: cameraController?.description,
                        items: widget.cameras,
                        onChanged: (value) => setCamController(value!),
                      )
                    : IconButton(
                        onPressed: onMobileCamSwitch,
                        icon: const Icon(Icons.cameraswitch_outlined),
                      ),
              ],
      ),
      body: Center(
        child: SizedBox(
          width: 900.0,
          height: context.screenSize.height,
          child: !isCamResultNull
              ? ImageFromXFile(cameraResult!, fit: BoxFit.cover)
              : Stack(
                  children: [
                    // Camera
                    cameraController == null
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox.expand(
                            child: isCamInitialized
                                ? CameraPreview(cameraController!)
                                : const HttpErrorPage(
                                    statusCode: 501,
                                    message:
                                        'The camera failed to initialize, please change to another camera if available.',
                                  ),
                          ),

                    // Upload image button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0).copyWith(
                          bottom: isSmallDevice ? 60.0 : 16.0,
                        ),
                        child: FilledButton.tonalIcon(
                          onPressed: () => pickImageFromGallery(context),
                          icon: const Icon(Icons.image_rounded),
                          label: const Text('From gallery'),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: kToolbarHeight,
        child: isCamResultNull
            ? null
            : Center(
                child: FilledButton(
                  onPressed: onNextButtonTap,
                  child: const Text('Next'),
                ),
              ),
      ),
      floatingActionButton: !isCamResultNull
          ? null
          : FloatingActionButton.large(
              onPressed: isCamInitialized ? takePictureFromCamera : () {},
              child: const Icon(Icons.camera_alt),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  VoidCallback? onAppBarLeadingTap() {
    return cameraResult == null
        ? () => navigateToHome(context)
        : () => setState(() => cameraResult = null);
  }

  void onMobileCamSwitch() {
    final cameras = widget.cameras;

    if (cameras.length == 1) return;

    final currentCamDesc = cameraController?.description;

    if (cameras.first.name == currentCamDesc?.name) {
      setCamController(cameras[1]);
    } else {
      setCamController(cameras.first);
    }
  }

  Future<void> takePictureFromCamera() async {
    final XFile? imgFile = await cameraController?.takePicture();

    if (imgFile == null) return;

    setState(() {
      cameraResult = imgFile;
    });
  }

  void onNextButtonTap() {
    final imagePickerProv = context.read<PickedImageProvider>();

    imagePickerProv.imageFile = cameraResult;

    context.go(AppRoutePaths.postStory);
  }
}

class _CameraSwitchDesktop extends StatelessWidget {
  const _CameraSwitchDesktop({
    this.value,
    required this.items,
    required this.onChanged,
  });

  /// The value of the currently selected [DropdownMenuItem].
  final CameraDescription? value;

  /// The list of items the user can select.
  final List<CameraDescription> items;

  /// Called when the user selects an item.
  ///
  /// If the [onChanged] callback is null or the list of [DropdownButton.items]
  /// is null then the dropdown button will be disabled, i.e. its arrow will be
  /// displayed in grey and it will not respond to input.
  final ValueChanged<CameraDescription?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: DropdownButton<CameraDescription>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem<CameraDescription>(
                value: e,
                child: SizedBox(
                  width: 200.0,
                  child: Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
