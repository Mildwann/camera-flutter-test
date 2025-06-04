import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestDialog extends StatefulWidget {
  const PermissionRequestDialog({Key? key}) : super(key: key);

  @override
  State<PermissionRequestDialog> createState() => _PermissionRequestDialogState();
}

class _PermissionRequestDialogState extends State<PermissionRequestDialog> {
  bool _isRequesting = false;
  bool _permissionDenied = false;
  bool _isPermanentlyDenied = false;

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
      _permissionDenied = false;
      _isPermanentlyDenied = false;
    });

    final status = await Permission.camera.request();

    setState(() {
      _isRequesting = false;
      _permissionDenied = !status.isGranted;
      _isPermanentlyDenied = status.isPermanentlyDenied;
    });

    if (status.isGranted) {
      Navigator.of(context).pop(true);
    }
  }

  void _openAppSettings() async {
    final opened = await openAppSettings();
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดตั้งค่าได้')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 36, 35, 35),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_outlined, size: 100, color: Colors.white70),
                const SizedBox(height: 24),
                const Text(
                  'แอปต้องการสิทธิ์เข้าถึงกล้อง',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'กรุณาอนุญาตสิทธิ์กล้องเพื่อถ่ายภาพ',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                if (_isRequesting)
                  const CircularProgressIndicator(color: Colors.white)
                else if (_permissionDenied)
                  Column(
                    children: [
                      Text(
                        _isPermanentlyDenied
                            ? 'สิทธิ์กล้องถูกปฏิเสธถาวร\nกรุณาไปที่ตั้งค่าเพื่อเปิดสิทธิ์'
                            : 'คุณยังไม่ได้อนุญาตให้ใช้กล้อง',
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _isPermanentlyDenied
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: _openAppSettings,
                              child: const Text('ไปที่ตั้งค่า', style: TextStyle(fontSize: 18)),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: _openAppSettings,
                              child: const Text('ไปที่ตั้งค่า', style: TextStyle(fontSize: 18)),
                            ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('ยกเลิก', style: TextStyle(color: Colors.white54)),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 25, 61, 123),
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _requestPermission,
                    child: const Text('ขอตรวจสอบสิทธิ์', style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
