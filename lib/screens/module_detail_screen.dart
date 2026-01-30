import 'package:flutter/material.dart';
import 'package:si_wika/data/fsl_alphabet.dart';
import 'package:si_wika/data/fsl_phrases.dart';
import 'package:si_wika/utils/modules_progress.dart';
import 'flashcard_screen.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String moduleId;
  final String title;
  final String description;

  const ModuleDetailScreen({
    super.key,
    required this.moduleId,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> moduleCards = [];
    if (moduleId == "fsl_alphabet") {
      moduleCards = FslAlphabet.letters;
    } else if (moduleId == "fsl_phrases") {
      moduleCards = FslPhrases.phrases;
    }

    final int completed = ModuleProgress.completedCount(moduleId);
    final int total = moduleCards.length;
    final double progress = total > 0 ? completed / total : 0;
    final bool hasProgress = completed > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF4B4B4B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF777777),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 32),

            // --- PROGRESS CARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D3), // Light yellow/orange
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFC800), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Color(0xFFE0A100),
                        ),
                      ),
                      Text(
                        "$completed/$total",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Color(0xFFE0A100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFC800),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- INFO CARD ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1CB0F6), width: 2),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_rounded, color: Color(0xFF1CB0F6)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Learn signs using interactive flashcards. Progress is saved as you go!",
                      style: TextStyle(
                        color: Color(0xFF1899D6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // --- ACTIONS ---
            _buildBigButton(
              label: hasProgress ? "CONTINUE LEARNING" : "START LEARNING",
              icon: Icons.play_arrow_rounded,
              color: const Color(0xFF58CC02), // Duolingo Green
              shadowColor: const Color(0xFF46A302),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashcardScreen(
                      cards: moduleCards, // Pass the dynamic list
                      moduleId: moduleId, // Pass the ID for progress saving
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _buildBigButton(
              label: "ALPHABET QUIZ",
              icon: Icons.psychology_alt_rounded,
              color: hasProgress ? Colors.white : const Color(0xFFE5E5E5),
              textColor: hasProgress
                  ? const Color(0xFF1CB0F6)
                  : const Color(0xFFAFAFAF),
              shadowColor: hasProgress
                  ? const Color(0xFFE5E5E5)
                  : const Color(0xFFE5E5E5),
              borderColor: const Color(0xFFE5E5E5),
              onPressed: hasProgress
                  ? () {
                      /* Navigate to Quiz */
                    }
                  : null,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color shadowColor,
    required VoidCallback? onPressed,
    Color textColor = Colors.white,
    Color? borderColor,
  }) {
    final bool isDisabled = onPressed == null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor ?? shadowColor, width: 2),
          boxShadow: isDisabled
              ? []
              : [BoxShadow(color: shadowColor, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
