import 'package:flutter/material.dart';
import 'package:si_wika/data/fsl_alphabet.dart';
import 'package:si_wika/data/fsl_phrases.dart'; // Import your new phrases data
import 'package:si_wika/utils/modules_progress.dart';
import 'module_detail_screen.dart';

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Alphabet Data Setup ---
    final int completedLetters = ModuleProgress.completedCount("fsl_alphabet");
    final int totalLetters = FslAlphabet.letters.length;
    final double alphabetProgress = totalLetters > 0
        ? completedLetters / totalLetters
        : 0;
    final bool isAlphabetComplete = alphabetProgress >= 1.0;

    // --- Phrases Data Setup ---
    final int completedPhrases = ModuleProgress.completedCount("fsl_phrases");
    final int totalPhrases = FslPhrases.phrases.length;
    final double phrasesProgress = totalPhrases > 0
        ? completedPhrases / totalPhrases
        : 0;
    final bool isPhrasesComplete = phrasesProgress >= 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          "Course Modules",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF4B4B4B),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // 1. FSL ALPHABET (Always Unlocked)
          _buildModuleCard(
            context,
            id: "fsl_alphabet",
            title: "FSL Alphabet",
            description: "Master the A–Z hand signs",
            icon: Icons.sort_by_alpha,
            color: const Color(0xFFFFC800), // Duo Gold
            unlocked: true,
            progress: alphabetProgress,
            progressText: "$completedLetters / $totalLetters letters",
            isComplete: isAlphabetComplete,
          ),

          const SizedBox(height: 16),

          // 2. COMMON PHRASES (Gated by Alphabet completion)
          _buildModuleCard(
            context,
            id: "fsl_phrases",
            title: "Common Phrases",
            description: "Daily greetings and basics",
            icon: Icons.forum_rounded,
            color: const Color(0xFF1CB0F6), // Duo Blue
            unlocked: isAlphabetComplete, // <--- Gating Logic here
            progress: phrasesProgress,
            progressText: isAlphabetComplete
                ? "$completedPhrases / $totalPhrases phrases"
                : "Complete Alphabet to Unlock",
            isComplete: isPhrasesComplete,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool unlocked,
    required double progress,
    required String progressText,
    required bool isComplete,
  }) {
    return GestureDetector(
      onTap: !unlocked
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ModuleDetailScreen(
                  moduleId: id,
                  title: title,
                  description: description,
                ),
              ),
            ),
      child: Opacity(
        opacity: unlocked ? 1.0 : 0.6,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
            boxShadow: [
              BoxShadow(
                color: unlocked ? const Color(0xFFE5E5E5) : Colors.transparent,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: unlocked ? color : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  // Title and Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4B4B4B),
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Icon
                  Icon(
                    isComplete
                        ? Icons.check_circle
                        : (unlocked ? Icons.chevron_right : Icons.lock_rounded),
                    color: isComplete ? const Color(0xFF58CC02) : Colors.grey,
                  ),
                ],
              ),
              // Show progress bar only if the module is unlocked
              if (unlocked) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      progressText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFAFAFAF),
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE5E5E5),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ] else ...[
                // Custom text for locked modules
                const SizedBox(height: 12),
                Text(
                  progressText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
