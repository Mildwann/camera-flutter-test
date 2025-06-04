import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testcamera/screens/camera/fullpage_dialog.dart';

class MyHomePage extends StatefulWidget  {
  final List<CameraDescription> cameras;
  const MyHomePage({super.key, required this.cameras});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _lastCapturedImagePath;
  double? _imageAspectRatio;

  void _showFullPageDialog(BuildContext context) async {
      final status = await Permission.camera.status;
  if (!status.isGranted) {
    final result = await Permission.camera.request();
    if (!result.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่ได้รับสิทธิ์เข้าถึงกล้อง')),
      );
      return; // ไม่อนุญาตก็ไม่เปิดกล้อง
    }
  }
    final imagePath = await showGeneralDialog<String?>(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: true,
      barrierLabel: 'FullpageDialog',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FullPageDialog(cameras: widget.cameras);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );

    if (imagePath != null) {
      final bytes = await File(imagePath).readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);
      setState(() {
        _lastCapturedImagePath = imagePath;
        _imageAspectRatio = decodedImage.width / decodedImage.height;
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _lastCapturedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Charcoal dark blue shade
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E), // Darker blue-gray
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Camera App',
          style: TextStyle(
            color: Color(0xFFEEEEEE),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
            fontSize: 22,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Open Camera Button (Improved)
              GestureDetector(
                onTap: () => _showFullPageDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 60,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Open Camera',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 52),

              // Animated Image Preview
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInBack,
                child: _lastCapturedImagePath != null
                    ? Stack(
                        key: const ValueKey('image_display'),
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: _imageAspectRatio != null
                                        ? AspectRatio(
                                            aspectRatio: _imageAspectRatio!,
                                            child: Image.file(
                                              File(_lastCapturedImagePath!),
                                              fit: BoxFit
                                                  .contain, // ไม่ครอป ไม่บีบภาพ
                                            ),
                                          )
                                        : Image.file(
                                            File(_lastCapturedImagePath!),
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Delete Button
                          Positioned(
                            top: 12,
                            right: 12,
                            child: ClipOval(
                              child: Material(
                                color: Colors.black38,
                                child: InkWell(
                                  splashColor: Colors.redAccent.withOpacity(
                                    0.4,
                                  ),
                                  onTap: _deleteImage,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 24,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        key: const ValueKey('no_image'),
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 90,
                              color: Colors.white24,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No photo taken yet',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.7,
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
    );
  }
}
