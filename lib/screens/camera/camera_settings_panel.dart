import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraSettingsPanel extends StatefulWidget {
  final ResolutionPreset currentResolution;
  final double currentAspectRatio;
  final void Function(double) onAspectRatioChanged;
  final void Function(ResolutionPreset) onResolutionChanged;

  const CameraSettingsPanel({
    super.key,
    required this.currentResolution,
    required this.currentAspectRatio,
    required this.onAspectRatioChanged,
    required this.onResolutionChanged,
  });

  @override
  State<CameraSettingsPanel> createState() => _CameraSettingsPanelState();
}

class _CameraSettingsPanelState extends State<CameraSettingsPanel> {
  // late ResolutionPreset selectedResolution;
  // late double selectedAspectRatio;

  // static const double aspectRatio4by3 = 4 / 3;
  // static const double aspectRatio16by9 = 16 / 9;
  // static const double aspectRatio1by1 = 1 / 1;

  // final Map<double, List<ResolutionPreset>> resolutionOptionsByAspectRatio = {
  //   aspectRatio4by3: [
  //     ResolutionPreset.low,
  //     ResolutionPreset.medium,
  //     ResolutionPreset.high,
  //     ResolutionPreset.veryHigh,
  //     ResolutionPreset.ultraHigh,
  //     ResolutionPreset.max,
  //   ],
  //   aspectRatio16by9: [
  //     ResolutionPreset.low,
  //     ResolutionPreset.medium,
  //     ResolutionPreset.high,
  //     ResolutionPreset.veryHigh,
  //   ],
  //   aspectRatio1by1: [
  //     ResolutionPreset.low,
  //     ResolutionPreset.medium,
  //     ResolutionPreset.high,
  //   ],
  // };

  // List<ResolutionPreset> get availableResolutions =>
  //     resolutionOptionsByAspectRatio[selectedAspectRatio] ?? [];

  // @override
  // void initState() {
  //   super.initState();
  //   selectedResolution = widget.currentResolution;
  //   // ถ้า aspect ratio ที่ส่งมาไม่อยู่ใน map ให้ตั้งค่า default เป็น 4:3
  //   if (resolutionOptionsByAspectRatio.containsKey(widget.currentAspectRatio)) {
  //     selectedAspectRatio = widget.currentAspectRatio;
  //   } else {
  //     selectedAspectRatio = aspectRatio4by3;
  //   }
  // }

  // String resolutionPresetToString(ResolutionPreset preset) {
  //   switch (preset) {
  //     case ResolutionPreset.low:
  //       return 'Low';
  //     case ResolutionPreset.medium:
  //       return 'Medium';
  //     case ResolutionPreset.high:
  //       return 'High';
  //     case ResolutionPreset.veryHigh:
  //       return 'Very High';
  //     case ResolutionPreset.ultraHigh:
  //       return 'Ultra High';
  //     case ResolutionPreset.max:
  //       return 'Max';
  //     default:
  //       return preset.toString();
  //   }
  // }

  // String aspectRatioToString(double ratio) {
  //   if ((ratio - aspectRatio4by3).abs() < 0.01) return '4:3';
  //   if ((ratio - aspectRatio16by9).abs() < 0.01) return '16:9';
  //   if ((ratio - aspectRatio1by1).abs() < 0.01) return '1:1';
  //   return ratio.toStringAsFixed(2);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      // height: 320,
      // color: Colors.grey[900],
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const Text(
      //       'Aspect Ratio',
      //       style: TextStyle(
      //           color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      //     ),
      //     const SizedBox(height: 8),
      //     Wrap(
      //       spacing: 12,
      //       children: resolutionOptionsByAspectRatio.keys.map((ratio) {
      //         final isSelected = (ratio - selectedAspectRatio).abs() < 0.01;
      //         return ChoiceChip(
      //           label: Text(
      //             aspectRatioToString(ratio),
      //             style: TextStyle(color: isSelected ? Colors.white : Colors.grey[300]),
      //           ),
      //           selected: isSelected,
      //           selectedColor: Colors.blue,
      //           backgroundColor: Colors.grey[800],
      //           onSelected: (selected) {
      //             if (selected) {
      //               setState(() {
      //                 selectedAspectRatio = ratio;
      //                 // เปลี่ยน resolution ให้เป็นตัวแรกของ aspect ratio ใหม่
      //                 selectedResolution = resolutionOptionsByAspectRatio[selectedAspectRatio]![0];
      //               });
      //               widget.onAspectRatioChanged(ratio);
      //               widget.onResolutionChanged(selectedResolution);
      //             }
      //           },
      //         );
      //       }).toList(),
      //     ),
      //     const SizedBox(height: 24),
      //     const Text(
      //       'Resolution',
      //       style: TextStyle(
      //           color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      //     ),
      //     const SizedBox(height: 8),
      //     Wrap(
      //       spacing: 12,
      //       children: availableResolutions.map((preset) {
      //         final isSelected = preset == selectedResolution;
      //         return ChoiceChip(
      //           label: Text(resolutionPresetToString(preset),
      //               style:
      //                   TextStyle(color: isSelected ? Colors.white : Colors.grey[300])),
      //           selected: isSelected,
      //           selectedColor: Colors.blue,
      //           backgroundColor: Colors.grey[800],
      //           onSelected: (selected) {
      //             if (selected) {
      //               setState(() {
      //                 selectedResolution = preset;
      //               });
      //               widget.onResolutionChanged(preset);
      //             }
      //           },
      //         );
      //       }).toList(),
      //     ),
      //   ],
      // ),
    );
  }
}
