import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];
  print(cameras);

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  final stream = StreamController<CameraValue>();
  final player = AudioPlayer();
  final zoomState = StreamController<double>();
  double zoomDouble = 1.0;

  final globalKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  Widget build(BuildContext context) {
    final scrollController =
        ScrollController();
    return StreamBuilder<CameraValue>(
      stream: stream.stream,
      builder: (context, snapshot1) {
        return Scaffold(
          // appBar: AppBar(title: const Text('Take a picture')),
          body: SafeArea(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  if (!_controller.hasListeners) {
                    _controller.addListener(() {
                      stream.add(_controller.value);
                    });
                  }
                  // _controller.startImageStream((image) => print(image.sensorSensitivity));
                  return CameraPreview(
                    _controller,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        // StreamBuilder<double>(
                        //   stream: zoomState.stream,
                        //   builder: (context, zoom) {
                        //     return Slider(
                        //         min: 1,
                        //         max: 9,
                        //         value: zoom.data ?? 1, onChanged: (val){
                        //       _controller.setZoomLevel(val);
                        //       zoomState.add(val);
                        //     });
                        //   }
                        // ),
                        snapshot1.data?.isRecordingVideo ?? false
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle, color: Colors.red),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 100,
                            child: ListView(
                              padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width / 2) - 26, right: (MediaQuery.of(context).size.width / 2) - 42),
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Container(
                                            key: globalKeys[0],
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey, shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.pets),
                                              onPressed: () async {
                                                HapticFeedback.mediumImpact();
                                                await player.play(
                                                  AssetSource('woof.wav'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Container(
                                            key: globalKeys[1],
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey, shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.hourglass_bottom),
                                              onPressed: () async {
                                                HapticFeedback.mediumImpact();
                                                await player.play(
                                                  AssetSource('broken_glass.wav'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Container(
                                            key: globalKeys[2],
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey, shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.emoji_transportation),
                                              onPressed: () async {
                                                HapticFeedback.mediumImpact();
                                                await player.play(
                                                  AssetSource('psh.wav'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Container(
                                            key: globalKeys[3],
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey, shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.animation),
                                              onPressed: () async {
                                                HapticFeedback.mediumImpact();
                                                await player.play(
                                                  AssetSource('belka.wav'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Container(
                                            key: const ValueKey('5'),
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey, shape: BoxShape.circle),
                                            child: IconButton(
                                              icon: const Icon(Icons.feed),
                                              onPressed: () async {
                                                HapticFeedback.mediumImpact();
                                                await player.play(
                                                  AssetSource('osel.wav'),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: snapshot1.data?.isRecordingVideo ?? false
                      ? OutlinedButton(
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;
                              final video = await _controller.stopVideoRecording();
                              print(video.name);

                              if (!mounted) return;
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Icon(Icons.stop),
                        )
                      : OutlinedButton(
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;
                              final image = await _controller.startVideoRecording();

                              if (!mounted) return;
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Icon(Icons.play_arrow),
                        ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();

                      if (!mounted) return;

                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            imagePath: image.path,
                          ),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Icon(Icons.camera_alt),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(shape: const CircleBorder()),
                  onPressed: () async {
                    try {

                      // Scrollable.ensureVisible(globalKeys[2].currentContext!, duration: Duration(seconds: 1));
                      final cameras = await availableCameras();
                      final image = _controller.value;
                      if (image.description.lensDirection == CameraLensDirection.front) {
                        await _controller.setDescription(cameras[0]);
                      } else {
                        await _controller.setDescription(cameras[1]);
                      }
                      print(image.description);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Icon(Icons.cameraswitch),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
