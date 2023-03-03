import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:green_ring/services/service_api.dart';

class CameraPreviewPage extends StatefulWidget {
  static const String routeName = "CameraPreviewPage";
  final CameraDescription camera;

  const CameraPreviewPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  late CameraController _controllerCamera;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controllerCamera = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controllerCamera.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: double.infinity,
              child: CameraPreview(_controllerCamera),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controllerCamera.takePicture();
            final result = await ServiceAPI().getIsRecyclable(image);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
