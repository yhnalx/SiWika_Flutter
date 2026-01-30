import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/modules_progress.dart';
import '../utils/streak_manager.dart';

class FlashcardScreen extends StatefulWidget {
  // Pass the data through the constructor
  final List<Map<String, String>> cards;
  final String moduleId;

  const FlashcardScreen({
    super.key,
    required this.cards,
    required this.moduleId,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void flipCard() {
    setState(() {
      isFront ? _controller.forward() : _controller.reverse();
      isFront = !isFront;
    });
  }

  void nextCard() {
    // Uses widget.cards and widget.moduleId instead of hardcoded data
    final currentItem = widget.cards[index]["front"];
    if (currentItem != null) {
      ModuleProgress.markCompleted(widget.moduleId, currentItem);
    }

    StreakManager.registerActivity();

    if (index < widget.cards.length - 1) {
      setState(() {
        index++;
        isFront = true;
        _controller.reset();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void prevCard() {
    if (index > 0) {
      setState(() {
        index--;
        isFront = true;
        _controller.reset();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBackContent(String backData) {
    if (backData.contains('assets/') ||
        backData.endsWith('.png') ||
        backData.endsWith('.jpg')) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              backData,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "FSL Sign",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      );
    }
    return Center(
      child: Text(
        backData,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1CB0F6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reference widget.cards for everything
    if (widget.cards.isEmpty)
      return const Scaffold(body: Center(child: Text("No data")));

    final card = widget.cards[index];
    final double progress = (index + 1) / widget.cards.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const Text(
              "Tap to flip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFAFAFAF),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GestureDetector(
                onTap: flipCard,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final angle = _controller.value * pi;
                    final showFront = angle < pi / 2;
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Transform(
                          transform: Matrix4.rotationY(showFront ? 0 : pi),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: showFront
                                ? Center(
                                    child: Text(
                                      card["front"] ?? "?",
                                      style: const TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : _buildBackContent(card["back"] ?? "?"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: _buildNavButton(
                    label: "PREV",
                    color: Colors.white,
                    textColor: const Color(0xFF1CB0F6),
                    onPressed: index > 0 ? prevCard : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildNavButton(
                    label: index == widget.cards.length - 1 ? "FINISH" : "NEXT",
                    color: const Color(0xFF1CB0F6),
                    textColor: Colors.white,
                    onPressed: nextCard,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: onPressed == null
                ? []
                : [
                    const BoxShadow(
                      color: Color(0xFFE5E5E5),
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
