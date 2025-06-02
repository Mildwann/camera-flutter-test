import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:testcamera/screens/camera/fullpage_dialog.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyHomePage({super.key, required this.cameras});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _lastCapturedImagePath;

  void _showFullPageDialog(BuildContext context) async {
    final imagePath = await showGeneralDialog<String?>(
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
      setState(() {
        _lastCapturedImagePath = imagePath;
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
              // Elevated Gradient Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6F42C1), Color(0xFF9B59B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.6),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _showFullPageDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Open Camera',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                      fontFamily: 'Segoe UI',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 52),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInBack,
                child: _lastCapturedImagePath != null
                    ? Stack(
                        key: const ValueKey('image_display'),
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.85),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Image.file(
                                File(_lastCapturedImagePath!),
                                width: screenWidth * 0.75,
                                height: screenHeight * 0.45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Delete Button with subtle glow
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Material(
                              color: Colors.black54,
                              shape: const CircleBorder(),
                              elevation: 10,
                              child: IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 28),
                                onPressed: _deleteImage,
                                tooltip: 'Remove Photo',
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        key: const ValueKey('no_image'),
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_camera_outlined,
                              size: 80,
                              color: Colors.white38.withOpacity(0.6),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No photo taken yet',
                              style: TextStyle(
                                color: Colors.white54.withOpacity(0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.8,
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
