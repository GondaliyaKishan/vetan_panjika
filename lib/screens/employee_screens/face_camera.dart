// import 'dart:convert';
// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:vetan_panjika/ML/Recognition.dart';
// import 'package:vetan_panjika/ML/Recognizer.dart';
import 'package:vetan_panjika/main.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'employee_dashboard.dart';

class FaceCameraPage extends StatefulWidget {
  const FaceCameraPage({Key? key}) : super(key: key);
  @override
  _FaceCameraPageState createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage> {
  dynamic controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirection = CameraLensDirection.front;
  // late List<Recognition> recognitions = [];

  // face detector
  late FaceDetector faceDetector;

  // face recognizer
  // late Recognizer _recognizer;

  @override
  void initState() {
    super.initState();

    // initialize face detector
    faceDetector = FaceDetector(
        options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));

    // initialize face recognizer
    // _recognizer = Recognizer();

    // initialize camera footage
    initializeCamera();

    // get default userImage to match face with
    // registerUser();
  }

  // initialize the camera feed
  initializeCamera() async {
    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy)
              {isBusy = true, frame = image, doFaceDetectionOnFrame(false)}
          });
    });
  }

  String userName = "";
  // register user
  // registerUser() async {
  //   SharedPreferences shared = await SharedPreferences.getInstance();
  //   String _profilePic = shared.getString("profile_base64") ?? "";
  //   String _username = shared.getString("employee_name") ?? "";
  //   userName = (_username.contains(" ") ? _username.split(" ")[0] : _username);
  //
  //   final directory = await getApplicationDocumentsDirectory();
  //   File? userImg;
  //   userImg = File('${directory.path}/$userName.png');
  //   userImg.delete();
  //   userImg = File('${directory.path}/$userName.png');
  //   userImg.writeAsBytes(List.from(base64Decode(_profilePic)));
  //
  //   final inputImage = InputImage.fromFilePath(userImg.path);
  //   try {
  //     final faces = await faceDetector.processImage(inputImage);
  //     dynamic image;
  //     if (faces.isNotEmpty) {
  //       for (Face face in faces) {
  //         Rect faceRect = face.boundingBox;
  //         num left = faceRect.left < 0 ? 0 : faceRect.left;
  //         num top = faceRect.top < 0 ? 0 : faceRect.top;
  //         num right =
  //         faceRect.right > image.width ? image.width - 1 : faceRect.right;
  //         num bottom =
  //         faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
  //         num width = right - left;
  //         num height = bottom - top;
  //
  //       crop face
  //       File croppedFace = await FlutterNativeImage.cropImage(userImg.path,
  //           left.toInt(), top.toInt(), width.toInt(), height.toInt());
  //       final bytes = await File(croppedFace.path).readAsBytes();
  //       final img.Image? faceImg = img.decodeImage(bytes);
  //       Recognition recognition =
  //       _recognizer.recognize(faceImg!, face.boundingBox);
  //
  //       recognition.name = userName;
  //
  //       Recognizer.registered.putIfAbsent(userName, () => recognition);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     registerUser();
  //   }
  // }

  // close all resources
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  // face detection on a frame
  // dynamic _scanResults;
  CameraImage? frame;
  doFaceDetectionOnFrame(bool isRecognize) async {
    // convert frame into InputImage format
    InputImage inputImage = getInputImage();
    // pass InputImage to face detection model and detect faces
    List<Face> faces = await faceDetector.processImage(inputImage);

    if (isRecognize) {
      isRecognize = false;
      // perform face recognition on detected faces
      performFaceRecognition(faces);
    }

    if (mounted) {
      setState(() {
        // _scanResults = recognitions;
        isBusy = false;
      });
    }
  }

  img.Image? image;
  bool register = false;
  bool isVerified = false;
  // perform Face Recognition
  performFaceRecognition(List<Face> faces) async {
    // recognitions.clear();

    // convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = convertYUV420ToImage(frame!);
    image = img.copyRotate(
        image!, camDirection == CameraLensDirection.front ? 270 : 90);

    if (faces.isNotEmpty) {
      // for (Face face in faces) {
        // Rect faceRect = face.boundingBox;
        // crop face
        // img.Image croppedFace = img.copyCrop(
        //     image!,
        //     faceRect.left.toInt(),
        //     faceRect.top.toInt(),
        //     faceRect.width.toInt(),
        //     faceRect.height.toInt());

        // pass cropped face to face recognition model
        // Recognition recognition = _recognizer.recognize(croppedFace, faceRect);
        // if (recognition.distance > 1) {
        //   recognition.name = "Unknown";
        // }
        // if (!isVerified) {
        //   if (recognition.distance > 0.3 && recognition.distance < 0.8) {
            isVerified = true;
            // recognition.name = userName;
            img.Image? thumbnail = img.copyResize(image!, height: 350);
            image = thumbnail;
            var imgData = Uint8List.fromList(img.encodeBmp(image!));
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => EmployeeDashboard(bytes: imgData),
              ),
            );
        //   }
        // }

        // recognitions.add(recognition);
      // }
    }
    if (mounted) {
      setState(() {
        isBusy = false;
        // _scanResults = recognitions;
      });
    }
  }

  // method to convert CameraImage to Image
  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width, height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  // convert CameraImage to InputImage
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = frame!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  // toggle camera direction
  void _toggleCameraDirection() async {
    if (camDirection == CameraLensDirection.back) {
      camDirection = CameraLensDirection.front;
      description = cameras[1];
    } else {
      camDirection = CameraLensDirection.back;
      description = cameras[0];
    }
    await controller.stopImageStream();
    setState(() {
      controller;
    });

    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      // View for displaying the live camera footage
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height - size.height * 0.105,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );
      stackChildren.add(
          Positioned(
            bottom: 0.0,
            left: 0.0,
            height: size.height * 0.105,
            width: size.width,
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(200)),
                    child: InkWell(
                      onTap: () {
                        doFaceDetectionOnFrame(true);
                      },
                      child: SizedBox(
                        child: Icon(Icons.camera,
                            color: Colors.blue, size: size.width / 7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            _toggleCameraDirection();
          },
          child: const Icon(
            Icons.cameraswitch,
            color: Colors.white,
            size: 35,
          ),
        ),
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}
