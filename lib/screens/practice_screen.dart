import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:si_wika/data/fsl_alphabet.dart';

class PracticeGesturesScreen extends StatefulWidget {
  const PracticeGesturesScreen({super.key});

  @override
  State<PracticeGesturesScreen> createState() => _PracticeGesturesScreenState();
}

class _PracticeGesturesScreenState extends State<PracticeGesturesScreen> {
  // --- AI & Camera Logic ---
  CameraController? _cam;
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isBusy = false;
  bool _isModelReady = false;
  String _currentPrediction = "...";
  double _confidence = 0.0;

  // --- Practice Logic ---
  int _currentIndex = 0;
  final List<Map<String, String>> _gestures = FslAlphabet.letters;

  @override
  void initState() {
    super.initState();
    _setupAI();
  }

  Future<void> _setupAI() async {
    await _loadModel();
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use Front Camera for Practice
    final frontCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cam = CameraController(frontCam, ResolutionPreset.low, enableAudio: false);
    await _cam!.initialize();

    _cam!.startImageStream((image) {
      if (!_isModelReady || _isBusy) return;
      _runInference(image);
    });

    if (mounted) setState(() {});
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("assets/model/model.tflite");
      final labelsRaw = await DefaultAssetBundle.of(
        context,
      ).loadString("assets/model/labels.txt");
      _labels = labelsRaw
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _isModelReady = true;
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  Future<void> _runInference(CameraImage image) async {
    _isBusy = true;

    // 1. Conversion & Preprocessing (simplified for brevity)
    // In a real app, use the _yuv420ToImage logic from your snippet here

    // 2. Mocking prediction logic based on your snippet's output
    // For this example, let's assume the model returns a label string
    // logic to compare _currentPrediction with _gestures[_currentIndex]['front']

    if (mounted) {
      setState(() {
        // Update these based on your actual inference result
        _currentPrediction = "A"; // Mocking for now
        _confidence = 0.92;
      });

      // 3. AUTO-PROGRESS LOGIC
      // If the AI sees the correct sign with high confidence, move to next!
      if (_currentPrediction.toUpperCase() ==
              _gestures[_currentIndex]['front']?.toUpperCase() &&
          _confidence > 0.80) {
        _handleSuccess();
      }
    }
    _isBusy = false;
  }

  void _handleSuccess() {
    // Play a sound or vibrate here!
    if (_currentIndex < _gestures.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _cam?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _gestures[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Hand Sign Trainer",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Camera View (The "Mirror")
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 4),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  (_cam != null && _cam!.value.isInitialized)
                      ? CameraPreview(_cam!)
                      : const Center(child: CircularProgressIndicator()),

                  // AI Overlay Info
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "AI Sees: $_currentPrediction (${(_confidence * 100).toInt()}%)",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Target Instruction
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    "Show the letter:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    current['front'] ?? "",
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1CB0F6),
                    ),
                  ),
                  const Spacer(),
                  // "Skip" button if they are stuck
                  TextButton(
                    onPressed: _handleSuccess,
                    child: const Text(
                      "Can't do it? Skip for now",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
