import 'package:flutter/material.dart';

class QuizSummaryScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const QuizSummaryScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<QuizSummaryScreen> createState() => _QuizSummaryScreenState();
}

class _QuizSummaryScreenState extends State<QuizSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation =
        Tween<double>(
          begin: 0,
          end: widget.score / widget.totalQuestions,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            children: [
              const Text(
                "Lesson Complete!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF58CC02),
                ),
              ),
              const Spacer(),

              // ANIMATED SCORE SECTION
              Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative Glow behind the ring
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFC800).withOpacity(0.1),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _progressAnimation.value,
                          strokeWidth: 18,
                          backgroundColor: const Color(0xFFE5E5E5),
                          color: const Color(0xFFFFC800),
                          strokeCap: StrokeCap.round,
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "SCORE",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFAFAFAF),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        "${((widget.score / widget.totalQuestions) * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4B4B4B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // CHUNKY STATS ROW
              Row(
                children: [
                  Expanded(
                    child: _buildDuoStatCard(
                      "CORRECT",
                      "${widget.score}",
                      const Color(0xFF58CC02),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDuoStatCard(
                      "TOTAL",
                      "${widget.totalQuestions}",
                      const Color(0xFF1CB0F6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // CONTINUOUS BUTTON (3D DUO STYLE)
              _buildDuoButton(
                context,
                "CONTINUE",
                const Color(0xFF58CC02),
                const Color(0xFF46A302),
                () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDuoStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
        boxShadow: [
          const BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: color,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF4B4B4B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuoButton(
    BuildContext context,
    String text,
    Color color,
    Color shadowColor,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: shadowColor, offset: const Offset(0, 5)),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
