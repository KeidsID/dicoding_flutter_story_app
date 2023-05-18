import 'package:camera/camera.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/app_route_paths.dart';
import '../providers/image_picker_provider.dart';
import '../providers/stories_route_queries_provider.dart';
import '../widgets/image_from_x_file/image_from_x_file.dart';

class CustomCameraPage extends StatefulWidget {
  /// Use [availableCameras] method to get the camera list.
  final List<CameraDescription> cameras;

  const CustomCameraPage(this.cameras, {super.key});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage>
    with WidgetsBindingObserver {
  bool isCamInitialized = false;

  CameraController? camController;

  XFile? cameraResult;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    setCamController(widget.cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = camController;

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
    camController?.dispose();
  }

  Future<void> setCamController(CameraDescription camDesc) async {
    final previousCamController = camController;
    final newCamController = CameraController(camDesc, ResolutionPreset.medium);

    await previousCamController?.dispose();

    try {
      await newCamController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        camController = newCamController;
        isCamInitialized = camController!.value.isInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCamResultNull = cameraResult == null;

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
                        value: camController?.description,
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
          child: isCamResultNull
              ? isCamInitialized
                  ? CameraPreview(camController!)
                  : const SizedBox()
              : ImageFromXFile(cameraResult!, fit: BoxFit.cover),
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
              onPressed: onCameraTake,
              child: const Icon(Icons.camera_alt),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  VoidCallback? onAppBarLeadingTap() {
    return cameraResult == null
        ? () {
            final storiesRouteQueriesProv =
                context.read<StoriesRouteQueriesProvider>();

            context.go(AppRoutePaths.stories(
              page: storiesRouteQueriesProv.page,
              size: storiesRouteQueriesProv.size,
            ));
          }
        : () {
            setState(() => cameraResult = null);
          };
  }

  void onMobileCamSwitch() {
    final cameras = widget.cameras;

    if (cameras.length == 1) return;

    final currentCamDesc = camController?.description;

    if (cameras.first.name == currentCamDesc?.name) {
      setCamController(cameras[1]);
    } else {
      setCamController(cameras.first);
    }
  }

  Future<void> onCameraTake() async {
    final XFile? imgFile = await camController?.takePicture();

    if (imgFile == null) return;

    setState(() {
      cameraResult = imgFile;
    });
  }

  void onNextButtonTap() {
    final imagePickerProv = context.read<ImagePickerProvider>();

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
    return Container(
      width: 150.0,
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
                child: Text(
                  e.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
