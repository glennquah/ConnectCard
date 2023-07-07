import 'dart:io';

import 'package:camera/camera.dart';
import 'package:connectcard/screens/scan/ocr/result_screen.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import './ocr_card_editor.dart';
import 'package:connectcard/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/card_editor.dart';
import 'package:connectcard/models/Cards.dart';

class OcrScreen extends StatefulWidget {
  // const OcrScreen({Key? key}) : super(key: key);

  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  TheUser? user; // User object
  List<String> cards = []; // List of available cards
  String selectedCard = ''; // Selected card

  final _Name = GlobalKey<FormState>();
  String newName = '';

  bool _isPermissionGranted = false;

  late final Future<void> _future;

  // Controller for camera
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  String _cardType = 'personal';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object

    Color bgColor = const Color(0xffFEAA1B);

    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // } else if (snapshot.hasError) {
        //   return Center(
        //       child: Text(
        //           'Camera permission is denied. Plase go to Settings to allow camera permission to use'));
        // } else {
        if (user != null) {
          return Stack(
            children: [
              if (_isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _initCameraController(snapshot.data!);

                      // return CameraPreview(_cameraController!,
                      //     child: LayoutBuilder(builder: (context, constraints) {
                      //   return Container(
                      //     width: constraints.maxWidth,
                      //     height: constraints.maxHeight,
                      //   );
                      // }));

                      return Center(child: CameraPreview(_cameraController!));
                    } else {
                      // return const Center(child: CircularProgressIndicator());
                      return const LinearProgressIndicator();
                    }
                  },
                ),
              Scaffold(
                  appBar: AppBar(
                    title: const Text('Scan Name Card'),
                    automaticallyImplyLeading: false,
                    backgroundColor: bgColor,
                  ),
                  bottomNavigationBar: NaviBar(currentIndex: 1),
                  backgroundColor:
                      _isPermissionGranted ? Colors.transparent : bgColor,
                  body: _isPermissionGranted
                      ? Column(
                          children: [
                            Container(
                              color: bgColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: 'personal',
                                    groupValue: _cardType,
                                    onChanged: (value) {
                                      setState(() {
                                        _cardType = value!;
                                      });
                                    },
                                  ),
                                  const Text('Personal Card'),
                                  const SizedBox(width: 16),
                                  Radio<String>(
                                    value: 'friend',
                                    groupValue: _cardType,
                                    onChanged: (value) {
                                      setState(() {
                                        _cardType = value!;
                                      });
                                    },
                                  ),
                                  const Text("Friend's Card"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: ElevatedButton(
                                    onPressed: _scanImage,
                                    child: const Text('Scan text'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(24.0),
                            child: const Text(
                              'Camera permission denied. \nPlease enable camera permission for ConnectCard in the settings.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
            ],
          );
        } else {
          return Loading();
        }
        // }
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      late Widget nextPage;

      if (_cardType == 'personal') {
        nextPage = CardEditorScreen(
          selectedCard: selectedCard,
          recognizedText: recognizedText.text,
        );
      } else if (_cardType == 'friend') {
        nextPage = ResultScreen(text: recognizedText.text);
      }

      await navigator.push(
        MaterialPageRoute(builder: (BuildContext context) => nextPage),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }
}
