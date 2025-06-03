import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraSettingsPanel extends StatefulWidget {
  final ResolutionPreset currentResolution;
  final void Function(ResolutionPreset) onResolutionChanged;

  const CameraSettingsPanel({
    super.key,
    required this.currentResolution,
    required this.onResolutionChanged,
  });

  @override
  State<CameraSettingsPanel> createState() => _CameraSettingsPanelState();
}

class _CameraSettingsPanelState extends State<CameraSettingsPanel> {
  late ResolutionPreset selectedResolution;
  String? selectedAspectRatio;

  final Map<String, List<ResolutionPreset>> aspectRatioMap = {
    '4:3': [ResolutionPreset.low],
    '3:2': [ResolutionPreset.medium],
    '16:9': [
      ResolutionPreset.high,
      ResolutionPreset.veryHigh,
      ResolutionPreset.ultraHigh
    ],
    'Max': [ResolutionPreset.max],
  };

  String resolutionToString(ResolutionPreset preset) {
    switch (preset) {
      case ResolutionPreset.low:
        return '320x240';
      case ResolutionPreset.medium:
        return '720x480';
      case ResolutionPreset.high:
        return '1280x720';
      case ResolutionPreset.veryHigh:
        return '1920x1080';
      case ResolutionPreset.ultraHigh:
        return '3840x2160';
      case ResolutionPreset.max:
        return 'Max (device dependent)';
      default:
        return 'Unknown';
    }
  }

  @override
  void initState() {
    super.initState();
    selectedResolution = widget.currentResolution;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aspect Ratio',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: aspectRatioMap.keys.map((ratio) {
              final isSelected = selectedAspectRatio == ratio;
              return ChoiceChip(
                label: Text(
                  ratio,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[300]),
                ),
                selected: isSelected,
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[800],
                onSelected: (_) {
                  setState(() {
                    selectedAspectRatio = ratio;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          if (selectedAspectRatio != null) ...[
            Text(
              'Select Resolution (${selectedAspectRatio!})',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: aspectRatioMap[selectedAspectRatio]!
                  .map((preset) {
                    final isSelected = preset == selectedResolution;
                    return ChoiceChip(
                      label: Text(
                        resolutionToString(preset),
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey[300],
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.orange,
                      backgroundColor: Colors.grey[800],
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedResolution = preset;
                          });
                          widget.onResolutionChanged(preset);
                        }
                      },
                    );
                  })
                  .toList(),
            ),
          ]
        ],
      ),
    );
  }
}